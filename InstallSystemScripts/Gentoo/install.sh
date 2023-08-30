#!/bin/bash
#
#Paso.Resultado
#01.El usuario está en un entorno de trabajo listo para instalar Gentoo.
#02.La conexión a Internet está lista para instalar Gentoo.
#03.Los discos duros se inicializan para albergar la instalación de Gentoo.
#04.El entorno de instalación está preparado y el usuario está listo para hacer chroot en el nuevo entorno.
#05.Se instalan los paquetes principales, que son los mismos en todas las instalaciones de Gentoo.
#06.El kernel de Linux está instalado.
#07.Se crean la mayoría de los archivos de configuración del sistema Gentoo.
#08.Las herramientas del sistema necesarias están instaladas.
#09.Se ha instalado y configurado el gestor de arranque adecuado.
#10.El entorno Gentoo Linux recién instalado está listo para ser explorado.
#
###############################################################################
#   01 SETTING
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Media
#
# You need like min 2GB ram, 8GB disk, 2GB swap
# This intalation run with cd minimal
# For see documentations in boot:
# links https://wiki.gentoo.org/wiki/Handbook:AMD64
loadkeys la-latin1

###############################################################################
#   02 CONFIG NETWORK
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Networking
#
# gentoo have automatic network detection in ethernet
PINGCHECK=$(ping -c 3 www.gentoo.org | grep -c "0% packet loss")
if [ "$PINGCHECK" -eq 1 ]; then
    echo ">> YOU HAVE INTERNET CONNECTION, WE WILL INSTALL GENTOO NOW!!!"
    sleep 2
else
    echo ">> YOU DON'T HAVE INTERNET CONNECTION, WE CANN'T INSTALL GENTOO, PLEASE CHECK YOU NETWORK AND TRY AGAIN"
    return 1
fi

###############################################################################
#   03 PREPARING THE DISKS
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks
#
# Set Disk
echo "
>> DISCOS DISPONIBLES.
"
lsblk | grep "disk"
echo "
>> RECUERDA!!!
>> LA INSTALACION BORRA TODO EL DISCO DURO!!!
>> DE LOS DISCOS DISPONIBLES, SELECCIONA UNO, ESCRIBE EXTACTAMENTE CUAL:
"
read -r "InstallDisk"
echo "
>> INSTALAREMOS EN: $InstallDisk
"
sleep 4

# part disk
echo ">> CREANDO PARTICIONES PARA $InstallDisk"
wipefs -a /dev/"$InstallDisk"
echo "yes" | parted /dev/"$InstallDisk" mklabel gpt
#change parted for fdisk for part in the future
parted /dev/"$InstallDisk" mkpart efi fat32 1MiB 257MiB
sleep 4
parted /dev/"$InstallDisk" set 1 esp on
sleep 4
parted /dev/"$InstallDisk" mkpart swap linux-swap 257MiB 2300MiB
sleep 4
parted /dev/"$InstallDisk" mkpart root ext4 2300MiB 100%
sleep 4
PassPart() {
    echo "yes" | mkfs.fat -F 32 /dev/"$InstallDisk""$1"
    echo "yes" | mkswap /dev/"$InstallDisk""$2"
    echo "yes" | mkfs.ext4 /dev/"$InstallDisk""$3"
    fdisk -l | grep "$InstallDisk"
}
if [[ $InstallDisk == *"nvme"* ]]; then
    PassPart p1 p2 p3
else
    PassPart 1 2 3
fi

# mount part
MountPart(){
    swapon /dev/"$InstallDisk""$1"
    mount /dev/"$InstallDisk""$2" /mnt/gentoo
    #mount --mkdir /dev/"$InstallDisk""$3" /mnt/boot/EFI
}
if [[ $InstallDisk == *"nvme"* ]]; then
    MountPart p2 p3 #p1
else
    MountPart 2 3 #1
fi

###############################################################################
#   04 INSTALLING THE GENTOO INSTALLATION FILES
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage
#
# Set date and time
MYDATE=$(date "+%m%d%H%M%Y")
echo "$MYDATE" | xargs -I {} date {}

