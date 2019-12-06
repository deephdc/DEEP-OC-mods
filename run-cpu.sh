#!/bin/bash
docker run\
 --name=deep-mods-cpu\
 --rm\
 -d\
 -p 5000:5000\
 -v "$HOME"/.config:/root/.config\
 deephdc/deep-oc-mods:cpu
