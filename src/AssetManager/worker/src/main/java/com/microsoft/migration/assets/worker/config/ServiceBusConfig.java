package com.microsoft.migration.assets.worker.config;

import com.azure.core.credential.TokenCredential;
import com.azure.core.exception.ResourceNotFoundException;
import com.azure.messaging.servicebus.administration.ServiceBusAdministrationClient;
import com.azure.messaging.servicebus.administration.ServiceBusAdministrationClientBuilder;
import com.azure.messaging.servicebus.administration.models.QueueProperties;
import com.azure.spring.messaging.ConsumerIdentifier;
import com.azure.spring.messaging.PropertiesSupplier;
import com.azure.spring.messaging.servicebus.core.DefaultServiceBusNamespaceProcessorFactory;
import com.azure.spring.messaging.servicebus.core.ServiceBusProcessorFactory;
import com.azure.spring.messaging.servicebus.core.properties.NamespaceProperties;
import com.azure.spring.messaging.servicebus.core.properties.ProcessorProperties;
import com.azure.spring.messaging.servicebus.implementation.core.config.ServiceBusMessageListenerContainerFactory;
import com.azure.spring.cloud.service.servicebus.properties.ServiceBusEntityType;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ServiceBusConfig {

    @Value("${azure.servicebus.queue.name:image-processing}")
    private String queueName;

    @Value("${spring.cloud.azure.servicebus.namespace}")
    private String namespace;

    public String getQueueName() {
        return queueName;
    }

    @Bean
    ServiceBusAdministrationClient adminClient(TokenCredential credential) {
        String fqns = namespace.contains(".") ? namespace : namespace + ".servicebus.windows.net";
        return new ServiceBusAdministrationClientBuilder()
                .credential(fqns, credential)
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

    @Bean
    @ConditionalOnMissingBean
    ServiceBusProcessorFactory serviceBusProcessorFactory(TokenCredential credential) {
        NamespaceProperties namespaceProperties = new NamespaceProperties();
        namespaceProperties.setNamespace(namespace);
        namespaceProperties.setEntityType(ServiceBusEntityType.QUEUE);
        DefaultServiceBusNamespaceProcessorFactory factory =
                new DefaultServiceBusNamespaceProcessorFactory(namespaceProperties);
        factory.setDefaultCredential(credential);
        return factory;
    }

    @Bean("azureServiceBusListenerContainerFactory")
    @ConditionalOnMissingBean(name = "azureServiceBusListenerContainerFactory")
    ServiceBusMessageListenerContainerFactory azureServiceBusListenerContainerFactory(
            ServiceBusProcessorFactory processorFactory) {
        return new ServiceBusMessageListenerContainerFactory(processorFactory);
    }
}
