#!/usr/bin/env python
# coding=UTF-8

# Based on:
# http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/#my-right-prompt-battery-capacity
# https://gist.github.com/ascarter/1181082

import argparse
import math
import subprocess
import sys

def main(argv):
    parser = argparse.ArgumentParser(description = 'Display current battery capacity')
    parser.add_argument('-c', '--color', action = 'store_true')
    parser.add_argument('-s', '--slots', default = 10)
    args = parser.parse_args()

    # p      = subprocess.Popen(['ioreg', '-rc', 'AppleSmartBattery'], stdout = subprocess.PIPE)
    p = subprocess.Popen(['upower', '-i', '/org/freedesktop/UPower/devices/battery_BAT0'], stdout = subprocess.PIPE)
    output = p.communicate()[0]

    total_slots = int(args.slots)

    #o_max = [l for l in output.splitlines() if 'MaxCapacity' in l][0]
    o_max = [l for l in output.splitlines() if 'capacity' in l][0]
    o_cur = [l for l in output.splitlines() if 'capacity' in l][0]

    #b_max = float(o_max.rpartition('=')[-1].strip())
    b_max = 94.6983
    b_cur = 21.6983
    #b_cur = float(o_cur.rpartition('=')[-1].strip())

    charge           = b_cur / b_max
    charge_threshold = int(math.ceil(float(total_slots) * charge))

    # Output

    filled = int(math.ceil(charge_threshold * (float(total_slots) / 8.0))) * u'✿'
    empty  = (total_slots - len(filled)) * u'❀'
    output = (filled + empty).encode('utf-8')

    medium_threshold = int(math.floor(float(total_slots) * 0.6))
    low_threshold    = int(math.floor(float(total_slots) * 0.4))

    if args.color is True:
        color_green = '\x1b[32m'
        color_yellow = '\x1b[33m'
        color_red    = '\x1b[31m'
        color_reset  = '\x1b[39;49m'
        color_output = (
            color_green if len(filled) > medium_threshold else
            color_yellow if len(filled) > low_threshold else
            color_red
        )
        output = color_output + output + color_reset

    sys.stdout.write(output)

if __name__ == '__main__':
    main(sys.argv[1:])
