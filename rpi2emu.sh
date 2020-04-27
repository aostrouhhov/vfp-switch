#!/usr/bin/env bash

# Options:
# -n | --new-run       - Download default hard rootfs and
#                        default Rapsberry Pi's kernel; run emulation
# -k | --kernel <path> - Path to kernel used in emulation
#                        (if not specified, default kernel will be used)
# -r | --rootfs <path> - Path to rootfs which can be Hard-Float or Soft-Float
#                        (if not specified, default rootfs will be used)

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -n|--new-run)
    NEW_RUN="true"
    shift # past argument
    ;;
    -k|--kernel)
    KERNEL="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--rootfs)
    ROOTFS="$2"
    shift # past argument
    shift # past value
    ;;
    *)
    shift # past argument
    ;;
  esac
done

if [ "$KERNEL" == "" ]; then
  KERNEL="/home/vagrant/qemu-rpi2-workspace/kernel7.img"
fi

if [ "$ROOTFS" == "" ]; then
  ROOTFS="/home/vagrant/qemu-rpi2-workspace/2016-05-27-raspbian-jessie-lite.img"
fi

echo "NEW_RUN = ${NEW_RUN}"
echo "KERNEL  = ${KERNEL}"
echo "ROOTFS  = ${ROOTFS}"

if [ "$NEW_RUN" == true ]; then
  echo "Recreating workspace /home/vagrant/qemu-rpi2-workspace ..."
  rm -rf /home/vagrant/qemu-rpi2-workspace
  mkdir /home/vagrant/qemu-rpi2-workspace
  cd /home/vagrant/qemu-rpi2-workspace
  echo -n "Done"

  echo "Downloading 2016-05-27-raspbian-jessie-lite.zip ..."
  wget https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2016-05-31/2016-05-27-raspbian-jessie-lite.zip
  echo -n "Done"

  echo "Extracting 2016-05-27-raspbian-jessie-lite.zip ..."
  unzip 2016-05-27-raspbian-jessie-lite.zip
  echo -n "Done"

  echo "Getting kernel7.img and bcm2709-rpi-2-b.dtb ..."
  losetup -f --show -P 2016-05-27-raspbian-jessie-lite.img
  mkdir /mnt/rpi
  mount /dev/loop0p1 /mnt/rpi
  cp /mnt/rpi/kernel7.img /mnt/rpi/bcm2709-rpi-2-b.dtb .
  umount /mnt/rpi
  losetup -d /dev/loop0
  echo -n "Done"
fi

echo "Starting RPi2 emulation ..."

qemu-system-arm \
  -s \
  -M raspi2 \
  -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 nokaslr init=/bin/bash" \
  -cpu cortexa7 \
  -dtb /home/vagrant/qemu-rpi2-workspace/bcm2709-rpi-2-b.dtb \
  -sd ${ROOTFS} \
  -kernel ${KERNEL} \
  -m 1G \
  -smp 1 \
  -serial stdio
