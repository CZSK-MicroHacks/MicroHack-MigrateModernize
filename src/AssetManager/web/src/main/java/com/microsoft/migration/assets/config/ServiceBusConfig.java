package com.microsoft.migration.assets.config;

import com.azure.core.credential.TokenCredential;
import com.azure.spring.cloud.service.servicebus.properties.ServiceBusEntityType;
import com.azure.spring.messaging.servicebus.core.DefaultServiceBusNamespaceProducerFactory;
import com.azure.spring.messaging.servicebus.core.ServiceBusProducerFactory;
import com.azure.spring.messaging.servicebus.core.ServiceBusTemplate;
import com.azure.spring.messaging.servicebus.core.properties.NamespaceProperties;
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
    ServiceBusProducerFactory serviceBusProducerFactory(TokenCredential credential) {
        NamespaceProperties namespaceProperties = new NamespaceProperties();
        namespaceProperties.setNamespace(namespace);
        namespaceProperties.setEntityType(ServiceBusEntityType.QUEUE);
        DefaultServiceBusNamespaceProducerFactory factory =
                new DefaultServiceBusNamespaceProducerFactory(namespaceProperties);
        factory.setDefaultCredential(credential);
        return factory;
    }

    @Bean
    ServiceBusTemplate serviceBusTemplate(ServiceBusProducerFactory producerFactory) {
        ServiceBusTemplate template = new ServiceBusTemplate(producerFactory);
        template.setDefaultEntityType(ServiceBusEntityType.QUEUE);
        return template;
    }
}
