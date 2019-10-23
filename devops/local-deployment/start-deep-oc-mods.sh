#!/usr/bin/env bash

docker pull deephdc/deep-oc-mods:latest

docker run\
  -d\
  --rm\
  --name deep-oc-mods\
  -p 5000:5000\
  -v "$(pwd)"/volume/.config/:/root/.config\
  -v "$(pwd)"/volume/log:/srv/deep-debug_log/log\
  -v "$(pwd)"/volume/data:/srv/mods/data\
  -v "$(pwd)"/volume/models:/srv/mods/models\
  -v "$(pwd)"/volume/checkpoints:/srv/mods/checkpoints/\
  deephdc/deep-oc-mods\
  deepaas-run --openwhisk-detect --listen-ip 0.0.0.0 --listen-port=5000
