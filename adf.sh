#!/usr/bin/env bash

PROJECT_DIR="$PWD"

source $PROJECT_DIR/.env

function create_container() {
    docker create --name $ADF_CONTAINER_NAME "$(docker images $ADF_CONTAINER_NAME --format "{{.ID}}")"
}

case $1 in
    "bash")
        docker run -it $ADF_CONTAINER_NAME /bin/bash
        ;;
    "build")
        docker build ./docker/adf -t $ADF_CONTAINER_NAME
        create_container
        ;;
    "create")
        create_container
        ;;
    "idfpy")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project/play_mp3_control $ADF_CONTAINER_NAME /opt/esp/tools/idf.py "${@:2}"
        ;;
    "examples")
        case $2 in
            "ls")
                docker run -it $ADF_CONTAINER_NAME ls /opt/adf/examples/"${@:3}"
                ;;
            "cp")
                docker cp $ADF_CONTAINER_NAME:/opt/adf/examples/"${@:3}" $PROJECT_DIR/"${@:4}"
                ;;
        esac
        ;;
    "make")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME make
        ;;
    "flash")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project/play_mp3_control $ADF_CONTAINER_NAME make flash
        ;;
    "monitor")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make monitor
        ;;
    "monitorv")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME /opt/esp/tools/idf.py monitor
        ;;
    "menuconfig")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project/play_mp3_control $ADF_CONTAINER_NAME /opt/esp/tools/idf.py menuconfig
        ;;
    "addr2line")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME /opt/toolchains/lx106/bin/xtensa-lx106-elf-addr2line -pfiaC -e /project/$ELF_PATH $2 $3 $4
        ;;
    "mfm")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME make\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make flash\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make monitor
        ;;
esac