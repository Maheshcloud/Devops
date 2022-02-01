See all running processes:
''
ps -aux
ps -U user_name
''sh

To check the ports listening:

netstat -plunt
You can also use lsof command to find open ports or for finding which process is using a port
lsof -i

Disk Space: 
df -h

To check the memory:
free -m

logs:
/var/log
tail -f /var/log/messages

This displays all the kernel messages:
dmesg 
dmesg | more 
Want to see what's happening as it happens? 
dmesg | tail -f /var/log/syslog

 sudo find /var/log -type f -mtime -1 -exec tail -Fn0 {} +
This sweeps through the logs and shows possible problems.

You can obtain detailed information on the hardware using ls commands such as lspci, lsblk, lscpu, and lsscsi

Useful commands to figure out networking functions in the Linux server include ip addr, traceroute, nslookup, dig, and ping, among others

ip addr show
nslookup ip/address

dig command stands for Domain Information Groper. It is used for retrieving information about DNS name servers.
dig google.com


Getting ram information:

cat /proc/meminfo
or if you want to get just the amount of ram you can do:
cat /proc/meminfo | head -n 1


Getting cpu info:
 cat /proc/cpuinfo

See what hard drives are currently detected
sudo fdisk -l

Installed Programs:
Find all installed packages:
dpkg --get-selections | less

Keep an eye on something for awhile
watch ls
watch df -h
