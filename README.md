# QMK - Keebio Iris V4

Here is my QMK setup for my Keebio Iris V4 keyboard.

It is a stock iris v4 keyboard and has been built with a rotary on the left and single key on the right.

This is my first proper mech keyboard and below are my notes on how to get setup and using QMK with the device.

## Using this config

To use this config along with QMK you need to create a linked dir.

Start by creating directory to work in.

    mkdir ~/keyboards
    cd ~/keyboards

Get the custom setup code:

    git clone https://github.com/bugthing/iris_v4

Get the QMK source and get it working (see below) ..you should end up with directory like so:

    find ~/keyboards
      ~/keyboards/iris_v4
      ~/keyboards/qmk_firmware

Create a link from within `qmk_firmware` to the custom setup

     ln -s ~/keyboards/iris_v4 ~/keyboards/qmk_firmware/keyboards/keebio/iris/keymaps/ben

Use compiling and flashing steps (see below) but essentially you should be able to do something like so:

     cd ~/keyboards/qmk_firmware
     make keebio/iris/rev4:ben
     make keebio/iris/rev4:ben:flash

## QMK

### Get it

Get the code from github

    git clone --recurse-submodules https://github.com/qmk/qmk_firmware.git

Grab some dependancies

    cd qmk_firmware
    util/qmk_install.sh

Apparently it needs python 3 .. I use asdf, so did this

    asdf local python 3.7.0

### Test it

See if the default will compile

    make keebio/iris/rev4:default

### Build my own config

Copy the default stuff to your own config

    cd ./util
    ./new_keymap.sh keebio/iris myown
    cd ..

Customise the copy  to your hearts content

    vim keyboards/keebio/iris/keymaps/myown/keymap.c

Compile it

    make keebio/iris/rev4:myown

### Flash the config

Place into DFU mode:

* pull out USB cable
* press and hold reset button (see underside of keyboards)
* plug in USB cable
* stop pressing button

Flash the files onto the hardware

    sudo make keebio/iris/rev4:myown:flash

### Use online tool

Go to: https://config.qmk.fm/#/keebio/iris/rev4/LAYOUT

Setup the layers as you want

Click the *COMPILE* button

Click the *KEYMAP ONLY* button to download a .zip

Within the zip there is a *keymap.c*, copy this file

    unzip keymap-keebio-iris-rev4-smart.zip
    mv smart/keymap.c qmk_firmware/keyboards/keebio/iris/keymaps/myown/

Compile and flash (see above)

### Encoder

read this for encoder https://docs.qmk.fm/#/feature_encoders

### Docker

To help build and flash the keyboard there is a Dockefile

    docker build -t qmkflasher .
    docker run -it --rm --volume `pwd`:/qmk/iris_v4 qmkflasher make keebio/iris/rev4:ben:flash

## SELinux

When using Fedora I had to allow containers to control devices using:

      sudo setsebool -P container_use_devices=true

