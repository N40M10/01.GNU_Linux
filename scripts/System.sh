#! /bin/bash
#
# icons usefull
# audio-recorder-off
# audio-recorder-on
# audio-recorder-paused
#audio-input-microphone-high.svg
#audio-input-microphone-low.svg
#audio-input-microphone-medium.svg
#audio-input-microphone-muted.svg
#record-desktop
#green-recorder
#media-image
#
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Add description of the script functions here."
   echo
   echo "Syntax: scriptTemplate [-g|h|v|V]"
   echo "options:"
   echo "g     Print the GPL license notification."
   echo "h     Print this Help."
   echo "v     Verbose mode."
   echo "V     Print software version and exit."
   echo
}

# Set variables
#Name="world"

############################################################
# Process the input options. Add options as needed.        #
############################################################
#
# Get the options
#while getopts ":hn:" option; do
#   case $option in
#      h) # display Help
#         Help
#         exit;;
#      n) # Enter a name
#         Name=$OPTARG;;
#     \?) # Invalid option
#         echo "Error: Invalid option"
#         exit;;
#   esac
#done
#
#echo "hello $Name!"

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

############################################################
# Vars                                                     #
############################################################
#
VAR1=$1
VAR2=$2
VAR3=$3
#VAR4=$4
#VAR5=$5
#VAR6=$6
#VAR7=$7
#VAR8=$8
#VAR9=$9
#
### -----------------------------------------------------------
###  TEXTO ----------------------------------------------------
### -----------------------------------------------------------

SysTexto (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

### -----------------------------------------------------------
###  IMAGEN ---------------------------------------------------
### -----------------------------------------------------------

SysImage (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

screenShot (){
    screenShotSelect() {
        scrot -s -f '%F-%T-Select-$wx$h.png' -q 100 \
            -l style=dash,opacity=0,color="red",mode=classic \
            -e 'mv $f ~/Downloads && dunstify -i media-image -r 2593 -u normal "Screenshot select in: ~/Downloads\n$n"'
    }

    screenShotWindow() {
        scrot -ub '%F-%T-Window-$wx$h.png' -q 100 \
            -e 'mv $f ~/Downloads && dunstify -i media-image -r 2593 -u normal "Screenshot window in: ~/Downloads\n$n"'
    }

    screenShotFull() {
        scrot '%F-%T-Full-$wx$h.png' -q 100 \
            -e 'mv $f ~/Downloads && dunstify -i media-image -r 2593 -u normal "Screenshot full in: ~/Downloads\n$n"'
    }

    case $VAR2 in
        screenShotFull)
            screenShotFull
            ;;
        screenShotWindow)
            screenShotWindow
            ;;
        screenShotSelect)
            screenShotSelect
            ;;
    esac
}

### -----------------------------------------------------------
###  AUDIO ----------------------------------------------------
### -----------------------------------------------------------

SysAudio (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

setVolume() {
    isVolume() {
        VOL=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -b 9-)
        echo "$VOL * 100" | bc -l | cut --complement -d "." -f 2
    }

    isMute() {
        wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oE '[^ ]+$' | grep MUTED > /dev/null
    }

    getVolume() {
      if isMute ; then
        dunstify -i audio-volume-muted -r 2593 -u normal "MUTED"
      else
        #bar=$(seq --separator="█" $((volume / 4)) | sed 's/[0-9]//g')
        volume=$(isVolume)
        if [ "$volume" -eq 0 ] ; then
          dunstify -i audio-volume-muted -r 2593 -u normal "$volume/100 Volume"
        elif [ "$volume" -lt 20 ] ; then
          dunstify -i audio-volume-low -r 2593 -u normal "$volume/100 Volume"
        elif [ "$volume" -gt 80 ]; then
          dunstify -i audio-volume-high -r 2593 -u normal "$volume/100 Volume"
        else
          dunstify -i audio-volume-medium -r 2593 -u normal "$volume/100 Volume"
        fi
      fi
    }

    case $VAR2 in
      GET)
        getVolume
        ;;
      MUTE)
        wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle > /dev/null
        getVolume
        ;;
      DOWN)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0 > /dev/null
        getVolume
        ;;
      UP)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0 > /dev/null
        getVolume
        ;;
    esac
}

### -----------------------------------------------------------
###  VIDEO ----------------------------------------------------
### -----------------------------------------------------------

SysVideo() {
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

SetBright() {
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac

    function get_brightness {
      xbacklight -get | cut -d '.' -f 1
    }

    function send_notification {
      icon="preferences-system-brightness-lock"
      brightness=$(get_brightness)
      # Make the bar with the special character ─ (it's not dash -)
      # https://en.wikipedia.org/wiki/Box-drawing_character
      bar=$(seq -s "█" 0 $((brightness / 20)) | sed 's/[0-9]//g')
      # Send the notification
      dunstify -i "$icon" -r 5555 -u normal "    $bar"
    }

    case $1 in
      up)
        # increase the backlight by 5%
        xbacklight -inc 20
        send_notification
        ;;
      down)
        # decrease the backlight by 5%
        xbacklight -dec 20
        send_notification
        ;;
    esac
}

