#!/bin/bash
#
######Vars##################################################
# Vars
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

############################################################
# Help                                                     #
############################################################
#
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

### -----------------------------------------------------------
###  TEXTO ----------------------------------------------------
### -----------------------------------------------------------

UserTexto (){
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


UserImagen (){
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

UserAudio (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

textToAudio (){
    archivo=$VAR3
    clearName=$( echo "$archivo" | rev | cut -c 5- | rev)

    español() {
        espeak -v es-419 -p 0 -s 400 -f "$archivo" -w "$clearName.wav"
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

### -----------------------------------------------------------
###  VIDEO ----------------------------------------------------
### -----------------------------------------------------------

UserVideo (){
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
###  CODIGO ---------------------------------------------------
### -----------------------------------------------------------

transmissionCli() {
    torrent=$VAR3

    startDaemon(){
        echo "$VAR2"
        transmission-daemon -ep -g ~/.config/transmission/
    }

    killDaemon(){
        echo "$VAR2"
        killall transmission-daemon
    }

    callDaemon(){
        while true; do
        clear
        transmission-remote -l
        sleep 4
        done
    }

    addFile(){
        echo "$VAR2"
        transmission-remote -a "$torrent"
    }

    startFile(){
        echo "$VAR2"
        transmission-remote -t "$torrent" --start
    }

    startAll(){
        echo "$VAR2"
        transmission-remote -t all --start
    }

    stopFile(){
        echo "$VAR2"
        transmission-remote -t "$torrent" --stop
    }

    stopAll(){
        echo "$VAR2"
        transmission-remote -t all --stop
    }

    removeFile(){
        echo "$VAR2"
        transmission-remote -t "$torrent" --remove
    }

    removeAll(){
        echo "$VAR2"
        transmission-remote -t all --remove
    }

    deleteFile(){
        echo "$VAR2"
        transmission-remote -t "$torrent" --remove-and-delete
    }

    deleteAll(){
        echo "$VAR2"
        transmission-remote -t all --remove-delete
    }

    #showFile(){
    #    transmission-show: returns information on a given torrent file.
    #}
    #
    #createFile(){
    #    transmission-create: creates a new torrent.
    #}
    #
    #editFile(){
    #    transmission-edit: add, delete, or replace a tracker's announce URL.
    #}

    case $VAR2 in
        startDaemon)
            startDaemon
            ;;
        killDaemon)
            killDaemon
            ;;
        callDaemon)
            callDaemon
            ;;
        addFile)
            addFile
            ;;
        startFile)
            startFile
            ;;
        startAll)
            startAll
            ;;
        stoptFile)
            stopFile
            ;;
        stoptAll)
            stopAll
            ;;
        removeFile)
            removeFile
            ;;
        removeAll)
            removeAll
            ;;
        deleteFile)
            deleteFile
            ;;
        deleteAll)
            deleteAll
            ;;
    esac
}

#xclip -sel clip $FILENAME

### -----------------------------------------------------------
###  RUN ------------------------------------------------------
### -----------------------------------------------------------

$VAR1
