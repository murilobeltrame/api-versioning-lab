package com.murilobeltrame.example;

import com.murilobeltrame.example.v1.WeatherForecastControllerV1;
import com.murilobeltrame.example.v2.WeatherForecastControllerV2;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfiguration {
    @Bean
    public GroupedOpenApi apiV1() {
        return GroupedOpenApi.builder()
                .group("v1")
                .packagesToScan(WeatherForecastControllerV1.class.getPackageName())
                .build();
    }

    @Bean
    public GroupedOpenApi apiV2() {
        return GroupedOpenApi.builder()
                .group("v2")
                .packagesToScan(WeatherForecastControllerV2.class.getPackageName())
                .build();
    }
}
