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
echo "127.0.0.1 localhost
::1 localhost
127.0.1.1 noisy.localdomain noisy"
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
mkdir -p /etc/sysctl.d/
cat >> /etc/sysctl.d/99-sysctl.conf << EOL
vm.swappiness=1
EOL
# }}}

pacman -S --noconfirm \
	sudo base-devel dhcpcd git nvidia

mkdir -p /usr/lib/modprobe.d
echo blacklist nouveau > /usr/lib/modprobe.d/nvidia.conf

systemctl enable dhcpcd.service

pacman -S --noconfirm grub
# /etc/default/grub {{{
cat >> /etc/default/grub << EOL
# GRUB boot loader configuration

GRUB_DEFAULT=0
GRUB_DISTRIBUTOR="Arch"
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX=""

# hide grub menu
GRUB_HIDDEN_TIMEOUT=0
GRUB_TIMEOUT=0

# Preload both GPT and MBR modules so that they are not missed
GRUB_PRELOAD_MODULES="part_gpt part_msdos"

# Uncomment to enable booting from LUKS encrypted devices
#GRUB_ENABLE_CRYPTODISK=y

# Uncomment to enable Hidden Menu, and optionally hide the timeout count
#GRUB_HIDDEN_TIMEOUT=5
#GRUB_HIDDEN_TIMEOUT_QUIET=true

# Uncomment to use basic console
GRUB_TERMINAL_INPUT=console

# Uncomment to disable graphical terminal
#GRUB_TERMINAL_OUTPUT=console

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command 'vbeinfo'
GRUB_GFXMODE=auto

# Uncomment to allow the kernel use the same resolution used by grub
GRUB_GFXPAYLOAD_LINUX=keep

# Uncomment if you want GRUB to pass to the Linux kernel the old parameter
# format "root=/dev/xxx" instead of "root=/dev/disk/by-uuid/xxx"
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
GRUB_DISABLE_RECOVERY=true

# Uncomment and set to the desired menu colors.  Used by normal and wallpaper
# modes only.  Entries specified as foreground/background.
#GRUB_COLOR_NORMAL="light-blue/black"
#GRUB_COLOR_HIGHLIGHT="light-cyan/blue"

# Uncomment one of them for the gfx desired, a image background or a gfxtheme
#GRUB_BACKGROUND="/path/to/wallpaper"
#GRUB_THEME="/path/to/gfxtheme"

# Uncomment to make GRUB remember the last selection. This requires to
# set 'GRUB_DEFAULT=saved' above.
#GRUB_SAVEDEFAULT="true"
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

echo "set root password"
passwd

printf "username: "
read usrname
useradd -G wheel $usrname
echo "password for $usrname"
passwd $usrname
echo "changing owner of home folder"
chown -R $usrname:$usrname /home/$usrname
