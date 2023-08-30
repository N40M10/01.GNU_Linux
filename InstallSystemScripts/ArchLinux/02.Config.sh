#! /bin/sh
#
#------------------------------------------------------------------------------
# INDEX
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
# VARIABLES
#-----------------------------------------------------------------------------
#
# SPACE FOR THE VARIABLES FROM BASE.SH
newContinent='America'
newCity='put your country here'
#
#------------------------------------------------------------------------------
# FUNCTIONS
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
# RUN
#------------------------------------------------------------------------------

# ---   FUNCTIONS   ------------------------------------------------------------
#
Localization (){
    TimeZone (){
        # variable option
        #ls /usr/share/zoneinfo/*
        #read -p 'Tu continente; ' init1
        #ls /usr/share/zoneinfo/$init1/*
        #read -p 'Tu pais; ' init2
        ln -sf /usr/share/zoneinfo/"${newContinent}"/${newCity} /etc/localtime
        hwclock --systohc --localtime
        # real method for time set
        # timedatectl set-timezone "${newContinent}${newCity}"
        # timedatectl set-ntp yes
    }
    TimeZone

    Locale (){
        sed -i s/"#en_US.UTF-8 UTF-8"/"en_US.UTF-8 UTF-8"/g /etc/locale.gen
        sed -i s/"#es_MX.UTF-8 UTF-8"/"es_MX.UTF-8 UTF-8"/g /etc/locale.gen
        sed -i s/"#fr_CA.UTF-8 UTF-8"/"fr_CA.UTF-8 UTF-8"/g /etc/locale.gen
        sed -i s/"#pt_BR.UTF-8 UTF-8"/"pt_BR.UTF-8 UTF-8"/g /etc/locale.gen
        sed -i s/"#en_US ISO-8859-1"/"en_US ISO-8859-1"/g /etc/locale.gen
        sed -i s/"#es_MX ISO-8859-1"/"es_MX ISO-8859-1"/g /etc/locale.gen
        sed -i s/"#fr_CA ISO-8859-1"/"fr_CA ISO-8859-1"/g /etc/locale.gen
        sed -i s/"#pt_BR ISO-8859-1"/"pt_BR ISO-8859-1"/g /etc/locale.gen

        {
            echo 'LANG=fr_CA.UTF-8'
            echo 'LANG=pt_BR.UTF-8'
            echo 'LANG=en_US.UTF-8'
            echo 'LANG=es_MX.UTF-8'
        } >> /etc/locale.conf

        {
            echo 'KEYMAP=la-latin1
            #es_MX.UTF-8 keymap'
            echo '#KEYMAP_TOGGLE=use_EN_US_UTF-8_Keymap #en_US.UTF-8 keymap'
            echo '#KEYMAP_TOGGLE=use_FR_CA_UTF-8_Keymap #fr_CA.UTF-8 keymap'
            echo '#KEYMAP_TOGGLE=use_PT_BR_UTF-8_Keymap #pt_BR.UTF-8 keymap'
        } >> /etc/vconsole.conf

        locale-gen
    }
    Locale
}

Network (){
    HostName (){
        # opcion de variable
        echo "${INSTALLNAME}" >> /etc/hostname
    }
    HostName

    Net (){
        pacman -S --noconfirm dhcpcd
        systemctl enable dhcpcd
    }
    Net
}

Initramfs (){
    mkinitcpio -P
}

Users (){
    Root (){
        printf "%s/n%s" "${INSTALLPASSWDROOT}" "${INSTALLPASSWDROOT}" | passwd
    }
    Root

    #SkelDir(){
    #    cp -rfv ./skel /etc/skel
    #}
    #SkelDir

    User (){
        if [ "${INSTALLUSERNAME}" = "y" ]; then
            useradd -m -g wheel -s /bin/bash "${INSTALLUSERNAME}"
            printf "%s/n%s" "${INSTALLPASSWDUSER}" "${INSTALLPASSWDUSER}" | passwd "${INSTALLUSERNAME}"
        else
            useradd -m -s /bin/bash "${INSTALLUSERNAME}"
            printf "%s/n%s" "${INSTALLPASSWDUSER}" "${INSTALLPASSWDUSER}" | passwd "${INSTALLUSERNAME}"
        fi
    }
    User

    Privilege (){
        pacman -S --noconfirm sudo
        sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers
    }
    Privilege
}

BootLoader (){
    pacman -S --noconfirm grub efibootmgr
    grub-install --target=x86_64-efi --efi-directory=/mnt/boot/efi --bootloader-id=ARCH_GRUB
    grub-mkconfig -o /boot/grub/grub.cfg
    sed -i "s/set timeout=5/set timeout=0/g" /boot/grub/grub.cfg
}

# -----------------------------------------------------------------------------
# RUN
# -----------------------------------------------------------------------------
#
Localization
Network
#Initramfs
Users
BootLoader
Initramfs
