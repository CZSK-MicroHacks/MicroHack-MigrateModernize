package com.microsoft.migration.assets.worker.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// TODO: When deploying to Azure with a user-assigned managed identity, the DefaultAzureCredentialBuilder
// needs the managed identity client ID set via .managedIdentityClientId(clientId) — otherwise it cannot
// resolve the correct identity on hosts with multiple identities (e.g., Container Apps).
//
// HINT: Consider exposing a shared TokenCredential @Bean so other components (e.g., ServiceBusConfig)
// can also inject it. Use @ConditionalOnMissingBean to avoid conflicts with Spring Cloud Azure auto-config.
// The client ID is available via the property: spring.cloud.azure.credential.client-id
@Configuration
public class AwsS3Config {

    @Value("${azure.storage.blob.endpoint}")
    private String endpoint;

    @Bean
    BlobServiceClient blobServiceClient() {
        return new BlobServiceClientBuilder()
                .endpoint(endpoint)
                .credential(new DefaultAzureCredentialBuilder().build())
                .buildClient();
    }
}