#!/bin/bash

read -p 'Device: ' device

echo
echo "Formating root partition"
mkfs.ext4 -q /dev/${device}3 || exit

echo
echo "Formating boot partition"
mkfs.ext2 -q /dev/${device}1 || exit
echo Done

echo
echo "Making swap partition"
mkswap /dev/${device}2 && swapon /dev/${device}2 || exit

echo
echo "Mounting root partition"
mount /dev/${device}3 /mnt || exit
echo Done

echo
echo "Mounting boot partition"
mkdir /mnt/boot && mount /dev/${device}1 /mnt/boot || exit
echo Done

echo
echo "Mounting home partition"
mkdir /mnt/home && mount /dev/${device}4 /mnt/home || exit
echo Done

echo
echo "Pacstraping"
pacstrap /mnt base base-devel grub iw wpa_supplicant git || exit
echo Done

echo
echo "Creating fstab"
genfstab -U /mnt > /mnt/etc/fstab || exit
echo Done




