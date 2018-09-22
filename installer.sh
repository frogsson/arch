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
mkdir -p /mnt/home
mount /dev/sda4 /mnt/home
vim /etc/pacman.d/mirrorlist
echo "installing base"
pacstrap /mnt base
echo "generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

wget https://raw.githubusercontent.com/frogsson/arch/master/installer2.sh
cp rootuser.sh /mnt/rootuser.sh
chmod +x /mnt/rootuser.sh
arch-chroot /mnt ./rootuser.sh
