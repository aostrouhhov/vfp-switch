# ARMv7 VFP switcher for Linux
This project is aimed to develop Linux kernel enhancement which allows turning ARMv7 VFP on and off during runtime.

### Contents
1. `Vagranfile` - Vagrant config file
2. `bootstrap.sh` - Vagrant booststrap script
3. `rpi2emu.sh` - script for running Raspberry Pi 2 emulation
4. `vfp-switch.patch` - Linux patch with vfp-switch support
5. `float-test.c` - simple program with floats
6. `README.md` - this file


### Getting started
1. Get the *soft* rootfs and place it to root directory
2. Start VM
```
vagrant ssh
vagrant up
```
3. Get toolchain
```
git clone https://github.com/raspberrypi/tools ~/tools
echo PATH=\$PATH:~/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin >> ~/.bashrc
source ~/.bashrc`
```
4. Get the kernel
```
git clone --depth=1 --branch rpi-4.4.y https://github.com/raspberrypi/linux
cd linux
```
5. Apply the patch
```
git apply vfp-switch.patch
```
6. Build the kernel with debug symbols
```
KERNEL=kernel
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
printf "DEBUG_INFO=y\nDEBUG_INFO_REDUCED=n\nDEBUG_INFO_SPLIT=n\nDEBUG_INFO_DWARF4=n\nGDB_SCRIPTS=y" >> .config
make -j8 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
```
7. Run QEMU emulation with built kernel and *soft* rootfs
```
sudo bash /vagrant/rpi2emu.sh -k /home/vagrant/linux/arch/arm/boot/zImage -r /vagrant/2013-05-29-wheezy-armel.img
```
8. `init=/bin/bash` is applied for faster kernel boot so *procfs* should be mounted manually:
```
mount -t proc /proc
```
9. Debugging:
```
gdb-multiarch /home/vagrant/linux/vmlinux
target remote localhost:1234
```
