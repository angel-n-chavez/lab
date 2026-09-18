import docker

client = docker.from_env()

def docker_images():
    """
    function that returns a list of docker images on a system
    """

    # instance of docker client to communicate with the docker daemon
    docker_images = client.images.list()

    return [image.tags for image in docker_images]

def docker_containers():
    """
    function that returns a list of running containers
    """
    running_containers = client.containers.list(all=True)

    return [
        {
            "id" : container.short_id,
            "name" : container.name,
            "status" : container.status,
            "image" : container.image.tags[0] if container.image.tags else "None"
        }
        for container in running_containers
    ]

def run_hello_world():
    """
    function that runs alpine hello world docker container
    """
    container = client.containers.run('alpine','sleep 30', detach=True)
    output_bytes = container.logs()

    return output_bytes.decode("utf-8").strip()
