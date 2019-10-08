#!/bin/bash
docker build\
 -f Dockerfile\
 -t deephdc/deep-oc-mods:gpu .\
 --build-arg tf_ver='1.14.0-gpu'\
 $*