### -----------------------------------------------------------
###  CODIGO ---------------------------------------------------
### -----------------------------------------------------------

SysCode (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

clipboard() {
    copyFile() {
        xclip -sel clip "$VAR3"
    }

    case $VAR2 in
        copyFile)
            copyFile
            ;;
    esac
}

setKeyLayout (){
    setLatam (){
        setxkbmap latam
    }
    setUs (){
        setxkbmap us
    }
    setPt (){
        setxkbmap pt
    }
    setFr (){
        setxkbmap Fr
    }

    case $VAR2 in
        setLatam)
            setLatam
            ;;
        setUs)
            setUs
            ;;
        setPt)
            setPt
            ;;
        setFr)
            setFr
            ;;
    esac
}

TerminalTmux (){
    # ----------------------------
    #  VARs
    # ----------------------------

    TMUXTIME=0.02
    NAMETAB=()
    DIRPLACE=()
    SHELLPLACE=()
    SECONDSHELLPLACE=()

    # ----------------------------
    #   FNs
    # ----------------------------

    TmuxFn (){
        searchAttach=$(tmux ls 2> /dev/null | grep -c "$1" )
        if [ "$searchAttach" == 0 ]; then
            ## Create the nuew session for temux, this contain the windows
            tmux new-session -d -s "$1" &> /dev/null
            ## create the window
            ## rename 0 window of the session
            tmux rename-window -t "$1" "${NAMETAB[0]}" &> /dev/null  && sleep "$TMUXTIME"

            #"$1:$i.$i"

            # create windows
            for((i=0; i < ${#NAMETAB[@]}; i++)); do
                # create window for the session, the windows contain the panes
                tmux new-window -t "$1:$i" &> /dev/null && sleep "$TMUXTIME"
                tmux rename-window -t "$1:$i" "${NAMETAB[i]}" &> /dev/null  && sleep "$TMUXTIME"
                # split for the pane in each window
                tmux split-window -v -t "$1:$i" &> /dev/null && sleep "$TMUXTIME"
                tmux select-pane -t "$1:$i.0" && sleep "$TMUXTIME" &> /dev/null
                tmux split-window -h -t "$1:$i" &> /dev/null && sleep "$TMUXTIME"
                # command for each pane in each window
                tmux send-keys -t "$1:$i.2" "${DIRPLACE[i]}" Enter &> /dev/null && sleep "$TMUXTIME"
                tmux send-keys -t "$1:$i.1" "${SECONDSHELLPLACE[i]}" Enter &> /dev/null && sleep "$TMUXTIME"
                tmux send-keys -t "$1:$i.0" "${SHELLPLACE[i]}" Enter &> /dev/null && sleep "$TMUXTIME"
                # clear each prompt
                tmux send-keys -t "$1:$i.1" "clear" Enter &> /dev/null && sleep "$TMUXTIME"
                for((j=0; j < $2; j++)); do
                    tmux send-keys -t "$1:$j.0" "clear" Enter &> /dev/null && sleep "$TMUXTIME"
                    tmux send-keys -t "$1:$j.0" "clear" Enter &> /dev/null && sleep "$TMUXTIME"
                done
                # select the pane 0 of each window
                tmux select-pane -t "$1:$i.0" &> /dev/null  && sleep "$TMUXTIME"
                tmux select-pane -t "$1:0.0" &> /dev/null  && sleep "$TMUXTIME"
            done

            tmux select-window -t 0 && sleep "$TMUXTIME" &> /dev/null
            ## Save the session, you can close the terminal but the session still works
            tmux attach-session -t "$1" &> /dev/null
        else
            # Save the session, you can close the terminal but the session still works
            tmux attach-session -t "$1" &> /dev/null
        fi
    }

    RS (){
        # VAR ----------------
        # This arrays make the name of tabs
        # and take de dirs for the cli
        NAMETAB+=(
            "RS"
        )
        DIRPLACE+=(
            "vifmrun $HOME $HOME"
        )
        SHELLPLACE+=(
            "cd $HOME"
        )
        SECONDSHELLPLACE+=(
            "cd $HOME"
        )
        # RUN ----------------
        # This Parameter make the name for the session in tmux
        # This number make clear cicles
        TmuxFn RS 4
    }

    ST (){
        # VAR ----------------
        # This arrays make the name of tabs
        # and take de dirs for the cli
        NAMETAB+=("ZSH")
        DIRPLACE+=("vifmrun $HOME $HOME")
        SHELLPLACE+=("cd $HOME")
        SECONDSHELLPLACE+=("exit")
        # RUN ----------------
        # This Parameter make the name for the session in tmux
        # This number make clear cicles
        TmuxFn ST 3
    }

    # ----------------------------
    #   Calls
    # ----------------------------

    case $VAR2 in
        RS)
            RS
            ;;
        ST)
            ST
            ;;
    esac
}

Deamon (){ #udiskie -ansr --file-manager vifm &
    #while true; do
    #    dwm > /dev/null 2>&1
    #done
    #exec dwm

    xsetroot -xcf /usr/share/icons/capitaine-cursors-light/cursors/left_ptr 12 &
    xset -xcf /usr/share/icons/capitaine-cursors/cursors/left_ptr 12 &
    xmodmap -quiet -e "pointer = 3 2 1" &
    xset m 0/0 1 r rate 500 30 b on &
    setxkbmap -layout latam,us -option grp:alt_shift_spacetoggle &
    ~/.config/scripts/System.sh mountDevice &
    ~/.config/wallpaper/wall.sh &
    picom --config ~/.config/picom/picom.conf -b &
    dunst --config ~/.config/dunst/dunstrc &
    numlockx &
    exec xmonad
}

mountDevice() {
    sudo mkdir -p /run/mount/m00n/{ONE,TWO,THREE}
    sudo mount /dev/sda4 /run/mount/m00n/ONE
    sudo mount /dev/sdb1 /run/mount/m00n/TWO
    sudo mount /dev/sdc1 /run/mount/m00n/THREE
}

Upgrade (){
    echo -e "
        \r | UPGRADE |
    "
    sleep 2

    # Mirrors
    echo -e "
        \r [ sudo pacman -Sy ]
        \r [ sudo pacman -S reflector --color=auto --noconfirm ]
        \r [ reflector --save /etc/pacman.d/mirrorlist --sort rate --verbose -c 'MX,US,CO,EC,BR,CL,ES,FR,DE,GB' --score 50 --protocol 'http,https,ftp' ]
        \r [ sudo pacman -Sy archlinux-keyring --color=auto --noconfirm ]
    "
    sleep 2
    sudo pacman -Sy
    sudo pacman -S reflector --color=auto --noconfirm
    sudo reflector -f 200 -l 200 --save /etc/pacman.d/mirrorlist --sort rate --verbose -c 'MX,US,CO,EC,BR,CL,ES,FR,DE,GB' --score 40 --protocol 'https,ftps'
    sudo pacman -Sy archlinux-keyring --color=auto --noconfirm

    # Upgrade
    echo -e "
        \r [ sudo pacman -Syu --noconfirm ]
        \r [ paru -Syu --noconfirm ]
    "
    sleep 2
    sudo pacman -Syu --noconfirm
    pikaur -Syu --noconfirm

    # Recompile
    echo -e "
        \r [ xmonad --recompile ]
        \r [ xmonad --restart ]
    "
    sleep 2
    xmonad --recompile
    xmonad --restart

    # End
    echo '[ El Sistema esta actualizado al dia ]'
    sleep 8
}

Clean (){
    echo -e "
        \r | CLEAN |
    "

    # Pacman/Pikaur
    echo -e "
    \r [ sudo pacman -Rs \$(pacman -Qtdq) --noconfirm ]
    \r [ sudo pacman -Scc --noconfirm ]
    \r [ pikaur -Rs \$(paru -Qtdq) --noconfirm ]
    \r [ pikaur -Scc --noconfirm ]
    "
    sleep 2
    sudo pacman -Rs "$(pacman -Qtdq)" --noconfirm
    sudo pacman -Scc --noconfirm
    pikaur -Rs "$(pikaur -Qtdq)" --noconfirm
    pikaur -Scc --noconfirm

    # Swap [Swappiness]
    echo -e "
        \r [ sudo sysctl -w vm.swappiness=1 ]
        \r [ sudo swapoff -a && sudo swapon -a ]
    "
    sleep 2
    sudo sysctl -w vm.swappiness=1
    sudo swapoff -av
    sudo swapon -av
     sudo sync; echo 3 > /proc/sys/vm/drop_caches &&

    # HDD
    echo -e "
        \r [ rm .local/share/Trash ]
    "

    sleep 8
}

# Pendiente de mejora
mountIso(){
    isoFile=$1
    sudo mkdir /mnt/iso
    sudo mount "$isoFile" /mnt/iso -o loop
}

makeLiveUsb() {
    isoDistro=$VAR2
    storageDevice=$VAR3

    sudo dd \
        if="$isoDistro" \
        of="$storageDevice" \
        status=progress && sync
}

Backup (){
    echo "entrabajo"
}

### -----------------------------------------------------------
###  RUN ------------------------------------------------------
### -----------------------------------------------------------

$VAR1
