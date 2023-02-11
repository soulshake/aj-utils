#!/bin/sh

if grep -q "Lenovo ThinkPad WS Dock" /sys/bus/usb/devices/*/product; then
    LEFT_OUTPUT=DP-0.2
    CENTER_OUTPUT=DP-3
    RIGHT_OUTPUT=DP-0.1
else
    LEFT_OUTPUT=DP-4   # HDMI port on the back
    CENTER_OUTPUT=DP-5 # Thunderbolt port on the back
    RIGHT_OUTPUT=DP-0  # miniDP port on the right
fi

LEFT="$LEFT_OUTPUT: nvidia-auto-select +0+0 {Rotation=Left}"
CENTER="$CENTER_OUTPUT: nvidia-auto-select +1080+0"
RIGHT="$RIGHT_OUTPUT: nvidia-auto-select +4920+0 {Rotation=Right}"

#LCD="DPY-4: nvidia-auto-select @1920x1080 +0+1080 {Transform=(0.500000,0.000000,0.000000,0.000000,0.500000,0.000000,0.000000,0.000000,1.000000), ViewPortIn=1920x1080, ViewPortOut=3840x2160+0+0, ResamplingMethod=Bilinear}"
#LCD="DPY-2: nvidia-auto-select @2560x1440 +0+0 {Transform=(0.666667,0.000000,0.000000,0.000000,0.666667,0.000000,0.000000,0.000000,1.000000), ViewPortIn=2560x1440, ViewPortOut=3840x2160+0+0, ResamplingMethod=Bilinear}"
#LCD="DFP-2: nvidia-auto-select @1920x1080 +0+1080 {Transform=(0.500000,0.000000,0.000000,0.000000,0.500000,0.000000,0.000000,0.000000,1.000000), ViewPortIn=1920x1080, ViewPortOut=3840x2160+0+0, ResamplingMethod=Bilinear}"
#RIGHT="DFP-0.1.1: nvidia-auto-select @1920x1080 +1920+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0}"
#TOP="DFP-0.2.1: nvidia-auto-select @1920x1080 +0+0 {ViewPortIn=1920x1080, ViewPortOut=1920x1080+0+0}"
#RIGHT="DPY-6: 1280x720 @1280x720 +1920+0 {ViewPortIn=1280x720, ViewPortOut=1280x720_+0+0}"

nvidia-settings --assign CurrentMetaMode="$LEFT, $CENTER, $RIGHT"
