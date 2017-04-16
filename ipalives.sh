#!/bin/bash

echo ""
echo ".45 ubuntu usr:ubualien install:ansible"
echo ".39 Centos usr:msoranno install:docker,kubernetes"
echo

for ip in 192.168.1.{1..254}; do
  ping -c 1 -W 1 $ip | grep "64 bytes" &
done
