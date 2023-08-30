#! /bin/sh
#
#------------------------------------------------------------------------------
#   INDEX
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
#   VARIABLES
#------------------------------------------------------------------------------
#
echo "

- Bienvenido a este script de instalación, en esta ocasión instalaremos ArchLinux -

Recuerda que para instalar este sistema
debes estar conectado a internet, recomendamos ethernet,
si quieres usar wifi debes conectarte antes de iniciar este script.
Puedes salir dejanado presionado Ctrl + c hasta recuperar la linea de comandos.

Ahora que decides continuar,
primero debes elegir un tipo de instalación disponible:

  A) Vanilla:
    - Es el sistema base,
    - el kernel,
    - configuración básica,
    - y conexion a internet mediante ethernet dhcpcd.
    !Es perfecto para que personalices¡

  B) Custom:
    - Instalación vanilla mas:
    - Stack de audio y video,
    - entorno orientado a la terminal,
    - programas básicos de CLI.
    !Es un entorno ya creado solo le falta instalar grandes programas¡

  C) Enforce:
    - Intalación vanilla,
    - Instalación custom,
    - instalación de codecs,
    - instalación de programas poderosos pero pesados y que necesitan conocimiento:
        - Wine(capa que permite usar varios programas de windows).
        - Qemu(virtualizador, puedes virtualizar sistemas y hardware de todo tipo).
        - Ofimatica.
    !Es el sistema mas pesado pero tiene muchas maravillas ya configuradas¡

(A/B/C):
"
read -r INSTALLTYPE

# INSTALL DISK
echo "

Ahora debes elegir un disco en el cual instalaremos el sistema:
Recuerda que todo el disco será borrado y ocupado por el sistema.
Deberias de tener un disco solo para el sistema y otros para tus datos.

Ahora debes seleccionar un disco para realizar la instalacion.
De los discos disponibles,

$(lsblk | grep "disk")

Selecciona uno:
"
read -r INSTALLDISK
#
# TIME AND DATE
echo "

Ahora vamos a aplicar una zona horaria.
De esta depende tu reloj y calendario.
Dime cual es tu pais:
$(timedatectl list-timezones)

"
#timedatectl set-timexone Canada/eastern
read -r INSTALLCOUNTRY
#
# HOSTNAME
echo "

Ahora elije el nombre que tendra tu maquina.
Recuerda usar solo numeros y letras:
"
read -r INSTALLNAME
#
# USERS
echo "

Crearemos usuarios y contraseñas.

Primero crea la contraseña del ROOT.
El ROOT tiene acceso a todo en el sistema.
Escribe la contraseña del ROOT:
"
read -r INSTALLPASSWDROOT
#
echo "

Ahora crearemos un usuario.
¿El usuario será administrador, es decir usuario con acceso a todo?
(y/n):
"
read -r INSTALLUSERTYPE
echo "

¿Cual es el nombre del nuevo usuario?
"
read -r INSTALLUSERNAME

echo "

