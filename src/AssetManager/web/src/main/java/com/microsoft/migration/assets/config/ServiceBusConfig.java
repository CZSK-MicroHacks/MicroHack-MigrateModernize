package com.microsoft.migration.assets.config;

import com.azure.core.credential.TokenCredential;
import com.azure.core.exception.ResourceNotFoundException;
import com.azure.messaging.servicebus.administration.ServiceBusAdministrationClient;
import com.azure.messaging.servicebus.administration.ServiceBusAdministrationClientBuilder;
import com.azure.messaging.servicebus.administration.models.QueueProperties;
import com.azure.spring.cloud.autoconfigure.implementation.servicebus.properties.AzureServiceBusProperties;
import com.azure.spring.messaging.ConsumerIdentifier;
import com.azure.spring.messaging.PropertiesSupplier;
import com.azure.spring.messaging.servicebus.core.properties.ProcessorProperties;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// TODO: The AzureServiceBusProperties bean injected into adminClient() is created by Spring Cloud Azure
// auto-configuration, but the auto-config chain requires ServiceBusClientBuilder.class on the classpath.
// If the azure-messaging-servicebus dependency is missing from pom.xml, this bean will NOT be created
// and you'll get NoSuchBeanDefinitionException at startup.
//
// HINT: Consider replacing AzureServiceBusProperties with a @Value-injected namespace property
// (spring.cloud.azure.servicebus.namespace). Also, Spring Cloud Azure 4.x auto-config may not
// automatically create ServiceBusProducerFactory and ServiceBusTemplate beans — you may need to
// define them explicitly using DefaultServiceBusNamespaceProducerFactory and NamespaceProperties.
@Configuration
public class ServiceBusConfig {

    /** Queue name — set via SERVICE_BUS_QUEUE_NAME env var, defaults to "image-processing" */
    @Value("${azure.servicebus.queue.name:image-processing}")
    private String queueName;

    public String getQueueName() {
        return queueName;
    }

    @Bean
    ServiceBusAdministrationClient adminClient(AzureServiceBusProperties properties, TokenCredential credential) {
        return new ServiceBusAdministrationClientBuilder()
                .credential(properties.getFullyQualifiedNamespace(), credential)
                .buildClient();
    }

    @Bean
    QueueProperties imageProcessingQueue(ServiceBusAdministrationClient adminClient) {
        try {
            return adminClient.getQueue(queueName);
        } catch (ResourceNotFoundException e) {
            return adminClient.createQueue(queueName);
        }
    }

    @Bean
    PropertiesSupplier<ConsumerIdentifier, ProcessorProperties> processorPropertiesSupplier() {
        return key -> {
            ProcessorProperties processorProperties = new ProcessorProperties();
            processorProperties.setAutoComplete(false);
            return processorProperties;
        };
    }
}
