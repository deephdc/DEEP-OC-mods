#!/bin/bash
docker run\
 --name=deep-mods\
 --rm\
 -it\
 -p 5000:5000\
 -v ${HOME}/.config:/root/.config\
 -v $(HOME)/.oidc-agent:/root/.oidc-agent\
 -v $(HOME)/work/DEEP/mods:/srv/mods\
 deephdc/deep-oc-mods-dev\
 /bin/bash
