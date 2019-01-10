#!/bin/bash
docker run -d\
 -p 5000:5000\
 -v /Users/stevo/workspaces/deep/workspace/CURRENT/volumes/root/.config/:/root/.config\
 -v /Users/stevo/workspaces/deep/workspace/CURRENT/deepaas/:/srv/deepaas\
 -v /Users/stevo/workspaces/deep/workspace/CURRENT/mods/:/srv/mods\
 --name deep-mods-dev deep-mods:dev
