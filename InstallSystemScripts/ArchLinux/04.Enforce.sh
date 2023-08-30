#! /bin/sh
#
#------------------------------------------------------------------------------
# INDEX
#------------------------------------------------------------------------------
#
#------------------------------------------------------------------------------
# VARIABLES
#------------------------------------------------------------------------------
#
# SPACE FOR THE VARIABLES FROM BASE.SH
#
#------------------------------------------------------------------------------
# FUNCTIONS
#t------------------------------------------------------------------------------
#
#https://wiki.archlinux.org/title/List_of_applications#top-page
#
Internet() {
    Browsers() {
        sudo pacman -S --noconfirm w3m chromium firefox firefox-i18n-es-mx firefox-i18n-en-us firefox-i18n-pt-br firefox-i18n-fr
    }
    Browsers

    #WebServer() {
    #    sudo pacman -S --noconfirm apache caddy lighttpd nginx
    #}
    #WebServer

    FileSharing() {
        sudo pacman -S --noconfirm transmission-cli wget curl curlftpfs libcurl-compat libcurl-gnutls lib32-libcurl-compat lib32-libcurl-gnutls
        pikaur -S --noconfirm jdownloader2
        #sudo pacman -S nextcloud filezilla amule kubo
    }
    FileSharing

    Comunication() {
        sudo pacman -S --noconfirm newsboat thunderbird thunderbird-i18n-es-es thunderbird-i18n-en-us thunderbird-i18n-pt-br thunderbird-i18n-fr
        #sudo pacman -S --noconfirm mutt neomutt finch castget
        #sudo pacman -S --noconfirm fractal
        #pikaur -S --noconfirm barnowl toot
    }
    Comunication
}
#
Media() {
    Codecs() {
        sudo pacman -S --noconfirm flac wavpack
        sudo pacman -S --noconfirm lame a52dec libdca libmad libmpcdec opencore-amr opus speex libvorbis faac faad2 libfdk-aac fdkaac
        sudo pacman -S --noconfirm jasper libwebp libavif libheif
        sudo pacman -S --noconfirm svt-av1 libde265 libdv libmpeg2 schroedinger libtheora libvpx x264 x265 xvidcore
        sudo pacman -S --noconfirm mkvtoolnix-cli ogmtools
        sudo pacman -S --noconfirm gstreamer lib32-gstreamer gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qml6 gst-plugin-qmlgl gst-plugin-qsv gst-plugin-va gst-plugin-wpe gst-plugins-bad gst-plugins-bad-libs gst-plugins-base gst-plugins-base-libs gst-plugins-good gst-plugins-ugly gst-plugins-espeak lib32-gst-plugins-base lib32-gst-plugins-base-libs lib32-gst-plugins-good
    }
    Codecs

    Image() {
        sudo pacman -S --noconfirm feh imagemagick scrot
        #sudo pacman -S --noconfirm  gimp krita inkscape blender gpick xcolor
        #pikaur -S ---noconfirm dia
    }
    Image

    Audio() {
        sudo pacman -S --noconfirm mpd mpc ncmpcpp pulsemixer
        #sudo pacman -S --noconfirm beets easytag picard audacity ardour lmms muse non-timeline non-sequencer non-mixer new-session-manager lilypond musescore cardinal csound csoundqt ams din drumstick helm hydrogen mixxx guitarix Glava
    }
    Audio

    Video() {
        sudo pacman -S --noconfirm ffmpeg mpv yt-dlp btfs fuse libtorrent subdl
        #pikaur -S --noconfirm davinci-resilve lightworks kdenlive aegisub gaupol subtitleeditor obs-studio guvcview v4l2loopback-dkms v4l-utils
        #see miracast
        #https://en.wikipedia.org/wiki/Miracast
        #https://en.wikipedia.org/wiki/Miracast
    }
    Video

    Server() {
        echo "hey"
        #sudo pacman -S --noconfirm icecast jellyfin
    }
    Server

    MetaData() {
        echo "hey"
        #sudo pacman -S --noconfirm exiv2
    }
    MetaData
}
#
Utilities() {
    Terminal() {
        sudo pacman -S --noconfirm alacritty tmux
        #sudo pacman -S --noconfirm kitty
    }
    Terminal

    Files() {
        sudo pacman -S --noconfirm vifm
        # sudo pacman -S --noconfirm fff
    }
    Files

    Develop() {
        sudo pacman -S --noconfirm git vim jq node npm yarn
        #sudo pacman -S --noconfirm plantuml bugzilla godot
        #https://cli.github.com/
    }
    Develop

    TextInput() {
        echo "hey"
        #sudo pacman -S --noconfirm onboard sxhkd
    }
    TextInput

    Disk() {
        sudo pacman -S --noconfirm ncdu udev udiskie udisks2 ntfs-3g autofs mtpfs android-udev gvfs-mtp bleachbit
        #
        # android en archlinux
        # simple-mtpfs -l # list device
        # simple-mtpfs --device {number} {dir} # mount
        # fusermount -u {dir} # umount
        #paru -S --noconfirm simple-mtpfs
    }
    Disk

    System() {
        sudo pacman -S --noconfirm htop kmon # cronie fcron
        # screen management
        # backlight management
        # color management
        # printer management
        sudo pacman -S --noconfirm bluez bluez-tools bluez-utils # bluez-cups bluez-hid2hci
        pikaur -S --noconfirm rofi-bluetooth-git rofi-wifi-menu-git
        sed -i "s/#AutoEnable=true/AutoEnable=true/g" /etc/bluetooth/main.conf
        systemctl --user enable bluetooth
        # power management
        # system management
        # boot management
        sudo pacman -S --noconfirm qemu-full
        sudo pacman -S --noconfirm wine wine-nine vkd3d lib32-vkd3d giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader
        sudo pacman -S --noconfirm vulkan-tools vulkan-swrast vulkan-virtio lib32-vulkan-swrast lib32-vulkan-virtio vulkan-extra-layers vulkan-extra-tools
        #pikaur -S --noconfirm dxvk-bin libdxvk lib32-libdxvk
        #WINEPREFIX=~/.wine setup_dxvk install
        #install vkd3d dxvk
        # mangohud para fps en juegos
        #paru -S --noconfirm mangoapp mangohud mandohud-common lib32-mangoapp lib32-mangohud goverlay-bin
    }
    System
}
#
Documents() {
    TextEditors() {
        sudo pacman -S vi vim
        #pikaur -S vscodium-bin vscodium-bin-marketplace vscodium-bin-features
    }
    TextEditors

    Office() {
        sudo pacman -S --noconfirm libreoffice-fresh hunspell hunspell-es_mx hunspell-en_us languagetool pdftotext
        #sudo pacman -S scribus --noconfirm
        #sudo pacman -S wordgrinder mdp sc groff texlive texlive-langspanish texlive-langenglish texlive-langportuguese texlive-langfrench scantailor-advanced cuneiform gocr ocrad dictd sdcv translate-shell translate-toolkit barcode qrencode zbar zint
        #
    }
    Office

    Readers() {
        sudo pacman -S zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-pdf-poppler zathura-ps
    }
    Readers
}
#
Security() {
    #Net() {
    #}
    #Net

    #Fwall() {
    #    sudo pacman -S --noconfirm iptables ufw
    #}
    #Fwall

    AntiMalware() {
        sudo pacman -S --noconfirm clamav rkhunter
    }
    AntiMalware

    Screenlocker() {
        sudo pacman -S --noconfirm xsecurelock
        #sudo pacman -S --noconfirm vlock
    }
    Screenlocker

    Passwd() {
        sudo pacman -S keepassxc
        #sudo pacman -S --noconfirm pass vault
    }
    Passwd

    Cryptography() {
        sudo pacman -S --noconfirm gnupg openssh
    }
    Cryptography

    #PrivilegeElevation() {
    #    sudo pacman -S --noconfirm sudo
    #}
    #PrivilegeElevation
}
#
Science() {
    #Math() {
    #    sudo pacman -S --noconfirm geogebra gnuplot
    #}
    #Math

    Engineering() {
        pikaur -S --noconfirm webots-bin
        #sudo pacman -S --noconfirm freecad openscad arduino ngspice kicad
    }
    Engineering

    #ComputerScience() {
    #    sudo pacman -S --noconfirm python-pytorch
    #    #pikaur -S --noconfirm gns3-gui gns3-server gns3-converter openmvs openmvg
    #    #sudo pacman -S --noconfirm alice-vision
    #}
    #ComputerScience
}
#
Others() {
    Searx() {
        cd /tmp || exit
        git clone https://github.com/searx/searx searx
        cd searx || exit
        sudo -H ./utils/searx.sh install all
        cd ..
        rm searx
    }
    Searx

    #Organization() {
    #    #sudo pacman -S --noconfirm calcurse khal remind when task todoman
    #}
    #Organization

    #Edu() {
    #    #pikaur -S --noconfirm moodle openboard gtypist
    #}
    #Edu

    Accessibility() {
        sudo pacman -S --noconfirm espeak-ng
        #sudo pacman -S --noconfirm screenkey
    }
    Accessibility
}
#
Tail() {
    grub-mkconfig -o /boot/grub/grub.cfg
    sed -i "s/set timeout=5/set timeout=0/g" /boot/grub/grub.cfg
}
#
#------------------------------------------------------------------------------
# RUN
#------------------------------------------------------------------------------
#
Internet
Media
Utilities
Documents
Security
Science
Others
Tail
forWine.sh
