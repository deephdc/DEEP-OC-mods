# Base image
FROM ubuntu:18.04

LABEL maintainer='Stefan Dlugolinsky'
LABEL version='0.1.0'
LABEL description='MODS (Massive Online Data Streams) container'

# Install ubuntu updates and python related stuff
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
         git \
         curl \
         python3-setuptools \
         python3-pip \
         build-essential \
         python3-dev \
         python3-wheel

RUN pip3 install --upgrade pip

# install rclone
RUN curl https://downloads.rclone.org/rclone-current-linux-amd64.deb --output rclone-current-linux-amd64.deb && \
    dpkg -i rclone-current-linux-amd64.deb && \
    apt install -f && \
    rm rclone-current-linux-amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /tmp/*

ENV LANG C.UTF-8

# Set the working directory
WORKDIR /srv

# Install user app:
RUN git clone https://github.com/deephdc/mods.git && \
    cd  mods && \
    pip3 install --no-cache-dir -e . && \
    rm -rf /root/.cache/pip3/* && \
    rm -rf /tmp/* && \
    cd ..

#####
# Your code may download necessary data automatically or 
# you force the download during docker build. Example below is for latter case:
#ENV Resnet50Data DogResnet50Data.npz
#ENV S3STORAGE https://s3-us-west-1.amazonaws.com/udacity-aind/dog-project/
#RUN curl -o ./dogs_breed_det/models/bottleneck_features/${Resnet50Data} \
#    ${S3STORAGE}${Resnet50Data}


# Open DEEPaaS port
EXPOSE 5000

CMD deepaas-run --listen-ip 0.0.0.0
