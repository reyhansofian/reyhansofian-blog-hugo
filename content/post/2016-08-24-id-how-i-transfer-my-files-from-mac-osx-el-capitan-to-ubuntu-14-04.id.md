---
title: "Bagaimana Transfer File dari OSX El Capitan ke Ubuntu 14.04"
thumbnailImage: https://pacs.ou.edu/filer/sharing/1495831525/1027/
coverImage: https://networkencyclopedia.com/wp-content/uploads/2019/08/ftam-file-transfer-access-management.jpg
coverCaption: https://networkencyclopedia.com/file-transfer-access-and-management-ftam
metaAlignment: center
coverMeta: out
date: 2016-08-24T22:50:18+07:00
categories:
  - technology
tags:
  - tips
  - unix
description: "Memindahkan file-file dari OSX ke Ubuntu dengan menggunakan Wifi tanpa perlu menggunakan HDD eksternal ataupun flashdisk"
---

Hari ini aku berencana memindahkan semua file-file yang ada di Macbook Air kantorku (OSX El Capitan) ke laptop pribadiku (Ubuntu 14.04). Awalnya rencana memindahkan file-file tersebut ingin menggunakan HDD eksternal, tapi ternyata semua HDD eksternalku rusak. Jadi aku harus mencari cara lain supaya bisa memindahkan semua file tersebut. Akhirnya ide memindahkan dengan menggunakan network datang (dengan menggunakan Wifi).

<!--more-->

Jadi ceritanya begini:

# Prasyarat

- Kedua laptop (Macbook dan laptop Ubuntu) harus dalam network yang sama
- Cek IP network yang digunakan oleh laptop Ubuntu dengan cara

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

Jika kalian menggunakan Wifi, maka kamu bisa mencari di bagian `wlan0` dan lihat di sub-bagian `inet addr`. Di contoh ini alamat IP-nya adalah **192.168.1.68**

# Setup Ubuntu 14.04

- Di sini aku menggunakan Samba Server untuk share folder ke dalam network. Kalian bisa cek instalasi Samba Server kalian dengan menjalankan perintah

```shell
> which samba
/usr/sbin/samba
# ^^^ It will return like this if you already have samba installed
```

- Jika kalian belum memiliki Samba Server, kalian bisa install dengan menjalankan perintah `sudo apt-get install samba`
- Buat sebuah folder untuk menyimpan file-file yang akan ditransfer via Samba Server dengan menjalankan perintah

```shell
> sudo mkdir -p /media/hdd/backup # Path could be anything you want
> sudo chown nobody:nogroup /media/hdd/backup
```

- Sekarang mari kita sesuaikan sedikit konfigurasi Samba Servernya dengan menjalankan perintah `sudo vim /etc/samba/smb.conf` (jika kalian tidak terbiasa menggunakan Vim, kalian bisa menggunakan editor lain seperti Nano, Pico atau bahkan VSCode)
- Tambahkan konfigurasi berikut di bagian paling bawah file konfigurasi tersebut

```shell
[Ubuntu 14.04] # This is the network name that will show up on the network list
    comment = Ubuntu File Server Share
    path = /media/hdd/backup
    browsable = yes
    guest ok = yes
    read only = no
    create mask = 0755
```

> Opsi yang bisa digunakan untuk konfigurasi Samba Server: \
> \
> **comment:** a short description of the share. Adjust to fit your needs. \
> **path:** the path to the directory to share. Technically Samba shares can be placed anywhere on the filesystem as long as the permissions are correct, but adhering to standards is recommended. \
> **browsable:** enables Windows clients to browse the shared directory using Windows Explorer. \
> **guest ok:** allows clients to connect to the share without supplying a password. \
> **read only:** determines if the share is read only or if write privileges are granted. Write privileges are allowed only when the value is no, as is seen in this example. If the value is yes, then access to the share is read only. \
> **create mask:** determines the permissions new files will have when created. \
> \
> -<cite>From: https://help.ubuntu.com/lts/serverguide/samba-fileserver.html</cite>

&nbsp;

- Simpan, lalu restart Samba Servernya dengan menjalankan perintah

```shell
> sudo service samba restart
nmbd stop/waiting
nmbd start/running, process 22180
smbd stop/waiting
smbd start/running, process 22192
stop: Unknown instance:
samba-ad-dc start/running, process 22207
```

- Konfigurasi Samba Server sudah selesai. Sekarang kita pindah ke Macbook

---

# Setup Mac OSX (El Capitan)

- Bukan aplikasi **Finder**
- Cari menu **Go** -> **Connect to Server** atau bisa dengan menggunakan shortcut **Cmd + K** (nanti akan muncul sebuah popup)

{{< figure classes="fancybox center clear fig-100" src="https://miro.medium.com/max/984/1*rPk3Ez8gjIyO5uTW1H14Ow.png" >}}

- Masukkan alamat IP **smb://192.168.1.68** ke menu **Server Address**. Alamat IP-nya tergantung dari `ifconfig` kalian di Macbook ya. Caranya mirip dengan menggunakan di Ubuntu di atas. Setelah itu tekan tombol **Connect**.
- Sebuah popup akan muncul (lagi)

{{< figure classes="fancybox center clear fig-100" src="https://miro.medium.com/max/836/1*pVXiaBRWBPXWcD9B5sJQ_A.png" title="Volume Ubuntuk 14.04 berwarna abu-abu karena aku sudah memasangnya (mount)" >}}

- NOTE: Volume Ubuntuk 14.04 berwarna abu-abu karena aku sudah memasangnya (mount)
- Pilih volume yang diinginkan, lalu tekan tombol **OK**
- Volume pilihan kalian akan muncul di daftar **Devices**

{{< figure classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*J-QUtQBEylJLUSo9xBzU8Q.png" >}}

- Sekarang buka terminal kalian
- Kita akan menggunakan `rsync` untuk menyalin (copy) semua file yang ada di Macbok ke Ubuntu. Caranya dengan menjalankan perintah

```shell
> sudo rsync -vaE --progress --exclude='/dirs/you/dont/need' /Users/username/your/folder/to/copy/from /Volumes/Ubuntu\ 14.04
```

> Flag yang bisa digunakan di `rsync`: \
> \
> **v:** increases verbosity. \
> **a:** applies archive settings to mirror the source files exactly, including symbolic links and permissions. \
> **E:** copies extended attributes and resource forks (OS X only). \
> **progress:** provides a count down and transfer statistics during the copy. \
> **exclude:** exclude desired file / folder from copied \
> \
> -<cite>From: https://apple.stackexchange.com/questions/117465/fastest-and-safest-way-to-copy-massive-data-from-one-external-drive-to-another/117469#117469</cite>
