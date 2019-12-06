#!/bin/bash
docker build\
 -f Dockerfile\
 -t deephdc/deep-oc-mods:gpu\
 .\
 --build-arg tf_ver='2.0.0-gpu'\
 $*
