#!/usr/bin/env bash

docker pull deephdc/deep-oc-mods:gpu

docker run\
  --gpus all\
  -d\
  --rm\
  --name deep-oc-mods-gpu\
  -p 5000:5000\
  -v "$(pwd)"/volume/.config/:/root/.config\
  -v "$(pwd)"/volume/log/:/srv/deep-debug_log/log\
  -v "$(pwd)"/volume/data/:/srv/mods/data\
  -v "$(pwd)"/volume/models/:/srv/mods/models\
  -v "$(pwd)"/volume/checkpoints/:/srv/mods/checkpoints\
  deephdc/deep-oc-mods:gpu\
  deepaas-run --openwhisk-detect --listen-ip 0.0.0.0 --listen-port=$PORT0
