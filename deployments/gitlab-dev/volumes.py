import longhorn.client
import longhorn.common
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
    def __init__(self, name, size, pv, pvc):
        self.name = name
        self.size = str(size * Gi)
        self.pv = pv
        self.pvc = pvc

volumes = []

volumes.append(VolumeDefinition("gitlab-dev-postgresql-data-0", 8, "data-gitlab-dev-postgresql-0", "data-gitlab-dev-postgresql-0"))
# volumes.append(VolumeDefinition("test-gitlab-dev-minio", 10, "gitlab-dev-minio", ""))
# volumes.append(VolumeDefinition("test-gitlab-dev-prometheus-server", 8, "gitlab-dev-prometheus-server", "gitlab-prometheus-server"))
# volumes.append(VolumeDefinition("test-gitlab-dev-redis-master-0", 8, "redis-data-gitlab-dev-redis-master-0", "redis-data-gitlab-redis-master-0"))
# volumes.append(VolumeDefinition("test-gitlab-dev-gitaly-data-0", 8, "repo-data-gitlab-dev-gitaly-0", "repo-data-gitlab-gitaly-0"))

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
    if not longhorn.common.backing_image_feature_supported(client):
        backing_image = None
    client.create_volume(name=volume_name, size=size,
                         numberOfReplicas=num_of_replicas,
                         backingImage=backing_image, frontend=frontend)
    volume = longhorn.common.wait_for_volume_detached(client, volume_name)
    assert volume.name == volume_name
    assert volume.size == size
    assert volume.numberOfReplicas == num_of_replicas
    assert volume.state == "detached"
    if longhorn.common.backing_image_feature_supported(client):
        assert volume.backingImage == backing_image
    assert volume.frontend == frontend
    assert volume.created != ""
    return volume

client = longhorn.client.Client(url=longhorn_url)

# Volume operations
# List all volumes
# volumes = client.list_volume()

for volume in volumes:
    print(volume.name)
    create_and_check_volume(client, volume.name, volume.size)