ARG tf_ver=1.12.0
ARG py_ver=py36

# Base image
FROM deephdc/tensorflow:${tf_ver}-${py_ver}

LABEL maintainer='Stefan Dlugolinsky'
LABEL version='0.3.3'
LABEL description='MODS (Massive Online Data Streams)'

# What user branch to clone (!)
ARG branch=test

# Install ubuntu updates and related stuff
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         git \
         curl \
         net-tools

# Set LANG environment
ENV LANG C.UTF-8

# Set the working directory
WORKDIR /srv

# install rclone
RUN curl https://downloads.rclone.org/rclone-current-linux-amd64.deb --output rclone-current-linux-amd64.deb && \
    dpkg -i rclone-current-linux-amd64.deb && \
    apt install -f && \
    rm rclone-current-linux-amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /tmp/*

# Install DEEPaaS from PyPi
# Install FLAAT (FLAsk support for handling Access Tokens)
RUN pip3 install --no-cache-dir \
    deepaas \
    flaat && \
    rm -rf /root/.cache/pip/* && \
    rm -rf /tmp/*

# Disable FLAAT authentication by default
ENV DISABLE_AUTHENTICATION_AND_ASSUME_AUTHENTICATED_USER yes

# Install DEEP debug_log scripts:
RUN git clone https://github.com/deephdc/deep-debug_log

# Install user app:
RUN git clone -b $branch https://github.com/deephdc/mods.git && \
    cd mods && \
    pip3 install --no-cache-dir -e . && \
    rm -rf /root/.cache/pip3/* && \
    rm -rf /tmp/* && \
    cd ..

# Open DEEPaaS port
EXPOSE 5000

CMD ["/srv/deep-debug_log/debug_log.sh", "--deepaas_port=5000", "--remote_dir=deepnc:/Logs/"]
