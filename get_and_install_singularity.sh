#!/bin/bash

## get system dependencies

sudo apt-get update && sudo apt-get install -y \
    build-essential \
    libssl-dev \
    uuid-dev \
    libgpgme11-dev \
    squashfs-tools \
    libseccomp-dev \
    wget \
    pkg-config \
    git \
    cryptsetup \
    debootstrap

## install Go

export GO_VERSION=1.14.12 OS=linux ARCH=amd64 && \  # Replace the values as needed
wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz && \ #Downloads the required Go package
sudo tar -C /usr/local -xzvf go$GO_VERSION.$OS-$ARCH.tar.gz && \ #Extracts the archive
rm go$GO_VERSION.$OS-$ARCH.tar.gz    #Deletes the ``tar`` file

## Set environment local PATH to go

echo 'export GOPATH=${HOME}/go' >> ~/.bashrc && \
    echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc && \
    source ~/.bashrc

## Download the Singularity Code for V3.7.0
  
export SING_VERSION=3.7.0 && \
    wget https://github.com/hpcng/singularity/releases/download/v${SING_VERSION}/singularity-${SING_VERSION}.tar.gz && \
    tar -xzf singularity-${SING_VERSION}.tar.gz && \
    cd singularity

## Compile Singularity Code

./mconfig && \
    make -C builddir && \
    sudo make -C builddir install
  
