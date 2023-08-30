#!/bin/bash
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
##while getopts ":hn:" option; do
##   case $option in
##      h) # display Help
##         Help
##         exit;;
##      n) # Enter a name
##         Name=$OPTARG;;
##     \?) # Invalid option
##         echo "Error: Invalid option"
##         exit;;
##   esac
##done
##
##echo "hello $Name!"

############################################################
############################################################
# Main program                                             #
############################################################
############################################################
#
############################################################
# Vars                                                     #
############################################################
#
VAR1=$1
VAR2=$2
VAR3=$3
VAR4=$4
VAR5=$5
#VAR6=$6
#VAR7=$7
#VAR8=$8
#VAR9=$9
#
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

UserCodigo (){
    FuncionGenerica (){
        echo User
    }

    case $VAR2 in
        FuncionGenerica)
            FuncionGenerica
            ;;
    esac
}

w3m (){
    alacritty -e w3m -F duckduckgo.com
}

ffmpeg (){
    FuncionGenerica (){
        echo "InWork"
    }

    case $VAR2 in
        VideoHigh)
            FuncionGenerica
            ;;
        VideoNormal)
            FuncionGenerica
            ;;
        VideoLow)
            FuncionGenerica
            ;;
    esac
}

qemu (){
    # https://wiki.archlinux.org/title/QEMU#Creating_new_virtualized_system

    # ----------------------------
    #  VARs
    # ----------------------------

    # VARS FOR UEFI
    uefiDir="Put Your uefi dir here"
    uefiImage="uefix64$imageName"
    uefiFind="$(find "$uefiDir" -name "$uefiImage" | wc -l)"
    uefiReadOnly="$uefiDir$uefiImage/uefix64ReadOnly/OVMF_CODE.fd"
    uefiWritable="$uefiDir$uefiImage/uefix64Writable/OVMF_VARS.fd"

    # VARS FOR THE MACHINES
    imageName="$VAR3"
    imageCdrom="$VAR4"
    spaceInDisk="$VAR5"

    # ----------------------------
    #   FNs
    # ----------------------------

    createImage() {
        # Create img
        qemu-img create -f qcow2 "$imageName" "$spaceInDisk"
    }

    runUefi() {
        if [ "$uefiFind" -eq 0 ]
        then
            mkdir "$uefiDir$uefiImage"
            cp -r "$uefiDir"uefix64Template "$uefiDir$uefiImage/uefix64ReadOnly"
            cp -r "$uefiDir"uefix64Template "$uefiDir$uefiImage/uefix64Writable"
        fi
    }

    runVirtiofsd() {
        sudo /usr/lib/virtiofsd \
            --socket-path=/var/run/qemu-vm-001.sock \
            -o source=~/.Scripts \
            -o cache=none &>/dev/null &
        sudo chgrp kvm /var/run/qemu-vm-001.sock;
        sudo chmod 777 /var/run/qemu-vm-001.sock
    }

    # FN's for type machines
        # run uefi
        #
        #
        # run socket virtiofsd
        # use this in the virtual machine:
        # mount -t virtiofs myfs /mnt
        #
        #
        # run a virtual machine
        # -rtc sync the virtual clock with the host clock
        # *pflash* is the uefi config
        # -object + -numa + -chardev + *vhost-user* is the virtiofsd conexion
        #
        # -M q35 for a multiple pci support
        # -cpu host, host take the data of the cpu host
        # -display sdl* is the window for render the machine
        # -device virtio-vga*, set the driver video for the machine
        #   virtio-vga and gl=off, is not gl acceleration
        #   virtio-vga-gl and gl=on, is gl acceleration
        #   gl acceleration can make problems for some desktops like xfce
        #   virtual windows need install virtio drivers
        #   virtual linux have virtio driver in the core
        # -device intel-hda* is the device for output audio
        # -drive + -device nvme* is the nvme disk
        # usb-tablet is no capture mouse
        # -drive *liveusb* + *usb-storage* + *memory-backend* is a usblive

    x86_64_Install() {
        # run uefi
        runUefi
        # run socket virtiofsd
        runVirtiofsd
        # run a virtual machine
        qemu-system-x86_64 -enable-kvm -machine q35 -rtc base=localtime \
            -cpu host -smp 4 -m 4G \
            -drive if=pflash,format=raw,readonly=on,file="$uefiReadOnly" \
            -drive if=pflash,format=raw,file="$uefiWritable" \
            -boot menu=on \
            -drive file="$imageName",if=none,index=0,id=NVME1,cache=unsafe,if=virtio \
            -device nvme,drive=NVME1,serial=nvme-1 \
            -nic user,model=virtio-net-pci \
            -display sdl,gl=off,grab-mod=rctrl \
            -device virtio-vga,edid=on,xres=1270,yres=720 \
            -device ich9-intel-hda -device hda-duplex,audiodev=snd0 \
            -usb -device usb-tablet \
            -drive if=none,id=liveusb,format=raw,file="$imageCdrom",if=virtio \
            -usb -device usb-ehci,id=liveusbehci -device usb-tablet,bus=usb-bus.0 \
            -device usb-storage,bus=liveusbehci.0,drive=liveusb \
            -object memory-backend-memfd,id=mem,size=4G,share=on \
            -numa node,memdev=mem \
            -chardev socket,id=char0,path=/var/run/qemu-vm-001.sock \
            -device vhost-user-fs-pci,chardev=char0,tag=myfs
            # in the guest, mount myfs /myfs
            # mount -o loop,offset=32256 disk_image mountpoint
            # -audiodev pa,id=snd0
            #-device intel-hda -device hda-duplex \
    }

    x86_64() {
        # run uefi
        runUefi
        # run socket virtiofsd
        runVirtiofsd
        # run a virtual machine
        qemu-system-x86_64 -enable-kvm -machine q35 -rtc base=localtime \
            -cpu host -smp 4 -m 4G \
            -drive if=pflash,format=raw,readonly=on,file="$uefiReadOnly" \
            -drive if=pflash,format=raw,file="$uefiWritable" \
            -boot menu=on \
            -drive file="$imageName",if=none,index=0,id=NVME1,cache=unsafe,if=virtio \
            -device nvme,drive=NVME1,serial=nvme-1 \
            -nic user,model=virtio-net-pci \
            -display sdl,gl=off,grab-mod=rctrl \
            -device virtio-vga,edid=on,xres=1270,yres=720 \
            -device ich9-intel-hda -device hda-duplex,audiodev=snd0 \
            -usb -device usb-tablet \
            -object memory-backend-memfd,id=mem,size=4G,share=on \
            -numa node,memdev=mem \
            -chardev socket,id=char0,path=/var/run/qemu-vm-001.sock \
            -device vhost-user-fs-pci,chardev=char0,tag=myfs
            # in the guest, mount myfs /myfs
            # mount -o loop,offset=32256 disk_image mountpoint
            # -audiodev pa,id=snd0
            #-device intel-hda -device hda-duplex \
    }

    x86_64_GL() {
        # run uefi
        runUefi
        # run socket virtiofsd
        runVirtiofsd
        # run a virtual machine
        qemu-system-x86_64 -enable-kvm -machine q35 -rtc base=localtime \
            -cpu host -smp 4 -m 4G \
            -drive if=pflash,format=raw,readonly=on,file="$uefiReadOnly" \
            -drive if=pflash,format=raw,file="$uefiWritable" \
            -boot menu=on \
            -drive file="$imageName",if=none,index=0,id=NVME1,cache=unsafe,if=virtio \
            -device nvme,drive=NVME1,serial=nvme-1 \
            -nic user,model=virtio-net-pci \
            -display sdl,gl=on,grab-mod=rctrl \
            -device virtio-vga-gl,edid=on,xres=1270,yres=720 \
            -device ich9-intel-hda -device hda-duplex,audiodev=snd0 \
            -usb -device usb-tablet \
            -object memory-backend-memfd,id=mem,size=4G,share=on \
            -numa node,memdev=mem \
            -chardev socket,id=char0,path=/var/run/qemu-vm-001.sock \
            -device vhost-user-fs-pci,chardev=char0,tag=myfs
            # set nic like none for w10
            # in the guest, mount myfs /myfs
            # mount -o loop,offset=32256 disk_image mountpoint
            # -audiodev pa,id=snd0
            #-device intel-hda -device hda-duplex \
    }

    arm() {
        qemu-system-aarch64 \
            -M virt \
            -m 1024 -smp 4 \
            -cpu cortex-a53 \
            -kernel vmlinuz \
            -initrd initrd.img \
            -drive file="",if=none,id=drive0,cache=none \
            -device virtio-blk,drive=drive0,bootindex=0 \
            -append 'root=/dev/vda2 noresume rw' \
            -no-rebbot \
            -nographic
    }

    # ----------------------------
    #   Calls
    # ----------------------------

    case $VAR2 in
        createImage)
            createImage
            ;;
        x86_64_Install)
            x86_64_Install
            ;;
        x86_64)
            x86_64
            ;;
        x86_64_GL)
            x86_64_GL
            ;;
        arm)
            arm
            ;;
    esac
}

### -----------------------------------------------------------
###  RUN ------------------------------------------------------
### -----------------------------------------------------------

$VAR1
