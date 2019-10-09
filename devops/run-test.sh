#!/bin/bash

if [ ! -e ./mount/ ]; then
	mkdir mount
fi

docker run\
 --name=deep-mods-test\
 --rm\
 -it\
 -p 5000:5000\
 -v "$HOME"/.config:/root/.config\
 -v "$(pwd)"/mount/models:/srv/mods/models\
 -v "$(pwd)"/mount/data:/srv/mods/data\
 deephdc/deep-oc-mods:test
