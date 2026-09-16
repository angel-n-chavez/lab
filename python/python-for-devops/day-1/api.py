from fastapi import FastAPI
from system_utils import check_system_info

app = FastAPI(title="Devops Utils API")

@app.get("/hello")  # decorator for when someone goes to https://myurl.com/hello it will call the hello() function
def hello():
    """
    This API is Hello World, my first api from scratch using FastAPI.
    """
    return {"message" : "Hello Angel, Welcome To Devops Utils API"}

@app.get("/metrics")
def metrics():
    """
    This API gets the system metrics of my laptop i.e. cpu, mem, disk
    """
    return check_system_info()
