#!/bin/bash
docker run\
 --name=deep-oc-mods-dev\
 --rm\
 -it\
 -p 5000:5000\
 -v ${HOME}/.config/rclone:/root/.config/rclone\
 -v "$(pwd)"/../../mods:/srv/mods\
 -v "$(pwd)"/../../deepaas:/srv/deepaas\
 deep-oc-mods:dev\
 /bin/bash
