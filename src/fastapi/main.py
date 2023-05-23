import random
from datetime import datetime, timedelta
from fastapi import FastAPI
from fastapi_versioning import VersionedFastAPI, version

from models.weatherforecast import WeatherForecast

app = FastAPI(title="FastApi App")


def get():
    summaries = ["Freezing", "Bracing", "Chilly", "Cool", "Mild",
                 "Warm", "Balmy", "Hot", "Sweltering", "Scorching"]
    return [WeatherForecast(
        date=datetime.now()+timedelta(days=i),
        temperature_c=random.randint(-20, 55),
        summary=summaries[random.randint(0, len(summaries) - 1)]) for i in range(1, 5)]


@app.get('/v1/weatherforecast')
@version(1)
async def get_weatherforecast_v1():
    return get()


@app.get('/v2/weatherforecast')
@version(2)
async def get_weatherforecast_v2():
    return get()

app = VersionedFastAPI(
    app,
    version_format='{major}',
    prefix_format='/v{major}')
