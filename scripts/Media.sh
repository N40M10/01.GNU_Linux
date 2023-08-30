#! /bin/bash
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

###  LOCAL ----------------------------------------------------

MediaTextoLocal (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

###  STREAM ----------------------------------------------------

MediaTextoStream (){
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

###  LOCAL ----------------------------------------------------

MediaImageLocal (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

###  STREAM ----------------------------------------------------

MediaImageStream (){
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
###  AUDIO ----------------------------------------------------
### -----------------------------------------------------------

###  LOCAL ----------------------------------------------------

MediaAudioLocal() {
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

textToAudio() {
    archivo=$VAR3
    clearName=$( echo "$archivo" | rev | cut -c 5- | rev)

    español() {
        espeak -v es-la -p 0 -s 400 -a 200 -f "$archivo" -w "$clearName.wav"
    }

    case $VAR2 in
        español)
            español
            echo "$VAR2"
            echo "$archivo"
            echo "$clearName"
            ;;
    esac
    echo "textToAudio"
}

musicPlayer() {
    mpdRun="$(pgrep -c mpd)"
    ncmpcppRun="$(pgrep -c ncmpcpp)"

    notifySend() {
        MPCFORMAT=$(mpc --format '%title%\n%album%\n%artist%' current)
        MPCSTATUS=$(mpc status 'Vol:%volume% R:%random% C:%consume%\n\%state%: %currenttime%/%totaltime%')
        notify-send -i emblem-music-symbolic -r 2593 -u normal "$MPCFORMAT" "$MPCSTATUS"
    }

    toggleMpd() {
        if [ "$mpdRun" -eq 0 ]; then
            mpd &&
            alacritty -e ncmpcpp &&
            mpc play
        else
            killall -9 mpd
            killall -9 ncmpcpp
        fi
    }

    toggleNcmpcpp() {
        if [ "$ncmpcppRun" -eq 0 ]; then
            alacritty -e ncmpcpp
        else
            killall -9 ncmpcpp
        fi
    }

    prev() {
        mpc prev && notifySend
    }

    toggle() {
        mpc toggle && notifySend
    }

    next() {
        mpc next && notifySend
    }

    positionDown() {
        mpc seek -0.8% && notifySend
    }

    positionUp() {
        mpc seek +0.8% && notifySend
    }

    volumeDown() {
        mpc volume -10 && notifySend
    }

    volumeUp() {
        mpc volume +10 && notifySend
    }

    case $VAR2 in
        toggleMpd)
            toggleMpd
            ;;
        toggleNcmpcpp)
            toggleNcmpcpp
            ;;
        prev)
            prev
            ;;
        toggle)
            toggle
            ;;
        next)
            next
            ;;
        positionDown)
            positionDown
            ;;
        positionUp)
            positionUp
            ;;
        volumeDown)
            volumeDown
            ;;
        volumeUp)
            volumeUp
            ;;
    esac
}


###  STREAM ----------------------------------------------------

MediaAudioStream (){
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
###  VIDEO ----------------------------------------------------
### -----------------------------------------------------------

###  LOCAL ----------------------------------------------------

MediaVideoLocal() {
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

videoPlayer() {
    mpvRun="$(pgrep -c mpv)"
    mpvList="$(find ~/.config/mpv/playlists/*.m3u | tail -1)"
    mpvCount="$(find ~/.config/mpv/playlists/*.m3u | tail -1 | wc -l)"
    AUDIOVISUALDIR="Put your video dir here"

    notifySend() {
        CURRENTPLAYER=$(playerctl --player=mpv metadata --format "{{uc(playerName)}}: {{status}}")
        POSITIONPLAYER=$(playerctl --player=mpv metadata --format "{{duration(position) }}/{{ duration(mpris:length)}}")
        VOLUMEPLAYER=$(playerctl --player=mpv metadata --format "Volume: {{ volume * 100 }}%")
        TITLEPLAYER=$(playerctl --player=mpv metadata --format "{{ trunc(title, 20) }}") # mejorar con carrusel

        dunstify -i video-player -r 2594 -u normal \
            "$CURRENTPLAYER" \
            "$VOLUMEPLAYER\n$POSITIONPLAYER\n$TITLEPLAYER"
    }

    playList() {
        if [ "$mpvRun" -eq 0 ]; then
            if [ "$mpvCount" -eq 1 ]; then
                mpv --speed=2 --audio-pitch-correction "$mpvList"
            else
                mpv --speed=2 --audio-pitch-correction \
                    --shuffle "$AUDIOVISUALDIR"
            fi
        else
            killall -9 mpv
        fi
    }

    prev() {
        playerctl --player=mpv previous
        notifySend
    }

    toggle() {
        playerctl --player=mpv play-pause
        notifySend
    }

    next() {
        playerctl --player=mpv next
        notifySend
    }

    positionDown() {
        playerctl --player=mpv position 10-
        notifySend
    }

    positionUp() {
        playerctl --player=mpv position 10+
        notifySend
    }

    volumeDown() {
        playerctl --player=mpv volume 0.10-
        notifySend
    }

    volumeUp() {
        playerctl --player=mpv volume 0.10+
        notifySend
    }

    case $VAR2 in
        playList)
            playList
            ;;
        prev)
            prev
            ;;
        toggle)
            toggle
            ;;
        next)
            next
            ;;
        positionDown)
            positionDown
            ;;
        positionUp)
            positionUp
            ;;
        volumeDown)
            volumeDown
            ;;
        volumeUp)
            volumeUp
            ;;
    esac
}