Escribe el password de este usuario:
"
read -r INSTALLPASSWDUSER
#
# PROVIDER OF DATA
sed -i "/# SPACE FOR THE VARIABLES FROM BASE.SH/a INSTALLCOUNTRY=${INSTALLCOUNTRY}" ./02.Config.sh
sed -i "/INSTALLCOUNTRY=${INSTALLCOUNTRY}/a INSTALLNAME=${INSTALLNAME}" ./02.Config.sh
sed -i "/INSTALLNAME=${INSTALLNAME}/a INSTALLPASSWDROOT=${INSTALLPASSWDROOT}" ./02.Config.sh
sed -i "/INSTALLPASSWDROOT=${INSTALLPASSWDROOT}/a INSTALLUSERTYPE=${INSTALLUSERTYPE}" ./02.Config.sh
sed -i "/INSTALLUSERTYPE=${INSTALLUSERTYPE}/a INSTALLUSERNAME=${INSTALLUSERNAME}" ./02.Config.sh
sed -i "/INSTALLUSERNAME=${INSTALLUSERNAME}/a INSTALLPASSWDUSER=${INSTALLPASSWDUSER}" ./02.Config.sh
#
sed -i "/# SPACE FOR THE VARIABLES FROM BASE.SH/a INSTALLUSERNAME=${INSTALLUSERNAME}" ./03.Custom.sh
#
#------------------------------------------------------------------------------
#   FUNCTIONS
#------------------------------------------------------------------------------
#
preInstalation (){
    setSys (){
        loadkeys la-latin1
        timedatectl set-ntp true
    }
    setSys

    diskProcess (){
        partDisk (){
            # for the system use Ext4
            # for storage and nas use zfs
            echo "
            Creando particiones para $INSTALLDISK
            "
            wipefs -a /dev/"$INSTALLDISK" echo "yes" | parted /dev/"$INSTALLDISK" mklabel gpt
            parted /dev/"$INSTALLDISK" mkpart efi fat32 1MiB 256MiB
            parted /dev/"$INSTALLDISK" set 1 esp on
            parted /dev/"$INSTALLDISK" mkpart swap linux-swap 256MiB 2000MiB
            parted /dev/"$INSTALLDISK" mkpart root ext4 2000MiB 100%
            echo "yes" | mkfs.fat -F 32 /dev/"$INSTALLDISK"1
            echo "yes" | mkswap /dev/"$INSTALLDISK"2
            echo "yes" | mkfs.ext4 /dev/"$INSTALLDISK"3
        }
        partDisk

        mountPart (){
            mount /dev/"$INSTALLDISK"3 /mnt
            swapon /dev/"$INSTALLDISK"2
            mount --mkdir /dev/"$INSTALLDISK"1 /mnt/boot/efi
        }
        mountPart
    }
    diskProcess
}

installOS (){
    mirrors (){
        sleep 4
        pacman -Sy --noconfirm
        pacman -S --noconfirm archlinux-keyring reflector
        reflector -f 40 -l 400 -a 24\
            -p "https,ftps" \
            -c "MX,US,CA,BR,EC,CL,AR,ES,FR,DE,TW,GB,KR,JP" \
            --threds 4 \
            --score 50 \
            --sort rate \
            --save /etc/pacman.d/mirrorlist \
            --verbose
    }
    mirrors

    installBaseSystem (){
        pacstrap -K /mnt \
            base base-devel pacman-contrib \
            linux-zen linux-zen-headers linux-zen-docs \
            linux-firmware linux-tools util-linux mkinitcpio \
            vi --noconfirm
    }
    installBaseSystem
}

postInstall (){
    fstab (){
        genfstab -U /mnt >> /mnt/etc/fstab
    }
    fstab

    otherScripts (){
        cp ArchWay/* /mnt

        if [ "${INSTALLTYPE}" = "A" ]; then
          arch-chroot /mnt /02.Config.sh
        elif [ "${INSTALLTYPE}" = "B" ]; then
          arch-chroot /mnt /02.Config.sh
          arch-chroot -u "${INSTALLUSERNAME}" /mnt /03.Custom.sh
        elif [ "${INSTALLTYPE}" = "C" ]; then
          arch-chroot /mnt /02.Config.sh
          arch-chroot -u "${INSTALLUSERNAME}" /mnt /03.Custom.sh
          arch-chroot -u "${INSTALLUSERNAME}" /mnt /04.Enforce.sh
        else
          echo "
          Si ves este mensaje ingresaste mal los datos que se te pidieron,
          reinicia y corre el script de nuevo
          "
        fi

        rm -Rfv /mnt/*.sh /mnt/lost+found
    }
    otherScripts
}
#
#------------------------------------------------------------------------------
#   RUN
#------------------------------------------------------------------------------
#
preInstalation
installOS
postInstall
