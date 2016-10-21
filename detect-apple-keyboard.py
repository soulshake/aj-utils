#!/usr/bin/env python

import functools
import os.path
import pyudev
import subprocess

def main():
    BASE_PATH = os.path.abspath(os.path.dirname(__file__))
    path = functools.partial(os.path.join, BASE_PATH)
    call = lambda x, *args: subprocess.call([path(x)] + list(args))

    context = pyudev.Context()
    monitor = pyudev.Monitor.from_netlink(context)
    monitor.filter_by(subsystem='usb')  # Remove this line to listen for all devices.
    monitor.start()

    for device in iter(monitor.poll, None):
        if 'apple' in device.get('ID_VENDOR', '').lower():
            #import ipdb; ipdb.set_trace()
            if device['ACTION'] == 'remove':
                print("Unplugged apple device! {}".format(device))
                os.system("echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd")
                subprocess.call(["cat", "/sys/module/hid_apple/parameters/swap_opt_cmd"])
                #echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd
            else:
                #if device['ACTION'] == 'remove':
                print("Found a new apple device! {}".format(device))
                os.system("echo 0 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd")
                subprocess.call(["cat", "/sys/module/hid_apple/parameters/swap_opt_cmd"])

        # I can add more logic here, to run only certain kinds of devices are plugged.
        #call('foobar.sh')


if __name__ == '__main__':
    main()
