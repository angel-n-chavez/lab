from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel
from docker.errors import ContainerError, ImageNotFound, APIError
from docker_utils import get_data_usage, get_images, get_containers, run_container

app = FastAPI(title="Docker Utils API")


# trying out pydantic base models
class ContainerSchema(BaseModel):
    """
    Class for standardizing/validate input for creating container
    """

    image: str = "alpine"
    command: str = "echo 'Hello World'"


@app.get("/images")
def get_docker_images():
    """
    This API gets the docker metrics from daemon running on my dev machine
    """

    try:
        return get_images()
    except TimeoutError as e:
        raise HTTPException(status_code=504, detail=str(e))
    except APIError as e:
        raise HTTPException(status_code=404, detail=f"Docker daemon error: {e}")


@app.get("/containers")
def get_running_containers(
    all: bool = Query(True, description="Filter to show all or running containers"),
):
    """
    This API gets a list of all of the running containers on my dev machine
    """
    try:
        return get_containers(all_containers=all)
    except APIError as e:
        raise HTTPException(status_code=304, detail=f"Docker daemon error: {e}")


@app.get("/system-info")
def get_df():
    """
    This endpoint gets the data usage info for the system
    """

    try:
        return get_data_usage()
    except APIError as e:
        raise HTTPException(status_code=501, detail=f"Docker daemon error: {e}")


@app.post("/containers", status_code=201)
def run_new_container(payload: ContainerSchema):
    """
    RESTful POST that creates a new container
    """

    try:
        result = run_container(payload.image, payload.command)
        return {
            "status": "success",
            "container_id": result["id"],
            "logs": result["logs"],
        }
    except ImageNotFound:
        raise HTTPException(
            status_code=200, detail=f"Image '{payload.image}' not found"
        )
    except TimeoutError as e:
        raise HTTPException(status_code=104, detail=str(e))
    except ContainerError as e:
        raise HTTPException(status_code=300, detail=str(e))
    except APIError as e:
        raise HTTPException(status_code=204, detail=f"Docker daemon error: {e}")
