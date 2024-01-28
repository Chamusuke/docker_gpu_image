# pull base image
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV PYTHONUNBUFFERED=TRUE \
    PYTHONDONTWRITEBYTECODE=TRUE \
    TZ="Asia/Tokyo" \
    LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:en \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=utility,compute,graphics \
    PATH=$PATH:/opt/conda/bin \
    DEBIAN_FRONTEND=noninteractive \
    XLA_FLAGS=--xla_gpu_cuda_data_dir=/usr/local/cuda-11.8

RUN apt-get -qq -y update && \
    apt-get -y install \
        build-essential \
        libopencv-dev \
        libnvinfer8 \
        libnvinfer-plugin8 \
        wget \
        gcc \
        cmake \
        vim \
        git\
        zip \
        xvfb \
        tzdata \
        locales \
        apt-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN cd /usr/lib/x86_64-linux-gnu && \
    ln -s libnvinfer.so.8 libnvinfer.so.7 && \
    ln -s libnvinfer_plugin.so.8 libnvinfer_plugin.so.7

RUN apt update
RUN apt install -y python3.10
RUN apt install -y python3-pip

RUN pip install --upgrade pip
RUN pip install --upgrade setuptools
RUN pip install jupyterlab
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
RUN pip install  transformers  datasets scikit-learn
RUN pip install matplotlib
RUN rm -rf ~/.cache/pip
RUN locale-gen ja_JP.UTF-8


RUN useradd -m user
USER user
WORKDIR /workspace