# Choosing a stage tarball
cd "/mnt/gentoo" || exit
ls
sleep 4
gentooDownloads="https://www.gentoo.org/downloads/" &&
gentooGrep="stage3-amd64-openrc" &&
gentooCurl=$(curl "$gentooDownloads" | grep -i "$gentooGrep" | cut --complement -d '"' -f 1 | cut -d '"' -f 1 | head -n 1) &&
curl -LO "$gentooCurl" &&
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner &&
rm -v stage-*
rm -v lost+found

# configuring compile options
# CFLAGS and CXXFLAGS
# https://wiki.gentoo.org/wiki/Safe_CFLAGS
#sed -i 's/COMMON_FLAGS="-O2 -pipe"/COMM0N_FLAGS="-O2 -pipe -march=znver3"/g' /mnt/gentoo/etc/portage/make.conf
sed -i 's/COMMON_FLAGS="-O2 -pipe"/COMM0N_FLAGS="-O2 -pipe -march=native"/g' /mnt/gentoo/etc/portage/make.conf
# MAKEOPTS
NODES=$(nproc)
echo "MAKEOPTS=\"-j$NODES\"" >> /mnt/gentoo/etc/portage/make.conf
cat /mnt/gentoo/etc/portage/make.conf
sleep 4

###############################################################################
#   05 INTALLING THE GENTOO BASE SYSTEM
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base
#
# chrooting
# murrors and repository
mirrorselect -a -o >> /mnt/gentoo/etc/portage/make.conf
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp -v /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
#cat /mnt/gentoo/usr/share/portage/config/repos.conf

# dns info
cp -v --dereference /etc/resolv.conf /mnt/gentoo/etc

# mounting the necessary filesystems
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

# entering the new environment
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"

######################################
######################################
# Ineed pass this to chroot
######################################
######################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base
#
# mounting boot partition
BootPart(){
    mount /dev/"$InstallDisk""$1" /boot
}
if [[ $InstallDisk == *"nvme"* ]]; then
    PassPart p1
else
    PassPart 1
fi

# Configuring portage
emerge-webrsync
emerge --sync

# reading new items
# eselect news list
# eselect news read | less
# more info
# man news.eselect

# choosing profile
eselect profile list
# eselect profile set 1

# updating the @world set
#emerge --ask --verbose --update --deep --newuse @world
emerge --verbose --update --deep --newuse @world

# configuring the use variable
# one of the most powerful tool in gentoo
emerge --info | grep ^USE
sleep 2
# more info
#cat /var/db/repos/gentoo/profiles/use.desc
vi /etc/portage/make.conf

# CPUFLAGS expand variable to USE
emerge app-portage/cpuid2cpuflags
cpuid2cpuflags
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags

# Videocards
# https://wiki.gentoo.org/wiki/Xorg/Guide#Make.conf_configuration

# LICENSE
echo "
>> ACCEPT LICENSE
"
portageq envvar ACCEPT_LICENSE
echo 'ACCEPT_LICENSE="*"' >> /etc/portage/make.conf
echo "
>> ACCEPT LICENSE
"
portageq envvar ACCEPT_LICENSE

# Timezone
echo "
>> SELECT A TIMEZONE, SELECCIONA UNA ZONA HORARIA:
"
ls /usr/share/zoneinfo/{America,US,Canada,Brazil,Chile,Europe}
echo "
>> CHOOSE ONE, ELIGE UNA ZONA HORIA,ESCRIBE EXACTAMENTE.
>> CONTINENTE/PAIS o PAIS/REGION
>> RECUERDA ESCRIBIR EXACTAMENTE O TRENDRAS PROBLEMAS.
"
read -r "ZONETIME"
echo "$ZONETIME" > /etc/timezone
emerge --config sys-libs/timezone-data

# LOCALE
echo "en_US ISO-8859-1
en_US.UTF-8 UTF-8
es_MX ISO-8859-1
es_MX.UTF-8 UTF-8
fr_CA ISO-8859-1
fr_CA.UTF-8 UTF-8
pt_BR ISO-8859-1
pt_BR.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale list
eselect locale set 4
# Manual
#echo 'LANG="en_US.UTF-8"
#LC_COLLATE="en_US.UTF-8"' >> /etc/env.d/02locale

