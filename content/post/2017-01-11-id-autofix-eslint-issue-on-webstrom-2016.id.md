---
title: "Memperbaiki Masalah Autofix ESLint pada Webstrom 2016"
thumbnailImage: https://boundingintocomics.com/files/2019/09/2019.09.18-05.47-boundingintocomics-5d826db3a30f6.png
coverImage: https://instazood.com/wp-content/uploads/2019/07/instagram_issue_sory_something_went_wrong-1050x550.jpg
coverCaption: https://instazood.com/blog/how-to-fix-instagram-issue-sorry-something-went-wrong/
metaAlignment: center
coverMeta: out
date: 2017-01-11T23:33:37+07:00
categories:
  - programming
tags:
  - webstrom
  - tips
description: "Memperbaiki masalah autofix ESLint yang tidak berjalan dengan menggunakan File Watcher di Webstrom 2016."
---

Saya dan tim sedang mengerjakan aplikasi Javascript dengan menggunakan NodeJS dan ReactJS. Kami menggunakan ESLint sebagai standart untuk kode kami dengan menggunakan konfigurasi ESLint dari AirBnB. Hingga saat ini kami cukup puas dengan konfigurasi ini.

<!--more-->

Saya pribadi menggunakan Webstrom 2016 untuk kegiatan koding sehari-hari. Meskipun Webstrom 2016 cukup powerful, tapi ini tidak seperti di VSCode ataupun Atom dimana kita bisa memperbaiki kode kita secara otomatis dengan menggunakan _plugin_ ESLint pada saat setiap kali kita menyimpan. Setelah Googling sana-sini, ternyata fitur perbaikan kode secara otomatis di Webstrom 2016 masih belum ada dan masih menjadi permintaan dari pengguna lainnya berdasarkan jawaban dari pertanyaan di [Stackoverflow](http://stackoverflow.com/a/29231841/2763662).

Ternyata, Webstrom (ataupun produk JetBrains lainnya) menyediakan _plugin_ yang bernama **File Watcher**. _Plugin_ ini dapat **"melihat"** (**_watch_**) perubahan pada kode kita dan akan melakukan suatu task tertentu jika terjadi perubahan. Informasi lebih lanjut, dapat membaca [referensi berikut](https://www.jetbrains.com/help/webstorm/2016.3/file-watchers.html).

Akhirnya saya mencoba menggunakan _plugin_ **File Watcher** tersebut supaya secara otomatis dapat memperbaiki kode kita yang ditandai memiliki masalah oleh ESLint. Jadi tidak perlu repot-repot memperbaiki kode yang berantakan. Berikut caranya untuk menggunakan File Watcher:

1. Install _plugin_ File Watcher. Kalian dapat menemukannya di menu **Preferences** > **Plugins** > **Search for “File Watchers"**. Centang pilihannya dan klik tombol **Apply**. Setelah itu kalian perlu restart Webstrom.

{{< figure classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*-LJSlJ4NHxX2bpBoG5vF_g.png" title="Preferences > Plugins > Search for \"File Watchers\"" >}}

2. Cari menu **Preferences** > **Tools** > **File Watchers**. Buat **File Watcher** baru dengan menekan tombol **+**. Lalu pilih **Custom Template**

{{< figure classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*jnQ-CyXK3lrbOvIw96QL6Q.png" >}}

3. Ubah **File Type** menjadi **Javascript**
4. Sesuaikan **Scope** kalian ke direktori projek kalian atau direktori apapun yang ingin kalian masukkan
5. Tambahkan binary ESLint ke path di menu **Watcher Settings** > **Program**. Jika kalian install ESLint secara local (maksudnya per projek), kalian dapat menemukan binary ESLint di `<project_path>/node_modules/bin`. Pathnya akan terlihat seperti ini

```shell
$ProjectFileDir$/node_modules/.bin/ESLint
```

Jika kalian install ESLint secara global (dengan/atau menggukan NVM), kalian dapat mencari path ESLint dengan mengeksekusi `which eslint` pada terminal. Contohnya jika saya menggunakan NVM, maka path-nya akan menjadi seperti ini (tergantung OS kalian)

```shell
/Users/vicz/.nvm/versions/node/v7.0.0/bin/ESLint
```

6. Tambahkan parameter `--fix $FileName$` ke **Watcher Settings** > **Arguments**
7. Klik menu **Watcher Settings** > **Other Options** untuk melihat opsi tersembunyi dan tambahkan `$FileDir` ke **Watcher Settings** > **Other Options** > **Working Directory**
8. Jangan centang menu **Immediate file synchronization**

{{< figure classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*9kmjeSMC4leS8VkrYx65PQ.png" >}}

> **_Referensi:_** \
> https://stackoverflow.com/questions/29221136/lint-only-on-save-intellij-webstorm \
> https://stackoverflow.com/questions/38883634/how-can-i-run-ESLint-fix-on-my-javascript-in-intellij-idea-webstorm-other-je \
> https://www.jetbrains.com/help/webstorm/2016.3/file-watchers.html
