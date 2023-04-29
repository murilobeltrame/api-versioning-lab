package com.murilobeltrame.example;

import com.murilobeltrame.example.v1.WeatherForecastControllerV1;
import com.murilobeltrame.example.v2.WeatherForecastControllerV2;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springdoc.core.customizers.ActuatorOpenApiCustomizer;
import org.springdoc.core.customizers.OpenApiCustomizer;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfiguration {
    @Bean
    public GroupedOpenApi apiV1() {
        return GroupedOpenApi.builder()
                .group("v1")
                .addOpenApiCustomizer(openApi -> {
                    var info = new Info();
                    info.setVersion("1.0");
                    openApi.setInfo(info);
                })
                .packagesToScan(WeatherForecastControllerV1.class.getPackageName())
                .build();
    }

    @Bean
    public GroupedOpenApi apiV2() {
        return GroupedOpenApi.builder()
                .group("v2")
                .addOpenApiCustomizer(openApi -> {
                    var info = new Info();
                    info.setVersion("2.0");
                    openApi.setInfo(info);
                })
                .packagesToScan(WeatherForecastControllerV2.class.getPackageName())
                .build();
    }
}
