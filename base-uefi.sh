#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
hwclock --systohc
sed -i '171s/.//' /etc/locale.gen
sed -i '154s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "KEYMAP=uk" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd
# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm
pacman -S base-devel linux-headers networkmanager alsa-utils bluez bluez-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber firewalld virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq iptables-nft avahi cups nss-mdns pacman-contrib reflector acpid acpid_call
pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
bootctl install --path=/boot 
#grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB #change the directory to /boot/efi is you mounted the EFI partition at /boot/efi
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
# systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m -G wheel -s /bin/bash lee
echo lee:password | chpasswd

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
