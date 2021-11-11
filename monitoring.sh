#!/bin/bash
architecture = $(uname -a) 
kernel = $(uname -r)
phys_processors = $(grep "physical id" /proc/cpuinfo | sort -u | wc -l)
virtual_processors = $(grep "^processor" /proc/cpuinfo | wc -l)
memory_used = $(free -m | awk '$1 == "Mem:" {print $3}')
memory_max = $(free -m | awk '$1 == "Mem:" {print $2}')
memory_usage_percentage = $(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
disk_used = $(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
disk_max = $(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $2} END {print ut}')
disk_usage_percentage = $(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpu_load = $(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
last_boot = $(who -b | awk '$1 == "system" {print $3 " " $4}')
lvm_check = $(lsblk | grep "lvm" | wc -l)
lvm_use_result = $(if [ $lvm_check -eq 0 ]; then echo no; else echo yes; fi)
connexions_tcp = $(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
user_log = $(users | wc -w)
ip = $(hostname -I)
mac_adress = $(ip link show | awk '$1 == "link/ether" {print $2}')
sudo_uage = $(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall -n "#Architecture: $architecture $kernel
		#CPU physical: $phys_processors
		#vCPU: $virtual_processors
		#Memory Usage: $memory_used/${memory_max}MB ($memory_usage_percentage%)
		#Disk Usage: $disk_used/${disk_max}Gb ($disk_usage_percentage%)
		#CPU load: $cpu_load
		#Last boot: $last_boot
		#LVM use: $lvm_use_result
		#Connexions TCP: $connexions_tcp ESTABLISHED
		#User log: $user_log
		#Network: IP $ip ($mac_adress)
		#Sudo: $sudo_uage cmd" 