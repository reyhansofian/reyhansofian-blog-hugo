---
title: "Live-reload dengan Gin untuk Develop Aplikasi Golang"
thumbnailImagePosition: top
thumbnailImage: https://i.imgur.com/UjsWOzU.gif
coverImage: https://stackify.com/wp-content/uploads/2018/09/Learn-Go_-Tutorials-for-Beginners-Intermediate-and-Advanced-programmers-1280x720.jpg
coverCaption: https://stackify.com/wp-content/uploads/2018/09/Learn-Go_-Tutorials-for-Beginners-Intermediate-and-Advanced-programmers-1280x720.jpg
metaAlignment: center
coverMeta: out
date: 2020-05-09T08:24:28+07:00
categories:
  - programming
tags:
  - golang
  - gin
  - tools
description: "Live-reload dengan menggunakan Gin setiap kali menyimpan berkas pada saat develop aplikasi dengan Golang."
---

Berawal dari dunia per-NodeJS-an, aku selalu menggunakan Nodemon untuk develop aplikasi dengan NodeJS. Singkat cerita, di ak mendapatkan projek yang menggunakan Golang sebagai pengganti dari aplikasi lama, dan memuat ulang aplikasi yang kodenya sudah dimodifikasi cukup membuat repot. Karena aku harus restart Golang servernya setiap kali ada perubahan di dalam kode aplikasi.

<!--more-->

Oleh karena itu aku mencari-cari library yang mirip dengan Nodemon. Seperti [CompileDaemon](https://github.com/githubnemo/CompileDaemon), [Air](https://github.com/cosmtrek/air), [Realize](https://github.com/oxequa/realize), bahkan melihat ulang [Nodemon](https://nodemon.io/) karena memiliki fitur melihat perubahan di binary. Awalnya aku mencoba CompileDaemon, tapi ternyata fitur live-reloadnya tidak berjalan (mungkin ada yang salah di konfigurasinya 🤷‍♂). Lalu aku juga mencoba Air dan Realize, tapi library-library ini memerlukan file konfigurasi khusus supaya bisa berjalan dan ternyata kurang cocok untuk kebutuhanku. Karena yang aku butuhkan adalah library yang bisa dijalankan tanpa perlu ada file konfigurasi khusus (CompileDaemon tidak perlu file konfigurasi, tapi entah kenapa fitur live-reloadnya tidak berjalan).

Setelah mencari lebih jauh, ternyata ada library lain yang bernama [Gin](https://github.com/codegangsta/gin). Simpel tapi cukup powerful. Mirip seperti CompileDaemon tapi ada fitur tambahan seperti notifikasi desktop. Aku suka dengan fitur ini karena Gin akan mengirimkan notifikasi ke desktop setiap kali ada perubahan atau setiap kali kita melakukan penyimpanan di kode kita.

Berikut adalah parameter-parameter yang bisa kita pakai di Gin

```shell
   --laddr value, -l value       listening address for the proxy server
   --port value, -p value        port for the proxy server (default: 3000)
   --appPort value, -a value     port for the Go web server (default: 3001)
   --bin value, -b value         name of generated binary file (default: "gin-bin")
   --path value, -t value        Path to watch files from (default: ".")
   --build value, -d value       Path to build files from (defaults to same value as --path)
   --excludeDir value, -x value  Relative directories to exclude
   --immediate, -i               run the server immediately after it's built
   --all                         reloads whenever any file changes, as opposed to reloading only on .go file change
   --godep, -g                   use godep when building
   --buildArgs value             Additional go build arguments
   --certFile value              TLS Certificate
   --keyFile value               TLS Certificate Key
   --logPrefix value             Setup custom log prefix
   --notifications               enable desktop notifications
   --help, -h                    show help
   --version, -v                 print the version
```

Catatan: Salah satu kekurangan dari Gin adalah dia memerlukan proxy server sebagai entrypoint ke aplikasi kita.

## Contoh

### Menjalankan server Go di port 8080

Pada contoh berikut, Gin akan membuat proxy server di port 3000 (port default dari Gin) dan proxy server tersebut akan meneruskan request ke port aplikasi Golang kita di port 8000.

```shell
# This will run all main package
$ gin --appPort 8080

## Output
[gin] Listening on port 3000
[gin] Building...
[gin] Build finished
```

### Menjalankan server Go di port 8080 dan proxy server di port 5000

Pada contoh berikut, Gin akan membuat proxy server di port 5000 dan proxy server tersebut akan meneruskan request ke port aplikasi Golang kita di port 8000.

```shell
# This will run all main package
$ gin --appPort 8080 --port 5000

## Output
[gin] Listening on port 5000
[gin] Building...
[gin] Build finished
```

### Menjalankan server Go langsung setelah Gin build berhasil

Ada beberapa orang yang mengalami masalah dimana setelah Gin berhasil membuat ulang binary, mereka tidak bisa langsung mengirimkan API request ke proxy server Gin. Ini dikarenakan Gin menggunakan `time.Sleep(100 * time.Millisecond)` di fungsi `build` yang ada di dalamnya. Kita bisa menyiasati ini dengan menggunakan flag `--immediate` supaya proxy server akan langsung dijalankan setiap kali Gin berhasil membuat ulang binary aplikasi kita.

```shell
# This will run all main package
$ gin --appPort 8080 --port 5000 --immediate

# or
$ gin --appPort 8080 --port 5000 -i

## Output
[gin] Listening on port 5000
[gin] Building...
[gin] Build finished
```

### Mengirimkan notifikasi desktop

Ini salah satu fitur yang aku suka dari Gin. Dengan notifikasi desktop ini kita bisa tahu apakah build binary aplikasi kita berhasil atau gagal tanpa harus bolak-balik pindah dari IDE dan terminal kalian. Kita bisa menggunakan flag `--notifications`.

```shell
# This will run all main package
$ gin --appPort 8080 --port 5000 --immediate --notifications

## Output
[gin] Listening on port 5000
[gin] Building...
[gin] Build finished
```

**Preview**

{{< image classes="fancybox center clear fig-100" src="https://res.cloudinary.com/dweyilbvh/image/upload/v1588993429/Screen_Shot_2020-05-09_at_10.01.44_AM_qzligo.png" title="Build started" >}}
{{< image classes="fancybox center clear fig-100" src="https://res.cloudinary.com/dweyilbvh/image/upload/v1588993429/Screen_Shot_2020-05-09_at_10.01.34_AM_w4i2c4.png" title="Build success" >}}
{{< image classes="fancybox center clear fig-100" src="https://res.cloudinary.com/dweyilbvh/image/upload/v1588993700/Screen_Shot_2020-05-09_at_10.06.04_AM_t9yo1y.png" title="Build failed" >}}
