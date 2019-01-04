#!/bin/bash

set -e -u

sed -i 's/#\(it_IT\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target

useradd -m -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /bin/bash arch
echo "root:master" | chpasswd
echo "arch:live" | chpasswd
chown -R arch:users /home/arch
echo 'arch	ALL=(ALL:ALL) ALL' >> /etc/sudoers
echo 'arch	ALL=NOPASSWD: /usr/bin/arch-install' >> /etc/sudoers

chmod +x /usr/bin/arch-install

systemctl enable NetworkManager

rm /etc/udev/rules.d/81-dhcpcd.rules
