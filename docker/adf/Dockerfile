ARG IDF_VERSION=release/v4.4

FROM ubuntu:latest as distro
RUN apt-get update -y

# FROM distro as esp
# ARG IDF_VERSION
# RUN mkdir -p /esp \
#     && apt-get install -y git \
#     && git clone --branch "$IDF_VERSION" --single-branch https://github.com/espressif/esp-idf.git /esp \
#     && cd /esp \
#     && git submodule update --init --recursive

FROM distro as adf
RUN mkdir -p /adf \
    && apt-get install -y git \
    && git clone --recursive https://github.com/espressif/esp-adf.git /adf

FROM distro
ARG IDF_VERSION

ENV ADF_PATH=/opt/adf
ENV ADF_TOOLS_PATH=/op/adf/esp-idf/tools
ENV IDF_PATH=/opt/adf/esp-idf
ENV IDF_TOOLS_PATH=/op/adf/esp-idf/tools

# COPY --from=esp /esp /opt/esp
COPY --from=adf /adf /opt/adf
RUN echo "export PATH=/usr/bin/gcc:/usr/bin/cmake:/opt/esp:/opt/esp/tools:/root/.local/bin:${PATH}" >> /root/.bashrc

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
RUN apt-get update
RUN apt-get install -y \
  gcc \
  make \
  git \
  wget \ 
  flex \
  bison \
  gperf \
  python3 \
  python3-venv \
  cmake \
  ninja-build \
  ccache \
  libffi-dev \
  libssl-dev \
  dfu-util \
  libusb-1.0-0 \
  tzdata \
  python3-serial \
  python3-pip \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
    && update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10 \
    && pip install --user --upgrade pip \
    && pip install --user -r /opt/adf/esp-idf/requirements.txt

RUN cd /opt/adf/esp-idf \
    && ./install.sh

COPY entrypoint.sh /opt/adf/entrypoint.sh

ENTRYPOINT [ "/opt/adf/entrypoint.sh" ]
CMD [ "/bin/bash" ]

LABEL IDF_VERSION=$IDF_VERSION
