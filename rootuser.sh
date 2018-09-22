ln -sf /usr/share/Europe/Stockholm /etc/localtime
hwclock --systohc
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
pacman -Syu --noconfirm

#echo replacing linux kernel with linux-zen 
#pacman -Rs --noconfirm linux
#pacman -S --noconfirm linux-zen linux-zen-headers

mkdir -p /etc/X11/xorg.conf.d/
cp -v /home/kim/Documents/arch_installer/configs/20-nvidia.conf /etc/X11/xorg.conf.d/
cp -v /home/kim/Documents/arch_installer/configs/50-mouse-acceleration.conf /etc/X11/xorg.conf.d/
mkdir -p /etc/sysctl.d/
cp -v /home/kim/Documents/arch_installer/configs/99-sysctl.conf /etc/sysctl.d/
cp -v /home/kim/Documents/arch_installer/configs/grub /etc/default/
mkdir -p /usr/lib/modprobe.d
echo blacklist nouveau > /usr/lib/modprobe.d/nvidia.conf
cp -v /home/kim/Documents/arch_installer/configs/profile /etc

for fol in /home/kim/Documents/arch_installer/themes/*; do
	echo "copying $fol" to themes
	cp -r $fol /usr/share/themes/
done

for fol in /home/kim/Documents/arch_installer/icons/*; do
	echo "copying $fol" to icons
	cp -r $fol /usr/share/icons/
done

pacman -S --noconfirm \
	xorg nvidia xorg-xinit sudo base-devel dhcpcd \
	pulseaudio pavucontrol awesome rtorrent \
	mpv mpd ncmpcpp beets feh neovim \
	firefox pcmanfm gvfs lxappearance imagemagick ffmpeg ffmpegthumbnailer \
	libnotify youtube-dl zathura git krita

systemctl enable dhcpcd.service
systemctl enable mpd.service

pacman -S --noconfirm grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
cp -v /home/kim/Documents/arch_installer/configs/sudoers /etc/

## ST
git clone git://git.suckless.org/st
cp /home/kim/Documents/arch_installer/configs/stconf.h ./st/config.h
cd st
make clean install
cd .. 
rm -r st

## YAY
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -cs
pacman -U yay-8.1115-1-x86_64.pkg.tar.xz
cd ..
rm -r yay

echo "root password: "
passwd
printf "username: "
read usrname
useradd -G wheel $usrname
echo "password for $usrname"
passwd $usrname
echo "changing owner of home folder"
chown -R $username:$username /home/$username
