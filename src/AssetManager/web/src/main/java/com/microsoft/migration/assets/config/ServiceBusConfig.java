package com.microsoft.migration.assets.config;

import com.azure.core.credential.TokenCredential;
import com.azure.core.exception.ResourceNotFoundException;
import com.azure.messaging.servicebus.administration.ServiceBusAdministrationClient;
import com.azure.messaging.servicebus.administration.ServiceBusAdministrationClientBuilder;
import com.azure.messaging.servicebus.administration.models.QueueProperties;
import com.azure.spring.messaging.ConsumerIdentifier;
import com.azure.spring.messaging.PropertiesSupplier;
import com.azure.spring.messaging.servicebus.core.DefaultServiceBusNamespaceProducerFactory;
import com.azure.spring.messaging.servicebus.core.ServiceBusProducerFactory;
import com.azure.spring.messaging.servicebus.core.ServiceBusTemplate;
import com.azure.spring.messaging.servicebus.core.properties.NamespaceProperties;
import com.azure.spring.messaging.servicebus.core.properties.ProcessorProperties;
import com.azure.spring.cloud.service.servicebus.properties.ServiceBusEntityType;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ServiceBusConfig {

    /** Queue name — set via SERVICE_BUS_QUEUE_NAME env var, defaults to "image-processing" */
    @Value("${azure.servicebus.queue.name:image-processing}")
    private String queueName;

    @Value("${spring.cloud.azure.servicebus.namespace:}")
    private String serviceBusNamespace;

    public String getQueueName() {
        return queueName;
    }

    @Bean
    ServiceBusAdministrationClient adminClient(TokenCredential credential) {
        String fqdn = serviceBusNamespace.contains(".") ? serviceBusNamespace : serviceBusNamespace + ".servicebus.windows.net";
        return new ServiceBusAdministrationClientBuilder()
                .credential(fqdn, credential)
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
    ServiceBusProducerFactory serviceBusProducerFactory() {
        NamespaceProperties namespaceProperties = new NamespaceProperties();
        namespaceProperties.setNamespace(serviceBusNamespace);
        namespaceProperties.setEntityType(ServiceBusEntityType.QUEUE);
        return new DefaultServiceBusNamespaceProducerFactory(namespaceProperties);
    }

    @Bean
    @ConditionalOnMissingBean
    ServiceBusTemplate serviceBusTemplate(ServiceBusProducerFactory producerFactory) {
        return new ServiceBusTemplate(producerFactory);
    }
}
