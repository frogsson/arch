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
mkfs.ext4 $rootp
mkswap /dev/sda2
swapon /dev/sda2
mount $rootp /mnt
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home
vim /etc/pacman.d/mirrorlist
pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

wget https://raw.githubusercontent.com/frogsson/arch/master/rootuser.sh
cp rootuser.sh /mnt/rootuser.sh
chmod +x /mnt/rootuser.sh
arch-chroot /mnt ./rootuser.sh
