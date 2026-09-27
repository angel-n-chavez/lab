import docker
from requests.exceptions import ReadTimeout

# instance of docker client to communicate with the docker daemon
client = docker.from_env()

CONTAINER_WAIT_TIMEOUT = (
    15  # bounds how long a request can block on a client-supplied cmd
)


def get_images():
    """
    function that returns a list of docker images on a system
    """
    images = client.images.list()
    return [
        {"Image": img.tags, "ID": img.short_id, "Labels": img.labels} for img in images
    ]


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
            "image": container.image.tags[0] if container.image.tags else "None",
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
        container.wait(
            timeout=timeout
        )  # freezes terminal until container stops then returns exit code
    except ReadTimeout:
        container.stop(timeout=5)
        container.remove()
        raise TimeoutError(f"Container exceeded {timeout}s and was stopped")

    output_bytes = container.logs()
    container_info = {
        "id": container.short_id,
        "logs": output_bytes.decode("utf-8").strip(),
    }

    container.remove()
    return container_info


def get_data_usage():
    """
    Gets data usage info. Return type: dict. Raises: docker.errors.APIError
    """

    disk_usage = client.df()

    # 1. Calculate Image Sizes
    images = disk_usage.get("Images", [])
    total_image_size = sum(img.get("Size", 0) for img in images)

    # Identify dangling images (no RepoTags or RepoTags is None/empty)
    dangling_images = [img for img in images if not img.get("RepoTags")]
    reclaimable_image_size = sum(img.get("Size", 0) for img in dangling_images)

    # 2. Calculate Container Sizes
    containers = disk_usage.get("Containers", [])
    # SizeRw is the container's unique write layer size on disk
    total_container_size = sum(c.get("SizeRw", 0) for c in containers)

    # Reclaimable container space comes from 'exited' or 'dead' containers
    stopped_containers = [c for c in containers if c.get("State") in ["exited", "dead"]]
    reclaimable_container_size = sum(c.get("SizeRw", 0) for c in stopped_containers)

    # 3. Convert bytes to Megabytes for readability
    return {
        "images": {
            "total_count": len(images),
            "total_size_mb": round(total_image_size / (1024 * 1024), 2),
            "reclaimable_size_mb": round(reclaimable_image_size / (1024 * 1024), 2),
        },
        "containers": {
            "total_count": len(containers),
            "stopped_count": len(stopped_containers),
            "total_size_mb": round(total_container_size / (1024 * 1024), 2),
            "reclaimable_size_mb": round(reclaimable_container_size / (1024 * 1024), 2),
        },
    }

    return disk_usage
