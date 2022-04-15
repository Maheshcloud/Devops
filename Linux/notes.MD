To assign sudo privileges to a user in Debian and Ubuntu, you must add the user to the sudo group. To add the user to this group, enter the following command:
```sh
usermod -aG sudo USERNAME
```

Add a user in sudoers file
```sh
nano /etc/sudoers
sername  ALL=(ALL) NOPASSWD:ALL
```
