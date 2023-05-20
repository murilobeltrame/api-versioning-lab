import datetime
import string


class WeatherForecast:
    def __init__(self, date: datetime, temperature_c: int, summary: string):
        self.date = date
        self.temperature_c = temperature_c
        self.summary = summary
        self.temperature_f = int(32 + temperature_c / 0.5556)
