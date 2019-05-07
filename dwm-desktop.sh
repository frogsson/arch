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
	pavucontrol rtorrent \
	mpv mpd ncmpcpp beets neovim \
	gvfs ntfs-3g lxappearance imagemagick ffmpeg  \
	pcmanfm ffmpegthumbnailer pulseaudio \
	libnotify youtube-dl zathura krita \
	xclip dunst tmux python-pip \
	noto-fonts-emoji ttf-croscore

systemctl --user enable mpd.service

# mkdir -p /etc/systemd/system/getty@tty1.service.d
# cat >> /etc/systemd/system/getty@tty1.service.d/override.conf << EOL
# [Service]
# ExecStart=
# ExecStart=-/usr/bin/agetty --autologin username --noclear %I \$TERM
# EOL
