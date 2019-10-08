#!/bin/bash
docker run\
 --gpus all\
 --name=deep-mods-gpu\
 --rm\
 -it\
 -p 5000:5000\
 -v "$HOME"/.config:/root/.config\
 deephdc/deep-oc-mods:gpu