###  STREAM ----------------------------------------------------

MediaVideoStream() {
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

ytdlp() {
    fileAudio() {
        yt-dlp --write-subs --write-auto-subs -f ba --extract-audio --audio-format opus --batch-file="$VAR3"
    }

    linkAudio() {
        yt-dlp --write-subs --write-auto-subs -f ba --extract-audio --audio-format opus "$VAR3"
    }

    fileVideo() {
        yt-dlp --write-subs --write-auto-subs -f "bv[height<=?1080]+ba/b" --batch-file="$VAR3"
    }

    linkVideo() {
        yt-dlp --write-subs --write-auto-subs -f "bv[height<=?1080]+ba/b" "$VAR3"
    }

    case $VAR2 in
        fileAudio)
            fileAudio
            ;;
        linkAudio)
            linkAudio
            ;;
        fileVideo)
            fileVideo
            ;;
        linkVideo)
            linkVideo
            ;;
    esac
}

rssVideo() {
    run(){
        mpv ~/.config/mpv/playlists/00newsboat.m3u
    }

    case $VAR2 in
        run)
            run
            ;;
    esac
}

### -----------------------------------------------------------
###  CODIGO ---------------------------------------------------
### -----------------------------------------------------------

###  LOCAL ----------------------------------------------------

MediaCodeLocal (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

terminalApps (){
    rssReader(){
        alacritty -e newsboat
    }

    case $VAR2 in
        rssReader)
            rssReader
            ;;
    esac
}

###  STREAM ----------------------------------------------------

MediaCodeStream (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

navPlayer() {
    mpvRun="$(pgrep -c firefox)"

    notifySend() {
        CURRENTPLAYER=$(playerctl --player=firefox metadata --format "{{uc(playerName)}}: {{status}}")
        POSITIONPLAYER=$(playerctl --player=firefox metadata --format "{{duration(position) }}/{{ duration(mpris:length)}}")
        VOLUMEPLAYER=$(playerctl --player=firefox metadata --format "Volume: {{ volume * 100 }}%")
        TITLEPLAYER=$(playerctl --player=firefox metadata --format "{{ trunc(title, 20) }}") # mejorar con carrusel

        dunstify -i video-player -r 2594 -u normal \
            "$CURRENTPLAYER" \
            "$VOLUMEPLAYER\n$POSITIONPLAYER\n$TITLEPLAYER"
    }

    toggleNav() {
        if [ "$mpvRun" -eq 0 ]; then
            dunstify -i firefox -r 2595 -u normal \
                "firefox run toggle no set for segurity run it with ctrl + f"
        else
            dunstify -i firefox -r 2595 -u normal \
                "firefox run toggle no set for segurity, close it with windows + BackSpace"
        fi
    }

    prev() {
        playerctl --player=firefox previous
        notifySend
    }

    toggle() {
        playerctl --player=firefox play-pause
        notifySend
    }

    next() {
        playerctl --player=firefox next
        notifySend
    }

    positionDown() {
        playerctl --player=firefox position 10-
        notifySend
    }

    positionUp() {
        playerctl --player=firefox position 10+
        notifySend
    }

    volumeDown() {
        playerctl --player=firefox volume 0.10-
        notifySend
    }

    volumeUp() {
        playerctl --player=firefox volume 0.10+
        notifySend
    }

    case $VAR2 in
        toggleNav)
            toggleNav
            ;;
        prev)
            prev
            ;;
        toggle)
            toggle
            ;;
        next)
            next
            ;;
        positionDown)
            positionDown
            ;;
        positionUp)
            positionUp
            ;;
        volumeDown)
            volumeDown
            ;;
        volumeUp)
            volumeUp
            ;;
    esac
}

### -----------------------------------------------------------
###  RUN ------------------------------------------------------
### -----------------------------------------------------------

$VAR1
