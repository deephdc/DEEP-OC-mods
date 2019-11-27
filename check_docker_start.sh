#!/usr/bin/env bash
# -*- coding: utf-8 -*-
#
# Copyright (c) 2017 - 2019 Karlsruhe Institute of Technology - Steinbuch Centre for Computing
# This code is distributed under the MIT License
# Please, see the LICENSE file
#
# @author: vykozlov

### info
# the bash script starts a DEEP-OC container
# and checks that the default execution is ok 
# (defined in the CMD field of the Dockerfile)
# by requesting get_metadata method.
# Also checks if various fields are present in the response.
###

### Main configuration
# Default Docker image, can be re-defiend
DOCKER_IMAGE=deephdc/deep-oc-generic
META_DATA_FIELDS=("name\":" "Author\":" "License\":" "Author-email\":")
# Container name: number of seconds since 1970 + a random number
CONTAINER_NAME=$(date +%s)"_"$(($RANDOM))
# DEEPaaS Port inside the container
DEEPaaS_PORT=5000
###

### Usage message (params can be re-defined) ###
USAGEMESSAGE="Usage: $0 <docker_image>"

# function to remove the Docker container
function remove_container() 
{   echo "[INFO]: Now removing ${CONTAINER_NAME} container"
    docker stop ${CONTAINER_NAME}
    docker rm ${CONTAINER_NAME}
}

#### Parse input ###
arr=("$@")
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    # print usagemessage
    shopt -s xpg_echo
    echo $USAGEMESSAGE
    exit 1
elif [ $# -eq 1 ]; then
    DOCKER_IMAGE=$1
else
    # Wrong number of arguments is given (!=1)
    echo "[ERROR] Wrong number of arguments provided!"
    shopt -s xpg_echo    
    echo $USAGEMESSAGE
    exit 2
fi

# Start docker, let system to bind the port
echo "[INFO] Starting Docker image ${DOCKER_IMAGE}"
echo "[INFO] Container name: ${CONTAINER_NAME}"
docker run --name ${CONTAINER_NAME} -p ${DEEPaaS_PORT} ${DOCKER_IMAGE} &

HOST_PORT=""
port_ok=false
max_try=5     # max number of tries to get HOST_PORT
itry=1        # initial try number

sleep 10
# Figure out which host port was binded
while [ "$port_ok" == false ] && [ $itry -lt $max_try ];
do
    HOST_PORT=$(docker inspect -f '{{ (index (index .NetworkSettings.Ports "'"$DEEPaaS_PORT/tcp"'") 0).HostPort }}'  ${CONTAINER_NAME})
    # Check that HOST_PORT is a number
    # https://stackoverflow.com/questions/806906/how-do-i-test-if-a-variable-is-a-number-in-bash
    if [ ! -z "${HOST_PORT##*[!0-9]*}" ]; then
        port_ok=true
        echo "[INFO] Bind the HOST_PORT=${HOST_PORT}"
    else
        echo "[INFO] Did not get a right HOST_PORT (yet). Try #"$itry
        sleep 10
        let itry=itry+1
    fi
done

# If could not bind a port, delete the container and exit
if [[ $itry -ge $max_try ]]; then
    echo "======="
    echo "[ERROR] Did not bind a right HOST_PORT (tries = $itry). Exiting..."
    remove_container
    exit 3
fi


# Trying to access the deployment
c_url="http://localhost:${HOST_PORT}/models/"
c_args_h1="Accept: application/json"

max_try=10     # max number of tries to access DEEPaaS API
itry=1         # initial try number
running=false

while [ "$running" == false ] && [ $itry -lt $max_try ];
do
   curl_call=$(curl -s -X GET $c_url -H "$c_args_h")
   if (echo $curl_call | grep -q 'id\":') then
       echo "[INFO] Service is responding (tries = $itry)"
       running=true
   else
       echo "[INFO] Service is NOT (yet) responding. Try #"$itry
       sleep 10
       let itry=itry+1
   fi
done

# If could not access the deployment, delete the container and exit
if [[ $itry -ge $max_try ]]; then
    echo "======="
    echo "[ERROR] DEEPaaS API does not respond (tries = $itry). Exiting..."
    remove_container
    exit 4
fi

# Access the running DEEPaaS API. Check that various fields are present
curl_call=$(curl -s -X GET $c_url -H "$c_args_h")
fields_ok=true
fields_missing=()

for field in ${META_DATA_FIELDS[*]}
do
   if (echo $curl_call | grep -iq $field) then
       echo "[INFO] $field is present in the get_metadata() response."
   else
       echo "[ERROR] $field is NOT present in the get_metadata() response."
       fields_ok=false
       fields_missing+=($field)
   fi
done

echo "======="
# If some fields are missing, print them, delete the container and exit
if [ "$fields_ok" == false ]; then
   echo "[ERROR] The following fields are missing: (${fields_missing[*]}). Exiting..."
   remove_container
   exit 5
fi

# if got here, all worked fine
echo "[SUCCESS]: DEEPaaS API starts"
echo "[SUCCESS]: Successfully checked for: (${META_DATA_FIELDS[*]})."
remove_container
echo "[SUCCESS] Finished. Exit with the code 0 (success)"
exit 0
