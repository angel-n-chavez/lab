from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from docker_utils import docker_images, docker_containers, run_hello_world

app = FastAPI(title="Docker Utils API")

@app.get("/docker-images")
def get_docker_images():
    """
    This API gets the docker metrics from daemon running on my dev machine
    """

    return docker_images()

@app.get("/running-containers")
def get_running_containers():
    """
    This API gets a list of all of the running containers on my dev machine
    """

    return docker_containers()

@app.post("/run-alpine")
def run_container():
    """
    This API sends a request to run a basic alpine 'Hello World' container
    """

    try:
        result = run_hello_world()
        return {"status" : "sucess", "status" : result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
