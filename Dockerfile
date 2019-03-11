ARG tag=1.12.0
ARG pyVer=py36

# Base image
FROM deephdc/tensorflow:${tag}-${pyVer}

LABEL maintainer='Stefan Dlugolinsky'
LABEL version='0.3.1'
LABEL description='MODS (Massive Online Data Streams)'

# What user branch to clone (!)
ARG branch=master

# Install ubuntu updates and related stuff
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         git \
         curl

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

# Disable FLAAT authentication by default
ENV DISABLE_AUTHENTICATION_AND_ASSUME_AUTHENTICATED_USER yes

# Install user app:
RUN git clone -b $branch https://github.com/deephdc/mods.git && \
    cd  mods && \
    pip3 install --no-cache-dir -e . && \
    rm -rf /root/.cache/pip3/* && \
    rm -rf /tmp/* && \
    cd ..

# Open DEEPaaS port
EXPOSE 5000

CMD ["sh", "-c", "deepaas-run --openwhisk-detect --listen-ip 0.0.0.0"]
