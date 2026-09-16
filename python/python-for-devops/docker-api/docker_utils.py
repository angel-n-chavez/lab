import docker

def docker_metrics():
    # instance of docker client to communicate with the docker daemon
    client = docker.from_env()
    docker_images = client.images.list()

    return [image.tags for image in docker_images]
