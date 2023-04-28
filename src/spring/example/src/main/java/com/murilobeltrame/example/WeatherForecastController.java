package com.murilobeltrame.example;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@RestController
public class WeatherForecastController {

    private final String[] summaries = new String[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    @GetMapping("/weather-forecasts")
    List<WeatherForecast> get() throws NoSuchAlgorithmException {
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
