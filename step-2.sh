#!/bin/bash

echo 
echo "Creating timezone info"
read -p 'Region: ' region
read -p 'City: ' city
if [ -f /usr/share/zoneinfo/$region/$city ] ; then
  ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime && hwclock --systohc
else
  echo "Invalid zone"; exit
fi
echo Done

echo
echo "Generating locale"
loc=en_US.UTF-8
echo "Generating locale $loc"
sed -i '/^$loc/s/^#//g' /etc/locale.gen && locale-gen && echo LANG=$loc > /etc/locale.conf || exit
echo Done

echo
echo "Creating hostane"
read -p 'Hostname: ' hostanme
echo $hostname > /etc/hostname || exit
echo Done

echo
echo "Creating root password"
passwd || exit
echo Done

echo
echo "Creating user account"
read -p 'Username: ' username
useradd -m -G wheel -s /bin/bash $username && passwd $username || exit
echo Done

echo
echo "Modifying sudoers file"
echo "Defaults rootpw" | EDITOR='tee -a' visudo && \
echo "%wheel ALL=(ALL) ALL" | EDITOR='tee -a' visudo || exit
echo Done

echo
echo "Installing bootloader"
read -p 'Device: ' device
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=i386-pc /dev/$device
echo Done
