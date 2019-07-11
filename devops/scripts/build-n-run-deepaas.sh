#!/bin/bash
# This is a helper script, which automatically installs mods and deepaas. After a successfull build, it executes deepaas.
cd deepaas/ && \
pip3 install -U . && \
cd .. && \
cd mods/ && \
pip3 install -e . && \
cd .. && \
deepaas-run --openwhisk-detect --listen-ip 0.0.0.0 --listen-port 5000
