package com.murilobeltrame.example;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

public class WeatherForecast {
    @Getter
    @Setter
    private Instant date;

    @Getter
    @Setter
    private int temperatureC;

    @Getter
    private final int temperatureF = 32 + (int)(temperatureC / 0.5556) ;

    @Getter
    @Setter
    private String summary;

    WeatherForecast(Instant date, int temperatureC, String summary){
        setDate(date);
        setTemperatureC(temperatureC);
        setSummary(summary);
    }
}
