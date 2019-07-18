FROM nvidia/cuda:10.1-cudnn7-devel-ubuntu18.04
LABEL maintainer="Edgar Y. Walker <edgar.walker@gmail.com>"

# Deal with pesky Python 3 encoding issue
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

# Install essential Ubuntu packages
# and upgrade pip
RUN apt-get update &&\
    apt-get install -y software-properties-common \
                       build-essential \
                       git \
                       wget \
                       vim \
                       curl \
                       zip \
                       zlib1g-dev \
                       unzip \
                       pkg-config \
                       libblas-dev \
                       liblapack-dev \
                       python3-tk \
                       python3-wheel \
                       graphviz \
                       libhdf5-dev \
                       swig &&\
    add-apt-repository -y ppa:deadsnakes/ppa &&\
    apt install -y python3.7 \
                   python3.7-dev &&\
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
    python3.7 get-pip.py &&\
    ln -s /usr/bin/python3.7 /usr/local/bin/python &&\
    ln -s /usr/bin/python3.7 /usr/local/bin/python3 &&\
    apt-get clean &&\
    # best practice to keep the Docker image lean
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

WORKDIR /src

# Install essential Python packages
RUN pip3 --no-cache-dir install \
         pytest \
         numpy \
         matplotlib \
         scipy \
         pandas \
         jupyter \
         scikit-learn \
         seaborn \
         graphviz \
         gpustat \
         https://download.pytorch.org/whl/cu100/torch-1.1.0-cp37-cp37m-linux_x86_64.whl \
         h5py \
         torchvision \
         jupyterlab
RUN pip3 --no-cache-dir install --pre datajoint


# Add profiling library support
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:${LD_LIBRARY_PATH}

# Export port for Jupyter Notebook
EXPOSE 8888

# Add Jupyter Notebook config
ADD ./jupyter_notebook_config.py /root/.jupyter/

WORKDIR /notebooks

# By default start running jupyter notebook
ENTRYPOINT ["jupyter", "lab", "--allow-root"]
