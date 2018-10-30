## GOOGLE FONTS
## https://github.com/google/fonts.git
## NOTO FONTS
## https://github.com/googlei18n/noto-fonts.git


ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc

echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
echo en_US ISO-8859-1 >> /etc/locale.gen
locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf
echo noisy > /etc/hostname

echo "127.0.0.1 localhost
::1 localhost
127.0.1.1 noisy.localdomain noisy" >> /etc/hosts	

echo "[multilib]
Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -Syu --noconfirm

pacman -Rs --noconfirm linux
pacman -S --noconfirm linux-zen linux-zen-headers

mkdir -p /etc/X11/xorg.conf.d/
cp -v /home/kim/Documents/arch_installer/configs/20-nvidia.conf /etc/X11/xorg.conf.d/
cp -v /home/kim/Documents/arch_installer/configs/50-mouse-acceleration.conf /etc/X11/xorg.conf.d/
mkdir -p /etc/sysctl.d/
cp -v /home/kim/Documents/arch_installer/configs/99-sysctl.conf /etc/sysctl.d/
cp -v /home/kim/Documents/arch_installer/configs/grub /etc/default/

for fol in /home/kim/Documents/arch_installer/themes/*; do
	echo "copying $fol" to themes
	cp -r $fol /usr/share/themes/
done

for fol in /home/kim/Documents/arch_installer/icons/*; do
	echo "copying $fol" to icons
	cp -r $fol /usr/share/icons/
done

pacman -S --noconfirm \
	xorg nvidia-dkms xorg-xinit sudo base-devel dhcpcd \
	pulseaudio pavucontrol awesome rtorrent mlocate \
	mpv mpd ncmpcpp beets feh neovim lib32-nvidia-libgl lib32-nvidia-utils nvidia-libgl \
	firefox pcmanfm gvfs lxappearance imagemagick ffmpeg ffmpegthumbnailer \
	libnotify youtube-dl zathura git krita

mkdir -p /usr/lib/modprobe.d
echo blacklist nouveau > /usr/lib/modprobe.d/nvidia.conf
cp -v /home/kim/Documents/arch_installer/configs/profile /etc

systemctl enable dhcpcd.service
systemctl --user enable mpd.service

pacman -S --noconfirm grub
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
cp -v /home/kim/Documents/arch_installer/configs/sudoers /etc/

## ST
git clone git://git.suckless.org/st
cd st
make clean install
cd .. 
rm -r st

echo "root password: "
passwd
printf "username: "
read usrname
useradd -G wheel $usrname
echo "password for $usrname"
passwd $usrname
echo "changing owner of home folder"
chown -R $username:$username /home/$username

autologinp="/etc/systemd/system/getty@tty1.service.d"
mkdir -p $autologinp
echo "[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin username --noclear %I \$TERM" >> $autologinp/override.conf