# Reload environment
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"

###############################################################################
#   06 CONFIGURING THE LINUX KERNEL
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel
#
# Installing firmware and microcode
# amd in the linux-firmware
emerge sys-kernel/linux-firmware
# for intel
# sys-firmware/intel-microcode

# Kernel config and compilation
emerge sys-kernel/installkernel-gentoo
emerge sys-kernel/gentoo-kernel
emerge --depclean
emerge --prune sys-kernel/gentoo-kernel
emerge @module-rebuild
emerge --config sys-kernel/gentoo-kernel

#other way to install kernel
#emerge --ask sys-kernel/gentoo-sources
# zen kernel
#emerge --ask sys-kernel/zen-sources
#eselect kernel list
#eselect kenerl set 1

# construir initramfs
#emerge sys-kernel/dracut
#dracut --kver=5.15.52-gentoo
#ls /boot/initramfs*

# search modules in linux
#find /lib/modules/<kernel version>/ -type f -iname "*.o" -or -iname '*.ko' | less
# sepuede forzar la carga de un modulo
# mkdir -p /etc/modules-load.d
# echo "3c59x" >> /etc/modules-load.d/network.conf

###############################################################################
#   07 CONFIGURING THE SYSTEM
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/System
#
# FSTAB
MakeFstab(){
echo "
/dev/$InstallDisk$1    /boot     vfat    defaults    0 2
/dev/$InstallDisk$2    none      swap    sw          0 0
/dev/$InstallDisk$3    /         ext4    defaults,noatime    0 1" >> /etc/fstab
}
if [[ $InstallDisk == *"nvme"* ]]; then
    MakeFstab p1 p2 p3
else
    MakeFstab 1 2 3
fi

# net info
# hostname
echo "M3K4" > /etc/hostname
# network
emerge net-misc/dhcpcd
rc-update add dhcpcd default
rc-service dhcpcd start

# host file
curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts >> /etc/hosts
sed -i '/# Custom host records are listed here./a 127.0.1.1 M3K4.localdomain        M3K4' /etc/hosts

#password root
passwd
#{13|0=7U190=8|4n{0

# Init and boot
sed -i '/#rc_nocolor=NO/a rc_nocolor=YES' /etc/rc.conf
# keymaps
sed -i 's/keymap="us"/keymap="la-latin1"/g' /etc/conf.d/keymaps
# hwclock
sed -i 's/clock="UTC"/clock="local"/g' /etc/conf.d/hwclock

###############################################################################
#   08 INSTALLING SYSTEM TOOLS
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Tools
#
# System logger
emerge -v app-admin/sysklogd
rc-update add sysklogd default

# cron
emerge -v sys-process/cronie
rc-update add cronie default

# index files
emerge -v sys-apps/mlocate

# time sync
emerge -v net-misc/chrony
rc-update add chronyd default

# tools file system
emerge -v sys-fs/xfsprogs sys-fs/e2fsprogs sys-fs/dosfstools sys-fs/btrfs-progs sys-fs/zfs sys-fs/jfsutils sys-fs/reiserfsprogs
emerge -v sys-block/io-scheduler-udev-rules

# wifi
emerge -v net-wireless/iw net-wireless/wpa_supplicant

###############################################################################
#   09 BOOTLOADER
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Bootloader
#
# GRUB
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge -v sys-boot/grub
grub-install --target=x86_64-efi --efi-directory=/boot --removable
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/set timeout=5/set timeout=0/g' /boot/grub/grub.cfg

###############################################################################
#   10 Finalizing
###############################################################################
#
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Finalizing
#
# User Admin
# m1n0$
echo "
>> AGREGA UN NUEVO USUARIO.
>> ESCRIBE SU NOMBRE:
"
read -r "NEWUSER"
echo "
>> ESCRIBE SU PASSWORD, RECUERDALO BIEN POR QUE SOLO SE TE PEDIRA UNA VEZ:
"
read -r "NEWUSERPASS"
useradd -m -G wheel -s /bin/bash "$NEWUSER"
echo "$NEWUSERPASS" | passwd "$NEWUSER" --stdin
