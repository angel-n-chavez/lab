import docker
from docker.errors import NotFound
from requests.exceptions import ReadTimeout

# instance of docker client to communicate with the docker daemon
client = docker.from_env()

CONTAINER_WAIT_TIMEOUT = 15  # bounds how long a request can block on a client-supplied cmd


def get_images():
    """
    function that returns a list of docker images on a system
    """
    docker_images = client.images.list()
    return [image.tags for image in docker_images]


def get_containers(all_containers: bool = True):
    """
    function that returns a list of running containers
    """

    # filters based on boolean passed into REST query param
    running_containers = client.containers.list(all=all_containers)
    return [
        {
            "id": container.short_id,
            "name": container.name,
            "status": container.status,
            "image": container.image.tags[0] if container.image.tags else "None"
        }
        for container in running_containers
    ]


def run_container(image: str, command: str, timeout: int = CONTAINER_WAIT_TIMEOUT):
    """
    Runs a container, waits for it to exit, and returns its id + logs.
    The conatainer always removed after
    """
    container = client.containers.run(image, command, detach=True)
    try:
        container.wait(timeout=timeout)    # freezes terminal until container stops then returns exit code
    except ReadTimeout:
        container.stop(timeout=5)
        container.remove()
        raise TimeoutError(f"Container exceeded {timeout}s and was stopped")

    output_bytes = container.logs()
    container_info = {
        "id": container.short_id,
        "logs": output_bytes.decode("utf-8").strip()
    }

    return container_info
