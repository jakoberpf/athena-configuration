import longhorn
import time

Ki = 1024
Mi = (1024 * 1024)
Gi = (1024 * Mi)

RETRY_COUNTS = 300
RETRY_INTERVAL = 0.5

VOLUME_FIELD_STATE = "state"
VOLUME_STATE_ATTACHED = "attached"
VOLUME_STATE_DETACHED = "detached"

# If automation/scripting tool is inside the same cluster in which Longhorn is installed
longhorn_url = 'http://longhorn-frontend.longhorn-system/v1'
# If forwarding `longhorn-frontend` service to localhost
longhorn_url = 'http://localhost:8080/v1'

class VolumeDefinition():
    def __init__(self, name, size):
        self.name = name
        self.size = str(size * Gi)

volumes = []

volumes.append(VolumeDefinition("gitlab-dev-postgresql-data-0", 8))
volumes.append(VolumeDefinition("gitlab-dev-minio", 8))
volumes.append(VolumeDefinition("gitlab-dev-prometheus-server", 8))
volumes.append(VolumeDefinition("gitlab-dev-redis-master-0", 8))
volumes.append(VolumeDefinition("gitlab-dev-gitaly-data-0", 8))

# this function will check if backing image feature is supported, and is added
# for the case of test_upgrade starting from Longhorn <= v1.1.0
def backing_image_feature_supported(client):
    if hasattr(client.by_id_schema("backingImage"), "id"):
        return True
    else:
        return False

def wait_for_volume_detached(client, name):
    return wait_for_volume_status(client, name,
                                  VOLUME_FIELD_STATE,
                                  VOLUME_STATE_DETACHED)

def wait_for_volume_status(client, name, key, value):
    wait_for_volume_creation(client, name)
    for i in range(RETRY_COUNTS):
        volume = client.by_id_volume(name)
        if volume[key] == value:
            break
        time.sleep(RETRY_INTERVAL)
    assert volume[key] == value, f" value={value}\n. \
            volume[key]={volume[key]}\n. volume={volume}"
    return volume

def wait_for_volume_creation(client, name):
    for i in range(RETRY_COUNTS):
        volumes = client.list_volume()
        found = False
        for volume in volumes:
            if volume.name == name:
                found = True
                break
        if found:
            break
        time.sleep(RETRY_INTERVAL)
    assert found


def create_and_check_volume(client, volume_name, size, num_of_replicas=3, backing_image="", frontend="blockdev"):
    """
    Create a new volume with the specified parameters. Assert that the new
    volume is detached and that all of the requested parameters match.
    :param client: The Longhorn client to use in the request.
    :param volume_name: The name of the volume.
    :param num_of_replicas: The number of replicas the volume should have.
    :param size: The size of the volume, as a string representing the number
    of bytes.
    :param backing_image: The backing image to use for the volume.
    :param frontend: The frontend to use for the volume.
    :return: The volume instance created.
    """
    if not backing_image_feature_supported(client):
        backing_image = None
    client.create_volume(name=volume_name, size=size,
                         numberOfReplicas=num_of_replicas,
                         backingImage=backing_image, frontend=frontend)
    volume = wait_for_volume_detached(client, volume_name)
    assert volume.name == volume_name
    assert volume.size == size
    assert volume.numberOfReplicas == num_of_replicas
    assert volume.state == "detached"
    if backing_image_feature_supported(client):
        assert volume.backingImage == backing_image
    assert volume.frontend == frontend
    assert volume.created != ""
    return volume

client = longhorn.Client(url=longhorn_url)

# Volume operations
# List all volumes
# volumes = client.list_volume()

for volume in volumes:
    print(volume.name)
    create_and_check_volume(client, volume.name, volume.size)