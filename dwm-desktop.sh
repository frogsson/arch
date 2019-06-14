# gaymer stuff {{{
# cat >> /etc/pacman.conf << EOF
# echo "[multilib]
# Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
# EOF
# pacman -Syu --noconfirm

# NEEDED PACKAGES 32 BIT WINE
# lib32-libpulse
# lib32-mpg123
# lib32-nvidia-utils:wq

# }}}

pacman -S --noconfirm \
	xorg xorg-xinit \
	pavucontrol rtorrent feh \
	mpv mpd ncmpcpp beets neovim \
	gvfs ntfs-3g lxappearance imagemagick ffmpeg  \
	dolphin ffmpegthumbs pulseaudio \
	libnotify youtube-dl zathura krita thunderbird \
	xclip dunst tmux python-pip \
	ttf-croscore ttf-carlito ttf-caladea \
	libva-vdpau-driver \
	hsetroot compton du ripgrep gdb-common

# pcmanfm
# pcmanfm-gtk3 ffmpegthumbnailer

systemctl --user enable mpd.service

# mkdir -p /etc/systemd/system/getty@tty1.service.d
# cat >> /etc/systemd/system/getty@tty1.service.d/override.conf << EOL
# [Service]
# ExecStart=
# ExecStart=-/usr/bin/agetty --autologin username --noclear %I \$TERM
# EOL
