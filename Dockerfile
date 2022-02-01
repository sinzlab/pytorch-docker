FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu18.04
LABEL maintainer="Edgar Y. Walker <edgar.walker@gmail.com>"

# Deal with pesky Python 3 encoding issue
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV MPLLOCALFREETYPE 1

RUN apt-get update && apt-get install -y software-properties-common

# Add Python ppa
RUN add-apt-repository ppa:deadsnakes/ppa

# Install essential Ubuntu packages
# and upgrade pip
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    vim \
    curl \
    zip \
    zlib1g-dev \
    unzip \
    pkg-config \
    libgl-dev \
    libblas-dev \
    liblapack-dev \
    python3-tk \
    python3-wheel \
    graphviz \
    libhdf5-dev \
    python3.9 \
    python3.9-dev \
    python3.9-distutils \
    swig \
    apt-transport-https \
    lsb-release \
    libpng-dev \
    ca-certificates &&\
    # obtain latest of nodejs
    curl -sL https://deb.nodesource.com/setup_12.x | bash - &&\
    apt install -y nodejs &&\
    apt-get clean &&\
    ln -s /usr/bin/python3.9 /usr/local/bin/python &&\
    ln -s /usr/bin/python3.9 /usr/local/bin/python3 &&\
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
    python3 get-pip.py &&\
    rm get-pip.py &&\
    # best practice to keep the Docker image lean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /src

# Install essential Python packages
RUN python3 -m pip --no-cache-dir install \
    blackcellmagic\
    pytest \
    pytest-cov \
    numpy \
    matplotlib \
    scipy \
    pandas \
    jupyter \
    scikit-learn \
    scikit-image \
    seaborn \
    graphviz \
    gpustat \
    h5py \
    gitpython \
    ptvsd \
    Pillow==6.1.0 \
    opencv-python
RUN python3 -m pip --no-cache-dir install \
    torch==1.10.2+cu113 \
    torchvision==0.11.3+cu113 \
    torchaudio===0.10.2+cu113 \
    -f https://download.pytorch.org/whl/cu113/torch_stable.html \
    'jupyterlab>=2' \
    xeus-python

RUN python3 -m pip --no-cache-dir install datajoint==0.12.9


# Add profiling library support
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:${LD_LIBRARY_PATH}

# Export port for Jupyter Notebook
EXPOSE 8888

# Install and enable JupyterLab Debugger extension
RUN jupyter labextension install @jupyterlab/debugger

# Add Jupyter Notebook config
ADD ./jupyter_lab_config.py /root/.jupyter/

WORKDIR /notebooks

# By default start running jupyter notebook
ENTRYPOINT ["jupyter", "lab", "--allow-root"]
