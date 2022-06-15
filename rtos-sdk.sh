#!/bin/bash

PROJECT_DIR="$PWD"

source $PROJECT_DIR/.env

case $1 in
    "bash")
        docker run -it esp-rtos-sdk /bin/bash
        ;;
    "build")
        docker build . -t esp-rtos-sdk
        ;;
    "make")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project esp-rtos-sdk make
        ;;
    "flash")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project esp-rtos-sdk make flash
        ;;
    "monitor")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project esp-rtos-sdk make monitor
        ;;
    "monitorv")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project esp-rtos-sdk /opt/sdk/tools/idf.py monitor
        ;;
    "menuconfig")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project esp-rtos-sdk make menuconfig
        ;;
    "addr2line")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project esp-rtos-sdk /opt/toolchains/lx106/bin/xtensa-lx106-elf-addr2line -pfiaC -e /project/$ELF_PATH $2 $3 $4
        ;;
    "mfm")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project esp-rtos-sdk make\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project esp-rtos-sdk make flash\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project esp-rtos-sdk make monitor
        ;;
esac
