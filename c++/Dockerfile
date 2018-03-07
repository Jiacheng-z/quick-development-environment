# A image for building/testing brpc
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# prepare env
RUN apt-get update && apt-get install -y --no-install-recommends \
        curl \
        zip \
        unzip \
        wget \
        apt-utils \
        openssl \
        graphviz \
        ghostscript \
        file \
        tzdata \
        ca-certificates

# install deps
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        g++ \
        make \
        cmake \
        autoconf \
        libssl-dev \
        libgflags-dev \
        libprotobuf-dev \
        libprotoc-dev \
        protobuf-compiler \
        libleveldb-dev \
        libsnappy-dev \
        libhiredis0.13 \
        libhiredis-dev \
        libboost-all-dev && \
        apt-get clean -y

# install gperftools
RUN wget https://github.com/gperftools/gperftools/releases/download/gperftools-2.6.3/gperftools-2.6.3.zip 
RUN unzip gperftools-2.6.3.zip && rm -rf gperftools-2.6.3.zip && \
    cd gperftools-2.6.3 && ./configure && make && make install && \
    cd ../ && rm -rf gperftools-2.6.3

# install rdkafka
RUN wget https://github.com/edenhill/librdkafka/archive/v0.11.3.zip
RUN unzip v0.11.3.zip && rm -rf v0.11.3.zip && \
    cd librdkafka-0.11.3 && ./configure && make && make install && \
    cd ../ && rm -rf librdkafka-0.11.3

# install brpc
RUN git clone https://github.com/brpc/brpc.git brpc
RUN cd /brpc && sh config_brpc.sh --headers=/usr/include --libs=/usr/lib && \
    make -j "$(nproc)"
