# Base image
FROM deephdc/tensorflow:1.12.0-py36

LABEL maintainer='Stefan Dlugolinsky'
LABEL version='0.2.0'
LABEL description='MODS (Massive Online Data Streams)'

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

# Install user app:
RUN git clone https://github.com/deephdc/mods.git && \
    cd  mods && \
    rm requirements.txt && \
    ln -s requirements/requirements-cpu-notf.txt requirements.txt && \
    pip3 install --no-cache-dir -e . && \
    rm -rf /root/.cache/pip3/* && \
    rm -rf /tmp/* && \
    cd ..

# Open DEEPaaS port
EXPOSE 5000

CMD deepaas-run --listen-ip 0.0.0.0
