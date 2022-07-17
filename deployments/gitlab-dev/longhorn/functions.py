#!/usr/bin/env python

import getopt, sys
import client
import yaml

from model import ClientDefinition, VolumeDefinition

def get_default_client_config():
    return ClientDefinition(
        endpoint_url='http://longhorn-frontend.longhorn-system',
        endpoint_version="v1",
        backup_endpoint='',
        backup_secret=''
    )

def get_client():
    config = get_default_client_config()

    # Remove 1st argument from the list of command line arguments
    argumentList = sys.argv[1:]
    
    # Options
    options = "h:"
    
    # Long options
    long_options = ["help", "endpoint="]
    
    try:
        # Parsing argument
        arguments, values = getopt.getopt(argumentList, options, long_options)
        
        # checking each argument
        for currentArgument, currentValue in arguments:
    
            if currentArgument in ("-h", "--help"):
                print ("[info] Displaying Help ...")

            elif currentArgument in ("--endpoint"):
                print (("[info] Running agains custom endpoint (% s)") % (currentValue))
                config.set_endpoint(currentValue)
                
            # elif currentArgument in ("-m", "--My_file"):
            #     print ("Displaying file_name:", sys.argv[0])
                
    except getopt.error as err:
        # output error, and return with an error code
        print(str(err))

def load_config(path):
    with open(path, "r") as stream:
        try:
            print("[info] Loading config from " + path)
            return yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)

def get_settings_from_config():
    print("TODO")

def get_volumes_from_config(path):
    config = load_config(path)
    volumes = []
    for volume in config['volumes']:
        print("[info] Loading volume definition " + volume['name'])
        volumes.append(VolumeDefinition(
            volume['name'],            
            volume['size'], 
            volume['pv'],
            volume['pvc']
            )
        )
    return volumes
