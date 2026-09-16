from fastapi import FastAPI
from docker_utils import docker_metrics

app = FastAPI(title="Docker Utils API")

@app.get("/docker-metrics")
def get_docker_metrics():
    """
    This API gets the docker metrics from daemon running on my dev machine
    """
    return docker_metrics()
