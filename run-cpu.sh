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

docker run \
 --privileged \
 --name=deep-mods-cpu \
 --rm \
 -it \
 -p 5000:5000 \
 -p 6006:6006 \
 -p 8888:8888 \
 -v "$HOME"/.config:/root/.config \
 -e ONECLIENT_ACCESS_TOKEN=$ONECLIENT_ACCESS_TOKEN \
 -e ONECLIENT_PROVIDER_HOST=$ONECLIENT_PROVIDER_HOST \
 -e APP_INPUT_OUTPUT_BASE_DIR=/mnt/onedata/mods \
 deephdc/deep-oc-mods:cpu \
 $*
