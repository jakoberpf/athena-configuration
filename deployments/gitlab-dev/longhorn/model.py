Ki = 1024
Mi = (1024 * 1024)
Gi = (1024 * Mi)


class VolumeDefinition():
    def __init__(self, name, namespace, size, pv, pvc):
        self.name = name
        self.namespace = namespace
        self.size = str(size * Gi)
        self.pv = pv
        self.pvc = pvc


class ClientDefinition():
    def __init__(self, endpoint_url, endpoint_version, backup_endpoint, backup_secret):
        self.endpoint_url = endpoint_url
        self.endpoint_version = endpoint_version
        self.backup_endpoint = backup_endpoint
        self.backup_secret = backup_secret