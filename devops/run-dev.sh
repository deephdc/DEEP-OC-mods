#!/bin/bash
docker run\
 --privileged\
 --name=deep-oc-mods-dev\
 --rm\
 -it\
 -p 5000:5000\
 -v ${HOME}/.config/rclone:/root/.config/rclone\
 -v "$(pwd)"/../../mods:/srv/mods\
 -v "$(pwd)"/../../deepaas:/srv/deepaas\
 -e ONECLIENT_ACCESS_TOKEN= \
 -e ONECLIENT_PROVIDER_HOST=oneprovider.fedcloud.eu \
 -e APP_INPUT_OUTPUT_BASE_DIR=/mnt/onedata/mods \
 deep-oc-mods:dev\
 /bin/bash
