#!/bin/bash
docker run\
 --privileged\
 --name=deep-mods\
 --rm\
 -it\
 -p 5000:5000\
 -v "$HOME"/.config:/root/.config\
 deephdc/deep-oc-mods:cpu
