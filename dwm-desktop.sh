# gaymer stuff {{{
# echo "[multilib]
# Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
# pacman -Syu --noconfirm
# }}}

pacman -S --noconfirm \
	xorg xorg-xinit \
	pavucontrol rtorrent \
	mpv mpd ncmpcpp beets neovim \
	gvfs ntfs-3g lxappearance imagemagick ffmpeg  \
	pcmanfm ffmpegthumbnailer \
	libnotify youtube-dl zathura krita

systemctl --user enable mpd.service

# mkdir -p /etc/systemd/system/getty@tty1.service.d
# cat >> /etc/systemd/system/getty@tty1.service.d/override.conf << EOL
# [Service]
# ExecStart=
# ExecStart=-/usr/bin/agetty --autologin username --noclear %I \$TERM
# EOL
