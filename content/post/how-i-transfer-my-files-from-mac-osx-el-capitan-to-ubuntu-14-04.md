---
title: "How I Transfer My Files From Mac Osx El Capitan to Ubuntu 14 04"
thumbnailImagePosition: top
thumbnailImage: https://pacs.ou.edu/filer/sharing/1495831525/1027/
coverImage: https://networkencyclopedia.com/wp-content/uploads/2019/08/ftam-file-transfer-access-management.jpg
coverCaption: https://networkencyclopedia.com/file-transfer-access-and-management-ftam
metaAlignment: center
coverMeta: out
date: 2016-08-24T22:50:18+07:00
categories:
- development
tags:
- tips
- unix
description: "Transfer files from Macbook to Ubuntu using Wifi"
---

Today I want to transfer all of my data from my office’s MacBook Air (El-Capitan) to my laptop (Ubuntu 14.04). Since two of my external hard disk are broken, I need another way to transfer those files. And I come with transferring using the network (I have a wifi router at home).
<!--more-->

So this is how I set it up:

**Prerequisite:**

- Both your Macbook Air and laptop (Ubuntu) should be on same network, otherwise this method won’t work
- Please check your laptop’s (Ubuntu) IP on the network by run:

```shell
> ifconfig
docker0   Link encap:Ethernet  HWaddr 02:42:a7:c6:fe:9a
          inet addr:172.17.0.1  Bcast:0.0.0.0  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
eth0      Link encap:Ethernet  HWaddr 30:85:a9:25:79:2f
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:26183 errors:0 dropped:0 overruns:0 frame:0
          TX packets:26183 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:2772883 (2.7 MB)  TX bytes:2772883 (2.7 MB)
vboxnet4  Link encap:Ethernet  HWaddr 0a:00:27:00:00:04
          inet addr:192.168.99.1  Bcast:192.168.99.255  Mask:255.255.255.0
          inet6 addr: fe80::800:27ff:fe00:4/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1641 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:320617 (320.6 KB)
wlan0     Link encap:Ethernet  HWaddr dc:85:de:08:13:28
          inet addr:192.168.1.68  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::de85:deff:fe08:1328/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:2904324 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1565126 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1275931788 (1.2 GB)  TX bytes:518127433 (518.1 MB)
```

If you’re using a wifi network, you should find `wlan0` section and make a note on the `inet addr` section. In this case, my IP address is **192.168.1.68**

## Ubuntu 14.04 Setup

- I use Samba server for sharing folder on the network. Please check your samba installation by run:

```shell
> which samba
/usr/sbin/samba
# ^^^ It will return like this if you already have samba installed
```

- If you don’t have samba, you can run `sudo apt-get install samba` to install Samba to your system.
- Create a folder to store your files by run this on terminal:

```shell
> sudo mkdir -p /media/hdd/backup
> sudo chown nobody:nogroup /media/hdd/backup
```
- Now we need to set our Samba configuration which located in “/etc/samba/smb.conf”. Run “sudo vim /etc/samba/smb.conf” to edit Samba config file.
Add these codes at the bottom of the config file:

```shell
[Ubuntu 14.04] # This is the network's name that will show up on the network
    comment = Ubuntu File Server Share
    path = /media/hdd/backup
    browsable = yes
    guest ok = yes
    read only = no
    create mask = 0755
```

> **comment:** a short description of the share. Adjust to fit your needs. \
> **path:** the path to the directory to share. Technically Samba shares can be placed anywhere on the filesystem as long as the permissions are correct, but adhering to standards is recommended. \
> **browsable:** enables Windows clients to browse the shared directory using Windows Explorer. \
> **guest ok:** allows clients to connect to the share without supplying a password. \
> **read only:** determines if the share is read only or if write privileges are granted. Write privileges are allowed only when the value is no, as is seen in this example. If the value is yes, then access to the share is read only. \
> **create mask:** determines the permissions new files will have when created. \
> \
> -<cite>From: https://help.ubuntu.com/lts/serverguide/samba-fileserver.html</cite>

&nbsp;

- Now we need to restart our Samba server

```shell
> sudo service samba restart
nmbd stop/waiting
nmbd start/running, process 22180
smbd stop/waiting
smbd start/running, process 22192
stop: Unknown instance:
samba-ad-dc start/running, process 22207
```

- We’re done with our Samba server

---

## Mac OSX (El Capitan) Setup:

- Go to your Finder
- Find **Go** -> **Connect to Server** or by press **Cmd + K** and a popup will appear

{{< image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/984/1*rPk3Ez8gjIyO5uTW1H14Ow.png" >}}

- Enter **smb://192.168.1.68** on the Server Address bar. The IP address depends on your `ifconfig` results. Then press **Connect** button.
- A popup will appear (again)

{{< image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/836/1*pVXiaBRWBPXWcD9B5sJQ_A.png" title="The Ubuntu 14.04 volume is greyed out because I already mount it" >}}

- The Ubuntu 14.04 volume is greyed out because I already mount it
- Select the desired volume, and press **OK**
- Your selected volume will appear on the **Devices** list

{{< image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*J-QUtQBEylJLUSo9xBzU8Q.png" >}}

- Now open up your terminal
- We will use rsync to copy our files from MBA to Ubuntu

```shell
> sudo rsync -vaE --progress --exclude='/dirs/you/dont/need' /Users/username/your/folder/to/copy/from /Volumes/Ubuntu\ 14.04
```

>The flags are: \
> **v:** increases verbosity. \
> **a:** applies archive settings to mirror the source files exactly, including symbolic links and permissions. \
> **E:** copies extended attributes and resource forks (OS X only). \
> **progress:** provides a count down and transfer statistics during the copy. \
> **exclude:** exclude desired file / folder from copied \
> \
> -<cite>From: https://apple.stackexchange.com/questions/117465/fastest-and-safest-way-to-copy-massive-data-from-one-external-drive-to-another/117469#117469</cite>