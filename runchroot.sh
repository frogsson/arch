## GOOGLE FONTS
## https://github.com/google/fonts.git
## NOTO FONTS
## https://github.com/googlei18n/noto-fonts.git

ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

cat >> /etc/locale.gen << EOL
en_US.UTF-8 UTF-8
en_US ISO-8859-1
EOL
locale-gen

echo LANG=en_US.UTF-8 >> /etc/locale.conf
echo noisy > /etc/hostname

cat >> /etc/hosts << EOL
127.0.0.1 localhost
::1 localhost
127.0.1.1 noisy.localdomain noisy
EOL

# xorg.conf.d/ 20-nvidia.conf 50-mouse-acceleration {{{
mkdir -p /etc/X11/xorg.conf.d/
cat >> /etc/X11/xorg.conf.d/20-nvidia.conf << EOL
Section "Device"
    Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce GT 1030"
    Option         "UseEdidDpi" "False"
EndSection

Section "Screen"
    Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
EndSection
EOL

cat >> /etc/X11/xorg.conf.d/50-mouse-acceleration.conf << EOL
Section "InputClass"
    Identifier "My Mouse"
    MatchIsPointer "yes"
    Option "AccelerationProfile" "-1"
    Option "AccelerationScheme" "none"
    Option "AccelSpeed" "0"
EndSection
EOL
# }}}

# sysctl.d (swappiness) {{{
# mkdir -p /etc/sysctl.d/
# cat >> /etc/sysctl.d/99-sysctl.conf << EOL
# vm.swappiness=1
# EOL
# }}}

pacman -S --noconfirm \
	sudo base-devel dhcpcd git nvidia

mkdir -p /usr/lib/modprobe.d
echo blacklist nouveau > /usr/lib/modprobe.d/nvidia.conf

systemctl enable dhcpcd.service

pacman -S --noconfirm grub
# /etc/default/grub {{{
cat > /etc/default/grub << EOL
GRUB_DEFAULT="saved"

GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR="Arch"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash elevator=bfq"
GRUB_CMDLINE_LINUX=""

# Preload both GPT and MBR modules so that they are not missed
# GRUB_PRELOAD_MODULES="part_gpt part_msdos"

# Uncomment to enable Hidden Menu, and optionally hide the timeout count
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true

# remember the last selection (requires GRUB_DEFAULT="saved")
GRUB_SAVEDEFAULT="true"
EOL
# }}}
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# simple terminal {{{
git clone git://git.suckless.org/st
cd st
make clean install
cd - 
rm -r st
# }}}

echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "set root password"
passwd

printf "username: "
read usrname
useradd -G wheel $usrname
echo "password for $usrname"
passwd $usrname
echo "changing owner of home folder"
chown -R $usrname:$usrname /home/$usrname
