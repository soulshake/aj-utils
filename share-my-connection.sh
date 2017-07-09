#!/bin/sh
SUBNET=10.4.2.254/24
DHCP_A=10.4.2.101
DHCP_Z=10.4.2.199
sudo iptables -t nat -A POSTROUTING -s $SUBNET ! -d $SUBNET -j MASQUERADE
sudo ifconfig eth0 $SUBNET
sudo dnsmasq --no-daemon --interface=eth0 --dhcp-range=$DHCP_A,$DHCP_Z,1h
