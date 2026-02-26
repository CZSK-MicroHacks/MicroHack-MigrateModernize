# Copilot Instructions – AssetManager MicroHack

## Project Overview

This is a **Spring Boot 3.5.0 / Java 21** multi-module Maven application being migrated to Azure Container Apps. It consists of:

- **web** module: REST API + Thymeleaf UI for image upload/download/listing
- **worker** module: Background service that consumes Azure Service Bus messages and generates thumbnails

The app has been containerized (Dockerfiles exist) but has **several runtime issues** that need to be fixed before it runs correctly on Azure.

## Azure Services Used

- **Azure Blob Storage** – image file storage (using `azure-storage-blob` SDK)
- **Azure Service Bus** – async messaging between web and worker (queue: `image-processing`)
- **Azure Database for PostgreSQL Flexible Server** – metadata persistence with passwordless auth
- **Azure Container Registry** – Docker image hosting
- **Azure Container Apps** – hosting runtime with user-assigned managed identity
- **Azure Key Vault** – secrets management

## Known Issues & Patterns

### 1. Spring Cloud Azure Service Bus Auto-Configuration

This project uses **Spring Cloud Azure 4.19.0** (`spring-cloud-azure-dependencies` BOM). There is a critical dependency gap:

- `spring-messaging-azure-servicebus` provides the Spring messaging API classes (`ServiceBusTemplate`, `@ServiceBusListener`, `ServiceBusProducerFactory`, etc.)
- But it does **NOT** transitively include the Azure SDK transport library (`azure-messaging-servicebus`)
- Spring Cloud Azure auto-configuration uses `@ConditionalOnClass(ServiceBusClientBuilder.class)` — without the transport library on the classpath, the entire auto-config chain is silently skipped
- This means beans like `AzureServiceBusProperties`, `ServiceBusTemplate`, `ServiceBusProducerFactory`, and `ServiceBusProcessorFactory` will **not** be created automatically

**Key classes to know about:**
- `DefaultServiceBusNamespaceProducerFactory` – creates Service Bus sender clients
- `DefaultServiceBusNamespaceProcessorFactory` – creates Service Bus processor clients (for consumers)
- `ServiceBusMessageListenerContainerFactory` – required by `@ServiceBusListener` annotation (bean name: `azureServiceBusListenerContainerFactory`)
- `NamespaceProperties` – holds namespace and entity type configuration
- `ServiceBusEntityType.QUEUE` – entity type for queue-based messaging

### 2. Managed Identity Configuration

The app uses a **user-assigned managed identity** on Azure Container Apps. Key considerations:

- `DefaultAzureCredentialBuilder` must have `.managedIdentityClientId(clientId)` set when using user-assigned identity
- The client ID is available via `spring.cloud.azure.credential.client-id` property (set via `AZURE_CLIENT_ID` env var)
- A shared `TokenCredential` bean should be exposed so all Azure SDK clients can use it
- Use `@ConditionalOnMissingBean` when defining the `TokenCredential` bean to avoid conflicts

### 3. PostgreSQL Passwordless Authentication

- Uses `spring-cloud-azure-starter-jdbc-postgresql` for Entra ID authentication
- JDBC URL must include: `authenticationPluginClassName=com.azure.identity.extensions.jdbc.postgresql.AzurePostgresqlAuthenticationPlugin`
- `SPRING_DATASOURCE_USERNAME` should be the managed identity **name** (not the client ID)

### 4. Azure Storage Networking

- When deploying Azure Storage with managed identity auth (no shared key access), ensure the storage account's **network configuration** allows connectivity from Azure Container Apps
- A 403 `AuthorizationFailure` response does not always mean RBAC is wrong — it can also indicate network-level blocking

### 5. Infrastructure as Code

When creating Bicep/Terraform for this application, the following resources are needed:
- Resource Group
- User-Assigned Managed Identity (with RBAC assignments on all resources)
- Container Registry (with AcrPull role for the managed identity)
- Storage Account + blob container (with Storage Blob Data Contributor role)
- Service Bus Namespace + queue (with Azure Service Bus Data Sender and Data Receiver roles)
- PostgreSQL Flexible Server + database (with Entra AD admin configured)
- Container Apps Environment (with Log Analytics workspace)
- Two Container Apps (web with external ingress, worker with no ingress)

## Application Properties Mapping

Environment variables map to Spring properties as follows:
- `AZURE_CLIENT_ID` → `spring.cloud.azure.credential.client-id`
- `SERVICE_BUS_NAMESPACE` → `spring.cloud.azure.servicebus.namespace`
- `AZURE_STORAGE_BLOB_ENDPOINT` → `azure.storage.blob.endpoint`
- `AZURE_STORAGE_CONTAINER_NAME` → `azure.storage.blob.container-name`
- `SPRING_DATASOURCE_URL` → `spring.datasource.url`
- `SPRING_DATASOURCE_USERNAME` → `spring.datasource.username`

## Code Style

- Spring Boot conventions with `@Configuration` classes
- Uses Lombok (`@RequiredArgsConstructor`, `@Slf4j`)
- `@Profile("!dev")` for Azure services, `@Profile("dev")` for local development
- Service layer pattern with interface + implementation
