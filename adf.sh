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
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME /opt/adf/esp-idf/tools/idf.py "${@:2}"
        ;;
    "examples")
        case $2 in
            "ls")
                docker run -it $ADF_CONTAINER_NAME ls /opt/adf/examples/"${@:3}"
                ;;
            "cp")
                docker cp $ADF_CONTAINER_NAME:/opt/adf/examples/"$3" $PROJECT_DIR/"$4"
                ;;
        esac
        ;;
    "make")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME make
        ;;
    "flash")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make flash
        ;;
    "erase")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make erase_flash
        ;;
    "monitor")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make monitor
        ;;
    "monitorv")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME /opt/adf/esp-idf/tools/idf.py monitor
        ;;
    "menuconfig")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make menuconfig
        ;;
    "addr2line")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME /opt/toolchains/lx106/bin/xtensa-lx106-elf-addr2line -pfiaC -e /project/$ELF_PATH $2 $3 $4
        ;;
    "mfm")
        docker run -it --rm -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME make\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make flash\
        && docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project --privileged -v /dev:/dev -w /project $ADF_CONTAINER_NAME make monitor
        ;;
    "flashaudio")
        docker run -it --rm --device=$DEVICE:/dev/ttyUSB0 -v $PROJECT_DIR:/project -w /project $ADF_CONTAINER_NAME python /opt/adf/esp-idf/components/esptool_py/esptool/esptool.py --chip esp32 --port /dev/ttyUSB0 --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x110000 /project/components/pipeline_flash_tone/tools/audio-esp.bin
        ;;
esac
