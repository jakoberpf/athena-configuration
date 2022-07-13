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

volumes_to_create = []

volumes_to_create.append(VolumeDefinition("gitlab-dev-postgresql-data-0", 8, "data-gitlab-dev-postgresql-0", "data-gitlab-dev-postgresql-0"))
volumes_to_create.append(VolumeDefinition("gitlab-dev-minio", 10, "gitlab-dev-minio", ""))
volumes_to_create.append(VolumeDefinition("gitlab-dev-prometheus-server", 8, "gitlab-dev-prometheus-server", "gitlab-prometheus-server"))
volumes_to_create.append(VolumeDefinition("gitlab-dev-redis-master-0", 8, "redis-data-gitlab-dev-redis-master-0", "redis-data-gitlab-redis-master-0"))
volumes_to_create.append(VolumeDefinition("gitlab-dev-gitaly-data-0", 8, "repo-data-gitlab-dev-gitaly-0", "repo-data-gitlab-gitaly-0"))

client = longhorn.client.Client(url=longhorn_url)

def check_if_volume_exists(client, volumename):
    volumes = client.list_volume()
    for volume in volumes:
        if volume.name == volumename:
            return True
    return False

# Create or update volumes
for volume in volumes_to_create:
    print(volume.name)
    if not check_if_volume_exists(client, volume.name):
        longhorn.common.create_and_check_volume(client, volume.name, volume.size)