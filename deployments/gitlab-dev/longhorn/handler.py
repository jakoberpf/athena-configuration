import client
import common
import functions

longhorn_url = 'http://longhorn-frontend.longhorn-system/v1' # 'http://localhost:8080/v1'

functions.get_client()

volumes_to_create = functions.get_volumes_from_config("config.yaml")

client = client.Client(url=longhorn_url)

def get_volume_by_name(client, name):
    volumes = client.list_volume()
    if check_if_volume_exists_in_volumes(name, volumes):
        for volume in volumes:
            if volume.name == name:
                return volume

def check_if_volume_exists(client, name):
    volumes = client.list_volume()
    return check_if_volume_exists_in_volumes(name, volumes)

def check_if_volume_exists_in_volumes(name, volumes):
    for volume in volumes:
        if volume.name == name:
            return True
    return False

# Create or update volumes
for volume in volumes_to_create:
    print("[info] Provisioning volume: " + volume.name)
    if not check_if_volume_exists(client, volume.name):
        common.create_and_check_volume(client, volume.name, volume.size)
    longhorn_volume = get_volume_by_name(client, volume.name)
    print("[trace] Longhorn volume state: %s" % (longhorn_volume))
    if volume.pv is not None:
        print("[debug] PV %s defined for volume %s" % (volume.pv, volume.name))
        common.create_pv_for_volume(client, common.get_core_api_client(), longhorn_volume, volume.pv)
    if volume.pvc is not None:
        print("[debug] PVC %s defined for volume %s" % (volume.pvc, volume.name))
        common.create_pvc_for_volume(client, common.get_core_api_client(), longhorn_volume, volume.pvc)

print("[exit] Finished provisioning longhorn volumes")