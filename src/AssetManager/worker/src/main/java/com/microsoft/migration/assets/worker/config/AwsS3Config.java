package com.microsoft.migration.assets.worker.config;

import com.azure.core.credential.TokenCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class AwsS3Config {

    @Value("${azure.storage.blob.endpoint}")
    private String endpoint;

    @Value("${spring.cloud.azure.credential.client-id:}")
    private String clientId;

    @Bean
    @ConditionalOnMissingBean
    TokenCredential azureTokenCredential() {
        DefaultAzureCredentialBuilder builder = new DefaultAzureCredentialBuilder();
        if (clientId != null && !clientId.isEmpty()) {
            builder.managedIdentityClientId(clientId);
        }
        return builder.build();
    }

    @Bean
    @Primary
    BlobServiceClient blobServiceClient(TokenCredential credential) {
        return new BlobServiceClientBuilder()
                .endpoint(endpoint)
                .credential(credential)
                .buildClient();
    }
}