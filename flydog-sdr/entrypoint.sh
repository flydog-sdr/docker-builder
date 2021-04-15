#!/bin/bash

# If /dev/gpiomem doesn't exist, create one
if [[ ! -f /sys/bus/i2c/devices/1-0054/eeprom ]];then
  ln -s /dev/mem /dev/gpiomem
fi

# Enable I2C EEPROM
if [[ ! -f /sys/bus/i2c/devices/1-0054/eeprom ]];then
  echo "24c32 0x54" > /sys/class/i2c-adapter/i2c-1/new_device
fi

# Start fan
/usr/bin/gpio mode 26 pwm
/usr/bin/gpio pwm 26 1024

# Main process
/usr/local/bin/kiwid -debian 10 -use_spidev 1 -bg
