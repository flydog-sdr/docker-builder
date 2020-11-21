#!/bin/bash

# Bind IP Address of p.sdrotg.com
echo "1.0.0.1 p.sdrotg.com" >> /etc/hosts

# Check EEPROM to confirm device
if [ ! -f "/sys/bus/i2c/devices/1-0054/eeprom" ];then
    echo "24c32 0x54" > /sys/class/i2c-adapter/i2c-1/new_device
    if [ "$(/usr/bin/xxd /sys/bus/i2c/devices/1-0054/eeprom | grep -q -s "466c 7964 6f67" && echo true)" = "true" ] ; then
        echo -e "\033[32mFlyDog SDR is detected, will now start the main process.\033[0m"
    else
        echo -e "\033[31mFor compatibility reasons, if the device is not FlyDog SDR, the process will be exited with code 255.\033[0m"
        echo "0x54" > /sys/class/i2c-adapter/i2c-1/delete_device
        exit 255
    fi
else
    if [ "$(/usr/bin/xxd /sys/bus/i2c/devices/1-0054/eeprom | grep -q -s "466c 7964 6f67" && echo true)" = "true" ] ; then
        echo -e "\033[32mFlyDog SDR is detected, will now start the main process.\033[0m"
    else
        echo -e "\033[31mFor compatibility reasons, if the device is not FlyDog SDR, the process will be exited with code 255.\033[0m"
        echo "0x54" > /sys/class/i2c-adapter/i2c-1/delete_device
        exit 255
    fi
fi
echo "0x54" > /sys/class/i2c-adapter/i2c-1/delete_device

# Start fan
/usr/bin/gpio mode 26 pwm
/usr/bin/gpio pwm 26 1024

# Scaling CPU minial frequency
echo 1000000 > /sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq

# Start main process
/usr/local/bin/kiwid -debian 10 -use_spidev 1 -bg -raspsdr