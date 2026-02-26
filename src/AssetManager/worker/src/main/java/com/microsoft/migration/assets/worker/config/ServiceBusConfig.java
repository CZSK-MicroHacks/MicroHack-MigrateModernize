package com.microsoft.migration.assets.worker.config;

import com.azure.core.credential.TokenCredential;
import com.azure.spring.cloud.service.servicebus.properties.ServiceBusEntityType;
import com.azure.spring.messaging.ConsumerIdentifier;
import com.azure.spring.messaging.PropertiesSupplier;
import com.azure.spring.messaging.implementation.annotation.EnableAzureMessaging;
import com.azure.spring.messaging.servicebus.core.DefaultServiceBusNamespaceProcessorFactory;
import com.azure.spring.messaging.servicebus.core.ServiceBusProcessorFactory;
import com.azure.spring.messaging.servicebus.core.properties.NamespaceProperties;
import com.azure.spring.messaging.servicebus.core.properties.ProcessorProperties;
import com.azure.spring.messaging.servicebus.implementation.core.config.ServiceBusMessageListenerContainerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAzureMessaging
public class ServiceBusConfig {

    @Value("${azure.servicebus.queue.name:image-processing}")
    private String queueName;

    @Value("${spring.cloud.azure.servicebus.namespace}")
    private String namespace;

    public String getQueueName() {
        return queueName;
    }

    @Bean
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
    ServiceBusMessageListenerContainerFactory serviceBusMessageListenerContainerFactory(
            ServiceBusProcessorFactory processorFactory) {
        return new ServiceBusMessageListenerContainerFactory(processorFactory);
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
