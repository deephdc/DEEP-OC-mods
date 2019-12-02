ARG tf_ver=2.0.0
ARG py_ver=py3

# Base image
FROM tensorflow/tensorflow:${tf_ver}-${py_ver}

LABEL maintainer='Stefan Dlugolinsky'
LABEL version='1.0.0'
LABEL description='MODS (Massive Online Data Streams)'

# What user branch to clone (!)
ARG branch_mods="test"
# What DEEPaaS branch to clone (!)
ARG branch_deepaas="WIP/api_v2"
# If to install JupyterLab
ARG jlab=true

# Install ubuntu updates and related stuff
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y --no-install-recommends \
         git \
         curl \
         net-tools && \
    pip3 install --upgrade pip

# Set LANG environment
ENV LANG C.UTF-8

# Set the working directory
WORKDIR /srv

# install rclone
RUN curl https://downloads.rclone.org/rclone-current-linux-amd64.deb --output rclone-current-linux-amd64.deb && \
    dpkg -i rclone-current-linux-amd64.deb && \
    apt install -f && \
    mkdir /srv/.rclone/ && touch /srv/.rclone/rclone.conf && \
    rm rclone-current-linux-amd64.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# Install DEEPaaS from PyPi
RUN pip3 install --no-cache-dir \
    deepaas && \
    rm -rf /root/.cache/pip3/* && \
    rm -rf /tmp/*

# Disable FLAAT authentication by default
ENV DISABLE_AUTHENTICATION_AND_ASSUME_AUTHENTICATED_USER yes

# Install DEEP debug_log scripts:
RUN git clone https://github.com/deephdc/deep-debug_log

# Install JupyterLab
ENV JUPYTER_CONFIG_DIR /srv/.jupyter/
ENV SHELL /bin/bash
RUN if [ "$jlab" = true ]; then \
       apt update && \
       apt install -y nodejs npm && \
       apt-get clean && \
       rm -rf /var/lib/apt/lists/* && \
       rm -rf /tmp/* && \
       pip3 install --no-cache-dir jupyterlab ; \
       rm -rf /root/.cache/pip3/* && \
       rm -rf /tmp/* && \
       git clone https://github.com/deephdc/deep-jupyter /srv/.jupyter ; \
    else echo "[INFO] Skip JupyterLab installation!"; fi

# Install DEEPaaS:
RUN git clone -b $branch_deepaas https://github.com/indigo-dc/DEEPaaS.git && \
    cd DEEPaaS && \
    pip3 install --no-cache-dir -U . && \
    rm -rf /root/.cache/pip3/* && \
    rm -rf /tmp/* && \
    cd ..

# Install user app:
RUN git clone -b $branch_mods https://github.com/deephdc/mods.git && \
    cd mods && \
    pip3 install --no-cache-dir -e . && \
    rm -rf /root/.cache/pip3/* && \
    rm -rf /tmp/* && \
    cd ..

# Open DEEPaaS port
EXPOSE 5000

#CMD ["/srv/deep-debug_log/debug_log.sh", "--deepaas_port=5000", "--remote_dir=deepnc:/Logs/"]
CMD ["deepaas-run", "--openwhisk-detect", "--listen-ip", "0.0.0.0", "--listen-port", "5000"] 
