#! /bin/sh
#
#------------------------------------------------------------------------------
# INDEX
#------------------------------------------------------------------------------
#
#
#------------------------------------------------------------------------------
# VARIABLES
#------------------------------------------------------------------------------
#
# SPACE FOR THE VARIABLES FROM BASE.SH
#
#------------------------------------------------------------------------------
# FUNCTIONS
#------------------------------------------------------------------------------
#
# SYSADMIN
#
PKG() {
    Aur (){
        sudo pacman -S git --noconfirm
        git clone https://aur.archlinux.org/pikaur.git
        cd pikaur || exit
        makepkg -fsri --noconfirm
        pikaur -Syua --noconfirm
        cd ..
        rm pikaur
    }
    Aur
}
#
Booting() {
    MicroCode() {
        sudo pacman -S --noconfirm amd-ucode
        #pacman -S --noconfirm intel-ucode
    }
    MicroCode

    NumLock() {
        sudo pacman -S --noconfirm numlockx
    }
    NumLock

}
#
GUI() {
    DisplayServer(){
        sudo pacman -S --noconfirm xorg xorg-apps xorg-fonts xorg-font-util #xorg-drivers
        #pacman -S --noconfirm wayland wayland-docs wayland-protocols wayland-utils xorg-xwayland #xorg-xlsclients
    }
    DisplayServer

    DisplayDrivers() {
        sudo pacman -S --noconfirm mesa lib32-mesa mesa-utils lib32-mesa-utils libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau opencl-mesa lib32-opencl-mesa glu lib32-glu xf86-video-amdgpu amdvlk lib32-amdvlk vulkan-mesa-layers lib32-vulkan-mesa-layers
        # intel
        # nvidia
    }
    DisplayDrivers

    DesktopEnvironment() {
         sudo pacman -S --noconfirm xmonad xmonad-contrib xmonad-extras xmonad-utils xmobar
         xmonad --recompile && xmonad --restart
        feh dunst picom capitaine-cursors
        qt5ct
        poppler popplet-glib tumbler ffmpegthumbnailer poppler libgsf
    }
    DesktopEnvironment

    DisplayManager() {
        echo "hola"
        #~/.xinitrc
        #...
        #xscreensaver &
        #exec openbox-sessionHere Xfce is kept as default
        #
        #Make sure that startx is properly configured.
        #
        #Place the following in your login shell initialization file (e.g. ~/.bash_profile for Bash or ~/.zprofile for Zsh):
        #
        #if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
        #  exec startx
        #  fi
        #
        #session=${1:-xfce}
        #case $session in
        #    i3|i3wm           ) exec i3;;
        #    kde               ) exec startplasma-x11;;
        #    xfce|xfce4        ) exec startxfce4;;
        #    # No known session, try to run it as command
        #    *                 ) exec $1;;
        #esac
    }
    DisplayManager

    UserDirs() {
        sudo pacman -S --noconfirm xdg-user-dirs
        xdg-user-dirs-update
    }
    UserDirs
}
#
# POWERMANAGEMENT
#
Media() {
    SoundSys() {
        Alsa() {
            sudo pacman -S --noconfirm alsa-utils alsa-plugins lib32-alsa-plugins sof-firmware alsa-firmware alsa-tools
            echo 'defaults.pcm.rate_converter "speexrate_best"' >> /etc/asound.conf
            amixer sset Master unmute
            amixer sset Speaker unmute
            amixer sset Headphone unmute
        }
        Alsa

        Pipewire() {
            sudo pacman -S --noconfirm wireplumber pipewire lib32-pipewire pipewire-docs pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack lib32-pipewire-jack pipewire-zeroconf gst-plugin-pipewire
            cp /usr/share/pipewire/* /etc/pipewire/
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /etc/pipewire/client.conf
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /etc/pipewire/pipewire-pulse-conf
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /etc/pipewire/minimal.conf
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /etc/pipewire/pipewire-avb.conf
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /usr/share/pipewire/client.conf
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /usr/share/pipewire/pipewire-pulse-conf
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /usr/share/pipewire/minimal.conf
            sed -i "s/#resample.quality      = 4/resample.quality      = 10/g" /usr/share/pipewire/pipewire-avb.conf
            systemctl --user enable wireplumber pipewire pipewire-pulse
        }
        Pipewire
    }
    SoundSys
}
#
Networking() {
    ClockSync() {
        sudo pacman -S --noconfirm ntp
        timedatectl set-ntp true
        hwclock --systohc
        timedatectl set-local-rtc 0
    }
    ClockSync

    DNSSecurity() {
        sudo pacman -S --noconfirm ldns
        #dnsovertls
        #dnsoverhttps
        #dnscrypt
        #https://wiki.archlinux.org/title/Domain_name_resolution#DNS_servers
        # bind unbound
    }
    DNSSecurity

    Firewall() {
        sudo pacman -S iptables ufw --noconfirm
        systemctl enable ufw
        systemctl enable iptables
        ufw default deny
        ufw enable
    }
    Firewall

    NetworkingShares() {
       # https://wiki.archlinux.org/title/SSHFS
       echo "hey"
    }
    NetworkingShares

    Hosts() {
        curl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts >> /etc/hosts
        sed -i '/# Custom host records are listed here./a 127.0.1.1 M3K4.localdomain        M3K4' /etc/hosts
    }
    Hosts
}
#
InputDevice() {
    KeyboardLayout(){
        Vconsole() {
            #    https://wiki.archlinux.org/title/Keyboard_configuration_in_console
            #    localectl list-keymaps
            #    loadkeys la-latin1
            #    /etc/vconsole.conf
            #    KEYMAP=uk
            echo 'KEYMAP=la-latin1' > /etc/vconsole.conf
        }
        Vconsole

        Xorg() {
            #https://wiki.archlinux.org/title/Keyboard_configuration_in_Xorg
            #setxkbmap latam
            echo 'Section "InputClass"
                    Identifier "system-keyboard"
                    MatchIsKeyboard "on"
                    Option "XkbLayout" "latam,us"
                    Option "XkbOptions" "grp:alt_shift_toggle"
            EndSection' >> /etc/X11/xorg.conf.d/00-keyboard.conf
        }
        Xorg
    }
    KeyboardLayout

    #MouseButtons(){
    #    https://wiki.archlinux.org/title/Mouse_buttons
    #}
    #MouseButtons

    LaptopTouchpads(){
        sudo pacman -S --noconfirm libinput xf86-input-libinput xf86-input-synaptics
        echo 'Section "InputClass"
            Identifier "touchpad"
            Driver "synaptics"
            MatchIsTouchpad "on"
                Option "TapButton1" "1"
                Option "TapButton2" "3"
                Option "TapButton3" "2"
                Option "VertEdgeScroll" "on"
                Option "VertTwoFingerScroll" "on"
                Option "HorizEdgeScroll" "on"
                Option "HorizTwoFingerScroll" "on"
                Option "CircularScrolling" "on"
                Option "CircScrollTrigger" "2"
                Option "EmulateTwoFingerMinZ" "40"
                Option "EmulateTwoFingerMinW" "8"
                Option "CoastingSpeed" "0"
                Option "FingerLow" "30"
                Option "FingerHigh" "50"
                Option "MaxTapTime" "125"
        EndSection' >> /etc/X11/xorg.conf.d/70-synaptics.conf
    }
    LaptopTouchpads

    TrackPoints(){
        #https://wiki.archlinux.org/title/TrackPoint
        sudo pacman -S xf86-input-evdev xf86-input-libinput
    }
    TrackPoints
}
#
Optimization() {
    #Performance() {
        #https://wiki.archlinux.org/title/Improving_performance
        #https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/performance_tuning_guide/index
    #}
    #Performance
    SSD() {
        sudo pacman -S --noconfirm hdparm sdparm
        system enable fstrim.service
        system enable fstrim.timer
    }
    SSD

    Usb() {
        sudo pacman -S --noconfirm usbutils
    }
    Usb
}
#
SysServices() {
    FIaS() {
        sudo pacman -S --noconfirm mlocate
        systemctl enable updatedb.timer
    }
    FIaS
    #Mail() {
    #https://wiki.archlinux.org/title/Mail_server
    #}
    #Mail
    #Printing() {
    #    sudo pacman -S --noconfirm cups cups-pdf
    #}
}
#
Appearance() {
    Fonts() {
        sudo pacman -S --noconfirm awesome-terminal-fonts ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common  ttf-nerd-fonts-symbols-mono powerline-fonts ttf-dejavu ttf-dejavu-nerd ttf-liberation ttf-liberation-mono-nerd noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-noto-nerd gsfonts gnu-free-fonts ttf-arphic-uming ttf-indic-otf oft-latin-modern oft-latinmodern-math sdl2_ttf sdl_ttf lib32-sdl2_ttf lib32-sdl_ttf
        #https://wiki.archlinux.org/title/Font_configuration
    }
    Fonts

    Themes() {
        #GTK() {
        #    #https://wiki.archlinux.org/title/GTK
        #}
        #GTK

        #QT() {
        #    #https://wiki.archlinux.org/title/Qt
        #}
        #QT

        UniformLook() {
            #https://wiki.archlinux.org/title/Uniform_look_for_Qt_and_GTK_applications
            pikaur -S qt5-styleplugins --noconfirm
        }
        UniformLook
    }
    Themes
}
#
Console() {
    Tab() {
        bash-completion shellharden
    }
    Tab

    #Aliases() {
    #}
    #Aliases

    Shell() {
        sudo pacman -S --noconfirm zsh
    }
    Shell

    Bash() {
        echo "set editing-mode vi
        set show-mode-in-prompt on
        set show-all-if-ambiguous on
        # Color files by types
        # # Note that this may cause completion text blink in some terminals (e.g. xterm).
        set colored-stats On
        # # Append char to indicate type
        set visible-stats On
        # # Mark symlinked directories
        set mark-symlinked-directories On
        # # Color the common prefix
        set colored-completion-prefix On
        # # Color the common prefix in menu-complete
        set menu-complete-display-prefix On" >> "$HOME"/.inputrc

        echo "clear
        reset
        " >> "$HOME"/.bash_logout
    }
    Bash

    Color() {
        XResources() {
            echo "! Copyright (c) 2016-present Arctic Ice Studio <development@arcticicestudio.com>
            ! Copyright (c) 2016-present Sven Greb <code@svengreb.de>

            ! Project:    Nord XResources
            ! Version:    0.1.0
            ! Repository: https://github.com/arcticicestudio/nord-xresources
            ! License:    MIT

            #define nord0 #2E3440
            #define nord1 #3B4252
            #define nord2 #434C5E
            #define nord3 #4C566A
            #define nord4 #D8DEE9
            #define nord5 #E5E9F0
            #define nord6 #ECEFF4
            #define nord7 #8FBCBB
            #define nord8 #88C0D0
            #define nord9 #81A1C1
            #define nord10 #5E81AC
            #define nord11 #BF616A
            #define nord12 #D08770
            #define nord13 #EBCB8B
            #define nord14 #A3BE8C
            #define nord15 #B48EAD

            *.foreground:   nord4
            *.background:   nord0
            *.cursorColor:  nord4
            *fading: 35
            *fadeColor: nord3

            *.color0: nord1
            *.color1: nord11
            *.color2: nord14
            *.color3: nord13
            *.color4: nord9
            *.color5: nord15
            *.color6: nord8
            *.color7: nord5
            *.color8: nord3
            *.color9: nord11
            *.color10: nord14
            *.color11: nord13
            *.color12: nord9
            *.color13: nord15
            *.color14: nord7
            *.color15: nord6" > "$HOME"/.Xresources
        }
        XResources

        Terminals() {
            Vconsole() {
                echo '
                if [ "$TERM" = "linux" ]; then
                    _SEDCMD="s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p"
                    for i in $(sed -n "$_SEDCMD" $HOME/.Xresources | awk "$1 < 16 {printf "\\e]P%X%s", $1, $2}"); do
                        echo -en "$i"
                    done
                    clear
                fi
                ' >> "$HOME"/.bashrc
            }
            Vconsole

            LoginScreen() {
                cp /etc/issue /etc/issue.bak
                echo '^[[H^[[2J' > /etc/issue
                echo '^[[1;33m' >> /etc/issue
                echo '^[[1;33m               +' >> /etc/issue
                echo '^[[1;33m               A' >> /etc/issue
                echo '^[[1;33m              RCH               ^[[0;33m Arch Linux \r' >> /etc/issue
                echo '^[[1;33m             ARCHA              ^[[0;33m Time is \t' >> /etc/issue
                echo '^[[1;33m             RCHARC             ^[[0;33m \l @ \n' >> /etc/issue
                echo '^[[1;33m            ; HARCH;            ^[[0;33m' >> /etc/issue
                echo '^[[1;33m           +AR.CHARC            ^[[0;33m' >> /etc/issue
                echo '^[[1;33m          +HARCHARCHA           ^[[0;33m' >> /etc/issue
                echo '^[[1;33m         RCHARC^[[0;33m\HARCH^[[1;33m\AR;          ^[[0;33m' >> /etc/issue
                echo '^[[1;33m        CHA^[[0;33m\RCHARCHARCHA^[[1;33m+         ^[[0;33m' >> /etc/issue
                echo '^[[1;33m       R^[[0;33m\CHARCH   ARCHARC        ^[[0;33m' >> /etc/issue
                echo '^[[0;33m     .HARCHA;     ;RCH;`\".' >> /etc/issue
                echo '^[[0;33m    .ARCHARC;     ;HARCH.' >> /etc/issue
                echo '^[[0;33m    ARCHARCHA.   .RCHARCHA`' >> /etc/issue
                echo "^[[0;33m   RCHARC'           'HARCHA" >> /etc/issue
                echo '^[[0;33m  ;RCHA                 RCHA;' >> /etc/issue
                echo "^[[0;33m  RC'                     'HA" >> /etc/issue
                echo "^[[0;33m R'                        \`C" >> /etc/issue
                echo "^[[0;33m'                           \`" >> /etc/issue
                echo '^[[0m' >> /etc/issue
            }
            LoginScreen
        }
        Terminals
    }
    Color

    CompressedFiles() {
        sudo pacman -S --noconfirm p7zip unrar libunrar unarchiver bzip2 tar
    }
    CompressedFiles

    Prompt() {
        myZsh() {
            #powerline
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
            git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
            sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' $HOME/.zshrc
            sed -i 's/plugins=(git)/plugins=(\n)/g' $HOME/.zshrc
            sed -i '/plugins=(/a zsh-syntax-highlighting' $HOME/.zshrc
            sed -i '/plugins=(/a zsh-completions' $HOME/.zshrc
            sed -i '/plugins=(/a zsh-autosuggestions' $HOME/.zshrc
            sed -i '/plugins=(/a extract' $HOME/.zshrc
            sed -i '/plugins=(/a command-not-found' $HOME/.zshrc
            sed -i '/plugins=(/a colored-man-pages' $HOME/.zshrc
            chsh -s /bin/zsh "${INSTALLUSERNAME}"
        }
        myZsh

        Terminal() {
            sudo pacman -S --noconfirm alacritty
            sudo pacman -S --noconfirm vim vifm ueberzug htop fzf scrot xclip
            pikaur -S --noconfirm dragon-drop
            git clone https://github.com/cirala/vifmimg "$HOME"/.config/vifm/scripts
        }
        Terminal

        Launcher() {
            sudo pacman -S --noconfirm rofi rofi-calc rofi-emoji rofi-pass rofimoji
        }
        Launcher
    }
    Prompt

    Session() {
        sudo pacman -S --noconfirm tmux
    }
    Session
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
##SysAdmin
##PKG
#Booting
#GUI
##PowerMgt
#Media
#Networking
#InputDevice
#Optimization
#SysServices
#Appearance
#Console
#Tail
