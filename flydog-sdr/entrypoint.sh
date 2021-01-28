#!/bin/bash

# Bind IP Address of p.sdrotg.com
echo "1.0.0.1 p.sdrotg.com" >> /etc/hosts

# If /dev/gpiomem doesn't exist, create one
if [[ ! -f /sys/bus/i2c/devices/1-0054/eeprom ]];then
  ln -s /dev/mem /dev/gpiomem
fi

# Check EEPROM to confirm device
if [[ ! -f /sys/bus/i2c/devices/1-0054/eeprom ]];then
  echo "24c32 0x54" > /sys/class/i2c-adapter/i2c-1/new_device
fi
xxd /sys/bus/i2c/devices/1-0054/eeprom | grep -q -s "466c 7964 6f67"
if [[ $? -ne 0 ]]; then
  echo -e "\033[31mFor compatibility reasons, if the device is not FlyDog SDR, the process will be exited with code 255.\033[0m"
  exit 255
fi

# Start fan
/usr/bin/gpio mode 26 pwm
/usr/bin/gpio pwm 26 1024

# Start main process
/usr/local/bin/kiwid -debian 10 -use_spidev 1 -bg -fdsdr
