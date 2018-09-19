# Base image, e.g. tensorflow/tensorflow:1.7.0
FROM ubuntu:18.04

LABEL maintainer='Stefan Dlugolinsky'
LABEL version='0.0.1'
# MODS - Massive Online Data Streams


# Install ubuntu updates and python related stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
         git \
         curl \
         wget \
         python-setuptools \
         python-pip \
         python-wheel && \ 
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /tmp/*


# Set the working directory
WORKDIR /srv

# Install user app:
RUN git clone https://github.com/Stifo/mods && \
    cd  mods && \
    pip install --no-cache-dir -e . && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /tmp/* && \
    cd ..

# Install DEEPaaS:
RUN git clone https://github.com/indigo-dc/deepaas && \
    cd deepaas && \
    pip install --no-cache-dir -U . && \
    rm -rf /root/.cache/pip/* && \
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

CMD deepaas-run
