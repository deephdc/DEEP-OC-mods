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

if [[ -z $APP_INPUT_OUTPUT_BASE_DIR ]]; then
	APP_INPUT_OUTPUT_BASE_DIR=/srv/mods
	echo \
"""
APP_INPUT_OUTPUT_BASE_DIR is not set. Using $APP_INPUT_OUTPUT_BASE_DIR
"""
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
 -e APP_INPUT_OUTPUT_BASE_DIR=$APP_INPUT_OUTPUT_BASE_DIR \
 deephdc/deep-oc-mods:cpu \
 $*
