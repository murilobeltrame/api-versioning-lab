package com.murilobeltrame.example.v1;

import com.murilobeltrame.example.WeatherForecast;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/v1/weather-forecasts")
@OpenAPIDefinition(info = @Info(version = "1.0"))
public class WeatherForecastControllerV1 {

    private final String[] summaries = new String[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    @GetMapping("/")
    List<WeatherForecast> getV1() throws NoSuchAlgorithmException {
        var forecasts = new ArrayList<WeatherForecast>();
        var random = SecureRandom.getInstanceStrong();
        for (var i=0; i< 5; i++) {
            var temperature = random.ints(-20,55)
                    .findFirst()
                    .getAsInt();
            var forecast = new WeatherForecast(Instant.now().plus(i, ChronoUnit.DAYS), temperature, summaries[i]);
            forecasts.add(forecast);
        }
        return forecasts;
    }
}
