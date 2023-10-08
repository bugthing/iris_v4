FROM alpine/git AS git
RUN git clone --recurse-submodules https://github.com/qmk/qmk_firmware.git /qmk

FROM debian
RUN apt update \
    && apt -y upgrade \
    && apt -y install --no-install-recommends -y build-essential \
      sudo \
      unzip \
      wget \
      zip \
      gcc-avr \
      binutils-avr \
      avr-libc \
      dfu-programmer \
      dfu-util \
      gcc-arm-none-eabi \
      binutils-arm-none-eabi \
      libnewlib-arm-none-eabi \
      git \
      software-properties-common \
      avrdude \
    && rm -rf /var/lib/apt/lists/*

ENV keyboard=tada68
ENV keymap=default

WORKDIR /qmk
COPY --from=git /qmk /qmk

RUN rm /usr/lib/python3.*/EXTERNALLY-MANAGED \
    && util/qmk_install.sh \
    && pip install qmk

RUN git clone https://github.com/bugthing/iris_v4 \
    && ln -s /qmk/iris_v4 /qmk/keyboards/keebio/iris/keymaps/ben
