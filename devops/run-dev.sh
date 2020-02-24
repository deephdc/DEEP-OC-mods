#!/bin/bash

if [[ -z $ONECLIENT_ACCESS_TOKEN ]] || [[ -z $ONECLIENT_PROVIDER_HOST ]]; then
	echo \
"""
Please set the environment variables:

export ONECLIENT_ACCESS_TOKEN=
export ONECLIENT_PROVIDER_HOST=
"""
	exit
fi

docker run\
 --privileged\
 --name=deep-oc-mods-dev\
 --rm\
 -it\
 -p 5000:5000\
 -v ${HOME}/.config/rclone:/root/.config/rclone\
 -v "$(pwd)"/../../mods:/srv/mods\
 -v "$(pwd)"/../../deepaas:/srv/deepaas\
 -e ONECLIENT_ACCESS_TOKEN=$ONECLIENT_ACCESS_TOKEN \
 -e ONECLIENT_PROVIDER_HOST=$ONECLIENT_PROVIDER_HOST \
 -e APP_INPUT_OUTPUT_BASE_DIR=/mnt/onedata/mods \
 deep-oc-mods:dev\
 /bin/bash
