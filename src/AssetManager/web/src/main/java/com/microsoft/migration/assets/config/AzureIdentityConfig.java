package com.microsoft.migration.assets.config;

import com.azure.core.credential.TokenCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AzureIdentityConfig {

    @Value("${spring.cloud.azure.credential.client-id:}")
    private String clientId;

    @Bean
    @ConditionalOnMissingBean(TokenCredential.class)
    TokenCredential tokenCredential() {
        DefaultAzureCredentialBuilder builder = new DefaultAzureCredentialBuilder();
        if (clientId != null && !clientId.isEmpty()) {
            builder.managedIdentityClientId(clientId);
        }
        return builder.build();
    }
}
