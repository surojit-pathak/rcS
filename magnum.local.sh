#!/bin/sh
sudo iptables -t nat -A POSTROUTING -o `ROUTE=\`ip route get 8.8.8.8\`; DEVICE=${ROUTE#*dev}; echo $DEVICE | awk '{print $1}'` -j MASQUERADE
