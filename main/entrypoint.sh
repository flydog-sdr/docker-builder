#!/bin/bash

# Start fan

gpio mode 26 pwm
gpio pwm 26 1024

# Main process
/usr/local/bin/kiwid -debian 10 -use_spidev 1 -bg -raspsdr
