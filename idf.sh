#!/usr/bin/env bash

PROJECT_DIR="$PWD"

source $PROJECT_DIR/.env

case $1 in
    "bash")
        docker run -it $IDF_CONTAINER_NAME /bin/bash
        ;;
    "build")
        docker build ./docker/idf -t $IDF_CONTAINER_NAME
        ;;
    "create")
        docker create --name $IDF_CONTAINER_NAME "$(docker images $IDF_CONTAINER_NAME --format "{{.ID}}")"
        ;;
    "idfpy")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $IDF_CONTAINER_NAME /opt/esp/tools/idf.py "${@:2}"
        ;;
    "examples")
        case $2 in
            "ls")
                docker run -it $IDF_CONTAINER_NAME ls /opt/esp/examples/"${@:3}"
                ;;
            "cp")
                docker cp $IDF_CONTAINER_NAME:/opt/esp/examples/"${@:3}" $PROJECT_DIR/"${@:4}"
                ;;
        esac
        ;;
    "make")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $IDF_CONTAINER_NAME make
        ;;
    "flash")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $IDF_CONTAINER_NAME make flash
        ;;
    "monitor")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $IDF_CONTAINER_NAME make monitor
        ;;
    "monitorv")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $IDF_CONTAINER_NAME /opt/eesp/tools/idf.py monitor
        ;;
    "menuconfig")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $IDF_CONTAINER_NAME make menuconfig
        ;;
    "addr2line")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $IDF_CONTAINER_NAME /opt/toolchains/lx106/bin/xtensa-lx106-elf-addr2line -pfiaC -e /project/$ELF_PATH $2 $3 $4
        ;;
    "mfm")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $IDF_CONTAINER_NAME make\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $IDF_CONTAINER_NAME make flash\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $IDF_CONTAINER_NAME make monitor
        ;;
esac