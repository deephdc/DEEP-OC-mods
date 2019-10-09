#!/bin/bash
docker build\
 -f Dockerfile\
 -t deephdc/deep-oc-mods:test\
 .\
 $*
