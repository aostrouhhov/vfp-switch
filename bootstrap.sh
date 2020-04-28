#!/usr/bin/env bash

apt-get update
apt-get install -y unzip gcc pkg-config libglib2.0-dev libpixman-1-dev flex bison libssl-dev git bc make gdb-multiarch

# Get qemu-2.9.0
wget https://download.qemu.org/qemu-2.9.0.tar.xz
tar -xf qemu-2.9.0.tar.xz

# Build qemu-2.9.0
cd qemu-2.9.0/
./configure --target-list=arm-softmmu --enable-debug
make -j4

# Install qemu-2.9.0
apt-get install checkinstall
checkinstall -y make install
apt-get install ./*.deb
