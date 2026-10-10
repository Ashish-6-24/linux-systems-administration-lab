#!/bin/bash

echo "---SYSTEM--"
whoami 
hostname 
uptime 

echo "----PROCESSES----"
ps aux --sort=%cpu | head -n 10 

echo "----MEMORY---"
free -h 

echo "----DISK---"
df -h /

echo "---NETWORK---"
ip addr 
ip route 

echo "---SSH SERVICE---"
systemctl is-active ssh 

echo "---FIREWALL---"
sudo ufw status numbered
