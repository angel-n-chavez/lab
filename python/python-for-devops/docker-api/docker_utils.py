import docker

# instance of docker client to communicate with the docker daemon
client = docker.from_env()

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
            "id" : container.short_id,
            "name" : container.name,
            "status" : container.status,
            "image" : container.image.tags[0] if container.image.tags else "None"
        }
        for container in running_containers
    ]

def run_container(image: str, command: str):
    """
    function that takes in 2 str parameters/args 'image' type to run
    and a 'command' command to run inside the container
    """
    container = client.containers.run(image, command, detach=True)

    container.wait()    # freezes terminal until container stops then returns exit code

    output_bytes = container.logs()
    container_info = {
        "id" : container.short_id,
        "logs" : output_bytes.decode("utf-8").strip()
    }

    return container_info
