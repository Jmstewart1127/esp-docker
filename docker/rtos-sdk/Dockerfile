ARG ESP8266_RTOS_SDK_VERSION=v3.4
ARG XTENSA_LX106_RELEASE=-5.2.0
ARG XTENSA_ESP32_RELEASE=1.22.0-80-g6c4433a-5.2.0

FROM ubuntu:18.04 as distro
RUN apt-get update -y

FROM distro as toolchain
ARG XTENSA_LX106_RELEASE
ARG XTENSA_ESP32_RELEASE
ADD https://dl.espressif.com/dl/xtensa-lx106-elf-gcc8_4_0-esp-2020r3-linux-amd64.tar.gz /xtensa-lx106.tar.gz
ADD https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-${XTENSA_ESP32_RELEASE}.tar.gz /xtensa-esp32.tar.gz
RUN mkdir -p /tmp /toolchains \
    && apt-get install -y tar \
    && apt-get -y install cmake \
    && tar -xzf /xtensa-lx106.tar.gz -C /tmp/ \
    && tar -xzf /xtensa-esp32.tar.gz -C /tmp/ \
    && mv /tmp/xtensa-lx106-elf /toolchains/lx106 \
    && mv /tmp/xtensa-esp32-elf /toolchains/esp32

FROM distro as sdk
ARG ESP8266_RTOS_SDK_VERSION
RUN mkdir -p /sdk \
    && apt-get install -y git \
    && git clone --branch "$ESP8266_RTOS_SDK_VERSION" --single-branch https://github.com/espressif/ESP8266_RTOS_SDK.git /sdk \
    && cd /sdk \
    && git submodule update --init --recursive

FROM distro
RUN echo "export PATH=/usr/bin/gcc:/usr/bin/cmake:${PATH}" >> /root/.bashrc
ARG ESP8266_RTOS_SDK_VERSION
ARG XTENSA_LX106_RELEASE
ARG XTENSA_ESP32_RELEASE
ENV PATH /opt/toolchains/esp32/bin:/opt/toolchains/lx106/bin:$PATH
ENV IDF_PATH=/opt/sdk
COPY --from=toolchain /toolchains /opt/toolchains
COPY --from=sdk /sdk /opt/sdk
RUN apt-get update
RUN apt-get install -y \
        gcc \
        git \
        wget \
        make \
        libncurses-dev \
        flex \
        bison \
        gperf \
        python3-serial\
        python3-pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 \
    && pip install --user --upgrade pip \
    && pip install --user -r /opt/sdk/requirements.txt

LABEL ESP8266_RTOS_SDK_VERSION=$ESP8266_RTOS_SDK_VERSION \
      XTENSA_LX106_RELEASE=$XTENSA_LX106_RELEASE \
      XTENSA_ESP32_RELEASE=$XTENSA_ESP32_RELEASE
