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
    cryptsetup

## install Go

export GO_VERSION=1.14.12 OS=linux ARCH=amd64 && \  # Replace the values as needed
wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz && \ #Downloads the required Go package
sudo tar -C /usr/local -xzvf go$GO_VERSION.$OS-$ARCH.tar.gz && \ #Extracts the archive
rm go$GO_VERSION.$OS-$ARCH.tar.gz    #Deletes the ``tar`` file
