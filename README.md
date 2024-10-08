There was an issue with starting NAS. Changing the power supply helped.
# Installing cerbot Synology DS212j
## Install opkg
```bash
 wget -O - https://pkg.entware.net/binaries/armv5/installer/entware_install.sh | /bin/sh
```

Add to path according to the instructions  from installer.
Install using opkg gcc.
## Install pip3
``` 
python3 -m pip install --upgrade pip
``` 
It failes -> installed using acme.sh. Still don't know where the certificate for application is stored.


After enabling NFS for home directory logging with keys was impossible -> changed location of authorized_keys helped. In path of ssh %u is user name.

