# DO NOT USER THIS

timedatectl set-ntp true
fdisk /dev/sda

while true; do
	printf "root partition: "
	read rootp
	printf "install root on /dev/sda$rootp ? (y/n) "
	read answer
	if [[ "$answer" == "y" ]]; then
		break
	else
		echo ' '
	fi
done

rootp=/dev/sda$rootp
echo "formating $rootp"
mkfs.ext4 $rootp
echo "using /dev/sda2 as swap"
mkswap /dev/sda2
swapon /dev/sda2
echo "mounting $rootp to /mnt"
mount $rootp /mnt
echo "mounting home partition to /home"
mount /dev/sda4 /home
vim /etc/pacman.d/mirrorlist
echo "installing base"
pacstrap /mnt base
echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt<<OEF
echo "setting up locale.gen"
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
echo en_US ISO-8859-1 >> /etc/locale.gen
locale-gen
echo "setting up locale.conf"
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo "setting hostname"
echo noisy > /etc/hostname
echo "setting up hosts"
echo 127.0.0.1 localhost >> /etc/hosts
echo ::1 localhost >> /etc/hosts
echo 127.0.1.1 noisy.localdomain noisy >> /etc/hosts	

echo "enabling multilib arch"
echo [multilib] >> /etc/pacman.conf
echo Include = /etc/pacman.d/mirrorlist >> /etc/pacman.conf

echo replacing linux kernel with linux-zen 
pacman -Rs --noconfirm linux
pacman -S --noconfirm linux-zen
echo "generating initramfs"
mkinitcpio -p linux

mkdir -p /etc/X11/xorg.conf.d/
cp -v /home/kim/Documents/arch_installer/configs/20-nvidia.conf /etc/X11/xorg.conf.d/
cp -v /home/kim/Documents/arch_installer/configs/50-mouse-acceleration.conf /etc/X11/xorg.conf.d/
mkdir -p /etc/sysctl.d/
cp -v /home/kim/Documents/arch_installer/configs/99-sysctl.conf /etc/sysctl.d/
cp -v /home/kim/Documents/arch_installer/configs/grub /etc/default/
mkdir -p /usr/lib/modprobe.d
echo blacklist nouveau > /usr/lib/modprobe.d/nvidia.conf

for fol in /home/kim/Documents/arch_installer/themes/*; do
	cp -r -v $fol /usr/share/themes/
done

for fol in /home/kim/Documents/arch_installer/icons/*; do
	cp -r -v $fol /usr/share/icons/
done

pacman -S --noconfirm \
	xorg nvidia-dkms sudo base-devel \
	pulseaudio pavucontrol awesome \
	mpv mpd ncmpcpp beets mpdscribble feh \
	firefox pcmanfm gvfs lxappearance imagemagick ffmpeg ffmpegthumbnailer \
	libnotify youtube-dl unar zathura git krita

echo "installing grub"
pacman -S --noconfirm grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
echo "settings up sudoers"
cp -v /home/kim/Documents/arch_installer/configs/sudoers /etc/

echo "root password: "
passwd

printf "username: "
read usrname
useradd -g wheel $usrname
echo "password for $usrname"
passwd $usrname
EOF
