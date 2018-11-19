timedatectl set-ntp true
fdisk /dev/sda

while true; do
	printf "root partition: "
	read rootp
	printf "swap partition: "
	read swapp
	printf "home partition: "
	read homep

	printf "/dev/sda$rootp /\n"
	printf "/dev/sda$swapp [SWAP]\n"
	printf "/dev/sda$homep /home\n"

	printf "does this look right? (y/n)\n"

	read answer

	if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
		break
	else
		echo ' '
	fi
done

rootp=/dev/sda$rootp
mkfs.ext4 $rootp

mkswap /dev/sda$swapp
swapon /dev/sda$swapp

mount $rootp /mnt

mkdir -p /mnt/home
mount /dev/sda4 /mnt/home

vi /etc/pacman.d/mirrorlist

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

wget https://raw.githubusercontent.com/frogsson/arch/master/runchroot.sh
cp runchroot.sh /mnt/runchroot.sh
chmod +x /mnt/runchroot.sh

arch-chroot /mnt ./runchroot.sh
