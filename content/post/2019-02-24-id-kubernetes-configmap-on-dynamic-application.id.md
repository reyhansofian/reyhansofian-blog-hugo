---
title: "Kubernetes ConfigMap pada Aplikasi Dinamis"
thumbnailImagePosition: top
thumbnailImage: https://i0.wp.com/www.lediligent.com/wp/wp-content/uploads/2019/03/Kubernetes-Logo.png?fit=750%2C400&ssl=1
coverImage: https://stackify.com/wp-content/uploads/2018/03/quick-guide-to-kubernetes-1-1280x720.png
coverCaption: https://stackify.com/wp-content/uploads/2018/03/quick-guide-to-kubernetes-1-1280x720.png
metaAlignment: center
coverMeta: out
date: 2020-05-04T23:17:28+07:00
categories:
  - programming
tags:
  - kubernetes
description: "Kubernetes memiliki fitur yang bernama ConfigMap yang biasa digunakan untuk menyimpan konfigurasi suatu aplikasi. Di artikel ini kita akan membahas tentang ConfigMap dan kita bisa pakai ConfigMap untuk apa saja."
---

Kubernetes memiliki fitur yang bernama ConfigMap yang biasa digunakan untuk menyimpan konfigurasi suatu aplikasi. Di artikel ini kita akan membahas tentang ConfigMap dan kita bisa pakai ConfigMap untuk apa saja.

<!--more-->

# Apa Itu ConfigMap?

> ConfigMap allows you to decouple configuration artifacts from image content to keep containerized applications portable.

Menurut penjelasan resmi dari dokumentasi Kubernetes, ConfigMap adalah sebuah mekanisme untuk memisahkan konfigurasi dari sebuah aplikasi yang sudah dikontainerkan. Hal ini dapat membuat aplikasi tersebut lebih portabel dan membuat konfigurasinya lebih mudah untuk diubah dan dimanage, dan juga mengurangi kemungkinan konfigurasi yang langsung ditulis ke dalam sebuah Pod.
ConfigMap cocok digunakan untuk menyimpan konfigurasi yang tidak sensitif atau konfigurasi yang tidak perlu dienkripsi, seperti variabel lingkungan.

# Bagaimana Cara Kerja ConfigMap?

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/600/1*GoB8Po84hhM707uIi_xZVA.png" title="Gambar 1.1 — Membuat ConfigMap" >}}

Pada Gambar 1.1 kita membuat ConfigMap terlebih dahulu. Ada 3 cara untuk membuat ConfigMap:

1. Menggunakan opsi --from-file.
   Contoh: `kubectl create configmap myConfigMap --from-file /my/path/to/directory/or/file`
2. Menggunakan opsi --from-literal.
   Contoh: `kubectl create configmap myConfigMap --from-literal KEY1=VALUE1 KEY2=VALUE2`
3. Menggunakan manifest dengan tipe ConfigMap (lihat gambar 2.1).
   Untuk menggunakan cara ini kita perlu membuat sebuah file dengan ekstensi .yaml dan sesuai dengan spesifikasi, lalu mengunggah file tersebut dengan perintah `kubectl apply -f myConfigMap.yaml`

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/600/1*KQjy0ceER44muI5_kZkdLA.png" title="Gambar 1.2 — Unggah ConfigMap" >}}

Perintah `kubectl create configmap` maupun `kubectl apply -f <file>` akan mengunggah ConfigMap tersebut ke Apiserver Kubernetes yang ada di dalam cluster Kubernetes.

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/600/1*bVutgbPL5mfpdhnMTzFiAQ.png" title="Gambar 1.2 — Apiserver mendistribusikan ConfigMap" >}}

Lalu apiserver akan mendistribusikan ConfigMap tersebut ke semua Pod yang membutuhkan yang berada di dalam cluster Kubernetes.

# Bagaimana Cara Menggunakan ConfigMap?

Ada 2 cara untuk menggunakan ConfigMap:

**1. Sebagai environment variable**

Sebagai contoh, kita memiliki sebuah ConfigMap seperti berikut

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1000/1*UmIEX_zGQqrxNbTjdEyuGw.png" title="Gambar 2.1 - ConfigMap" >}}

**_Penjelasan nomor pada gambar:_**

&nbsp;&nbsp;&nbsp;&nbsp;_1. Nama ConfigMap_ \
&nbsp;&nbsp;&nbsp;&nbsp;_2. Blok data untuk sebuah ConfigMap_

Lalu kita gunakan nilai dari ConfigMap **"special-config"** (dari key **"metadata.name"**) tersebut ke sebuah Pod dengan menggunakan env seperti berikut

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1000/1*zSVWgoFVokE6MRPYvp3-MQ.png" title="Gambar 2.2 - Konfigurasi Pod" >}}

**_Penjelasan nomor pada gambar:_**

&nbsp;&nbsp;&nbsp;&nbsp;_1. Nama environment variable yang akan digunakan oleh aplikasi_ \
&nbsp;&nbsp;&nbsp;&nbsp;_2. Referensi ke ConfigMap yang akan digunakan. Dalam contoh ini mengacu kepada ConfigMap di gambar 2.1_ \
&nbsp;&nbsp;&nbsp;&nbsp;_3. Key dari sebuah ConfigMap yang akan dipakai nilainya_ \
&nbsp;&nbsp;&nbsp;&nbsp;_4. Referensi ke ConfigMap lain tanpa harus mendefinisikan key yang akan digunakan_

**2. Sebagai volume yang dipasang ke sebuah pod**

ConfigMap juga dapat digunakan dengan menggunakan plugin volume. Kita ambil contoh dengan menggunakan konfigurasi ConfigMap yang sama dengan di atas (gambar 2.1). Kita buat konfigurasi Pod seperti berikut:

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*q7EtLCY9rEhRH_on0ZZl1w.png" title="Gambar 2.3 - Konfigurasi Pod menggunakan plugin volume" >}}

**_Penjelasan nomor pada gambar:_**

&nbsp;&nbsp;&nbsp;&nbsp;_1. Referensi ke nama volume yang akan digunakan. Dalam contoh ini nomor 1 akan menggunakan volume dari nomor 3, yaitu volume “config-volume”_ \
&nbsp;&nbsp;&nbsp;&nbsp;_2. Path yang akan digunakan oleh volume tersebut di dalam Pod_ \
&nbsp;&nbsp;&nbsp;&nbsp;_3. Nama volume_ \
&nbsp;&nbsp;&nbsp;&nbsp;_4. Nama ConfigMap yang dijadikan referensi oleh volume “config-volume” (nomor 3)_

---

Menggunakan ConfigMap sebagai variabel lingkungan dengan menggunakan volume membuka peluang untuk mengubah variabel lingkungan yang ada didalam sebuah container atau Pod tanpa harus melakukan restart. Metode seperti ini biasa disebut dengan **_"live-update"_** atau **_"hot config"_**.

Kenapa **_"live-update"_** dibutuhkan? Karena di dalam dunia kontainerisasi, jika kita setel variabel lingkungan dengan `docker run -e <KEY>=<VALUE>` atau menggunakan `env` pada konfigurasi Pod, kita tidak bisa langsung menggantinya pada saat aplikasi berjalan. Sehingga kita perlu cara lain untuk membaca variabel lingkungan, yaitu dengan membaca dari sebuah file. Dalam konteks kali ini akan kita menggunakan ConfigMap yang sudah dipasang ke sebuah Pod.

Sebelum kita mulai, mari kita lihat apa yang terjadi jika ConfigMap berubah dengan contoh konfigurasi ConfigMap seperti berikut

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*jYIXmJHAv97m7XQZUWh-DQ.png" title="Gambar 3.1 - Konfigurasi ConfigMap" >}}

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*MiKDIUvl72yUvlIfUqs6KQ.png" title="Gambar 3.2 - ConfigMap di dalam sebuah container sebelum berubah" >}}

Jika kita perhatikan, setiap variabel yang kita definisikan di dalam ConfigMap akan menjadi sebuah file di dalam kontainer yang ada di dalam setiap Pod. File-file ini memiliki tautan (**_symlink_**) ke dalam sebuah folder `..data` dengan nama file yang sama. Misal `ENV_IS_MAINTENANCE` memiliki tautan ke file `..data/ENV_IS_MAINTENACE`, dst. Dan folder `..data` mengarah kepada sebuah folder yang memiliki nama `..2019_02_22_04_00_47.246998214`.

Sekarang mari kita coba membuat sebuah aplikasi sederhana menggunakan NodeJS dan ExpressJS yang membaca variabel lingkungan dari ConfigMap, lalu kita kemas ke dalam sebuah kontainer supaya kita bisa memvalidasi ide di atas.

{{< tabbed-codeblock index.js "https://gist.github.com/reyhansofian/9d9d8f7f242364595a56753bdeae721e#file-index-js" >}}

<!-- tab js -->

// @ts-check

const express = require("express");
const app = express();
const fs = require("fs");
const bodyParser = require('body-parser');

// volume mount path
const mountPath = "/etc/config";

// ConfigMap filename
const configMapFile = "..data";

// watching file
fs.watch(`${mountPath}`, (event, filename) => {
  // only listen to event "rename".
  // kubelet will rename the reference folder on ConfigMap update.
  if (event === "rename" && filename) {
  if (filename === configMapFile) {
  console.log(`process.env BEFORE: ${JSON.stringify(process.env)}`);

      // get all files from `..data` directory
      const dir = fs.readdirSync(`${mountPath}/${configMapFile}`);

      console.log(`Env list: ${dir}`);

      // read all files inside `..data` directory
      dir.forEach(env => {
          // inject the new envar value to `process.env` object (not recommended)
          process.env[env] = fs.readFileSync(
          `${mountPath}/${configMapFile}/${env}`
          );
      });

      console.log(`process.env AFTER: ${JSON.stringify(process.env)}`);
      }
  }
});

// for readinessProbe and livelinessProbe Kubernetes
app.get("/info", (req, res) => {
res.sendStatus(200);
});

app.get("/isMaintenance", (req, res) => {
const isMaintenace = process.env.ENV_IS_MAINTENANCE;

res.status(200).send(`Is it maintenance? ${isMaintenace}`);
})

app.listen(3000, err => {
if (err) {
console.error(err);
process.exit(1);
}

console.log(`Server is up on port 3000`);
});

<!-- endtab -->

{{< /tabbed-codeblock >}}

Kode di atas akan melihat dan melakukan perubahan jika terjadi event **_"rename"_** di dalam folder `/etc/config`. Setelah itu kita buat sebuah konfigurasi Deployment dan Service untuk sebuah Pod seperti berikut, lalu kita unggah ke Kubernetes dengan `kubectl apply -f test-k8s.yaml`.

{{< tabbed-codeblock test-k8s.yaml "https://gist.github.com/reyhansofian/89da577d93c6c191beef34cfeae2dca4#file-test-k8s-yaml" >}}

<!-- tab yaml -->

apiVersion: v1
kind: Service
metadata:
  labels:
    test-app: test
  name: test
  namespace: default
spec:
  externalTrafficPolicy: Cluster
  ports:
  - nodePort: 30321
    port: 3000
    protocol: TCP
    targetPort: 3000
  selector:
    test-app: test
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}
---
apiVersion: extensions/v1
kind: Deployment
metadata:
  name: test
spec:
  revisionHistoryLimit: 2
  strategy:
    type: RollingUpdate
  replicas: 1
  selector:
    matchLabels:
      test-app: test
  template:
    metadata:
      labels:
        test-app: test
    spec:
      volumes:
        - name: config-volume
          configMap:
            name: test-config
      containers:
        - name: test
          image: reyhan/docker-try-config:1.0.0
          command: ["npm", "start"]
          imagePullPolicy: Never
          livenessProbe:
            httpGet:
              path: /info
              port: 3000
            initialDelaySeconds: 90
            periodSeconds: 5
          readinessProbe:
            httpGet:
              path: /info
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
          ports:
            - containerPort: 3000
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
          resources:
            requests:
              memory: "256Mi"
              cpu: "64m"
            limits:
              memory: "512Mi"
              cpu: "256m"
          env:
            - name: ENV_SQL_CLIENT
              value: "mysql"
            - name: ENV_SQL_HOST
              value: "13.67.44.182"
            - name: ENV_IS_MAINTENANCE
              valueFrom:
                configMapKeyRef:
                  name: test-config
                  key: ENV_IS_MAINTENANCE
            - name: ENV_IS_BLOWN_UP
              valueFrom:
                configMapKeyRef:
                  name: test-config
                  key: ENV_IS_BLOWN_UP

<!-- endtab -->

{{< /tabbed-codeblock >}}

Selanjutnya mari kita ubah konfigurasi ConfigMap di atas menjadi

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*H9gsRDvKQeydrJWp6QInBg.png" title="Gambar 3.3 — Perubahan konfigurasi ConfigMap pada key \"ENV_IS_MAINTENTANCE\"" >}}

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*-chB0yixX6GdBfW3ZA0oDQ.png" title="Gambar 3.4 — ConfigMap di dalam sebuah container setelah berubah" >}}

Dari gambar di atas dapat kita lihat bahwa tautan antara file-file variabel lingkungan tidak berubah sama sekali. Hanya tautan folder ..data yang berubah tautannya menuju folder baru yang namanya `..2019_02_23_19_01_09.591362024`.

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/2000/1*0kLzHvwruLapTKbvgqaOKA.gif" >}}

Dari animasi di atas dapat kita lihat bagaimana mudahnya mengubah variabel lingkungan tanpa harus mengubah konfigurasi Deployment, Service, atau Pod sama sekali bahkan tanpa harus restart aplikasi tersebut.

Beberapa hal yang harus kita ingat jika menggunakan ConfigMap:

1. ConfigMap hanya "hidup" di dalam satu namespace saja. Yang artinya kita tidak bisa menggunakan ConfigMap yang berada di namespace lain.
2. Proses sinkronisasi ConfigMap tidak langsung terjadi atau biasa disebut **_"eventually consistent"_**. Hal ini terjadi karena frekuensi sinkronisasi dari kubelet standardnya adalah 60 detik. Jika ingin proses sinkronisasi lebih cepat dapat menggunakan opsi `--sync-frequency`. Untuk lebih jelasnya bisa baca dari dokumentasi resmi Kubernetes di [sini](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#mounted-configmaps-are-updated-automatically)

---

# Ekstra!

Jika kita amati, implementasi **_"live-update"_** di atas hanya bisa bekerja untuk NodeJS saja karena NodeJS memiliki pustaka standar untuk sistem file yang bisa melihat perubahan suatu file (dengan menggunakan `fs.watch`). Apabila kita ingin implementasi di bahasa lain, maka kode server dan konfigurasi Deployment, Service dan Pod di atas perlu sedikit penyesuaian.

{{< tabbed-codeblock k8s.yaml "https://gist.github.com/reyhansofian/af1bab9b437dcfb570fa263e101635bb#file-k8s-yaml" >}}

<!-- tab yaml -->

apiVersion: v1
kind: Service
metadata:
  labels:
    test-app: test
  name: test
  namespace: default
spec:
  externalTrafficPolicy: Cluster
  ports:
  - nodePort: 30321
    port: 3000
    protocol: TCP
    targetPort: 3000
  selector:
    test-app: test
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}
---
apiVersion: extensions/v1
kind: Deployment
metadata:
  name: test
spec:
  revisionHistoryLimit: 2
  strategy:
    type: RollingUpdate
  replicas: 1
  selector:
    matchLabels:
      test-app: test
  template:
    metadata:
      labels:
        test-app: test
    spec:
      volumes:
        - name: config-volume
          configMap:
            name: test-config
      containers:
        - name: configmap-reload
          image: "jimmidyson/configmap-reload:v0.1"
          imagePullPolicy: "IfNotPresent"
          args:
            - --volume-dir=/etc/config
            - --webhook-url=http://localhost:3000/-/reload
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
              readOnly: true
        - name: test
          image: reyhan/docker-try-config:1.0.3
          command: ["npm", "start"]
          imagePullPolicy: Never
          livenessProbe:
            httpGet:
              path: /info
              port: 3000
            initialDelaySeconds: 90
            periodSeconds: 5
          readinessProbe:
            httpGet:
              path: /info
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
          ports:
            - containerPort: 3000
          volumeMounts:
            - name: config-volume
              mountPath: /etc/config
          resources:
            requests:
              memory: "256Mi"
              cpu: "64m"
            limits:
              memory: "512Mi"
              cpu: "256m"
          env:
            - name: ENV_SQL_CLIENT
              value: "mysql"
            - name: ENV_SQL_HOST
              value: "13.67.44.182"
            - name: ENV_IS_MAINTENANCE
              valueFrom:
                configMapKeyRef:
                  name: test-config
                  key: ENV_IS_MAINTENANCE
            - name: ENV_IS_BLOWN_UP
              valueFrom:
                configMapKeyRef:
                  name: test-config
                  key: ENV_IS_BLOWN_UP

<!-- endtab -->

{{< /tabbed-codeblock >}}

Mari kita perhatikan konfigurasi containers di atas

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*b_xFQ5VYDIY54QKuzFE1Qw.png" >}}

Jika kita perhatikan lagi, kita menambahkan kontainer [jimmidyson/configmap-reload](https://github.com/jimmidyson/configmap-reload) dengan beberapa konfigurasinya ke dalam Pod untuk membaca perubahan ConfigMap.

{{< tabbed-codeblock app.js "https://gist.github.com/reyhansofian/7d8db68335870d5a889fabbd5e221413#file-app-js" >}}

<!-- tab js -->

// @ts-check

const express = require("express");
const app = express();
const fs = require("fs");
const bodyParser = require('body-parser');

const mountPath = "/etc/config";
const configMapFile = "..data";

function readConfig() {
  const dir = fs.readdirSync(`${mountPath}/${configMapFile}`);

  console.log(`Available envar: ${dir}`);

  dir.forEach(env => {
    process.env[env] = fs.readFileSync(
      `${mountPath}/${configMapFile}/${env}`
    );
  });
}

app.get("/info", (req, res) => {
  res.sendStatus(200);
});

app.use(bodyParser.json());

// configmap reload webhook
app.post("/-/reload", (req, res) => {
  // read new ConfigMap value
  readConfig();

  console.log(`process.env AFTER: ${JSON.stringify(process.env)}`);

  res.sendStatus(200);
});

app.get("/isMaintenance", (req, res) => {
  const isMaintenace = process.env.ENV_IS_MAINTENANCE;

  res.status(200).send(`Is it maintenance? ${isMaintenace}`);
})

app.listen(3000, err => {
  if (err) {
    console.error(err);
    process.exit(1);
  }

  console.log(`Server is up on port 3000`);
});

<!-- endtab -->

{{< /tabbed-codeblock >}}

Untuk kode server kita menambahkan satu endpoint supaya bisa menerima webhook dari kontainer **"configmap-reload"**.

{{<image classes="fancybox center clear fig-100" src="https://miro.medium.com/max/1400/1*QKmTx-uhZQZ85gynZWDlrw.png" >}}

Jika kita menggunakan metode seperti ini, maka alur kerjanya akan menjadi seperti berikut

1. Kontainer configmap-reload akan melihat apakah ConfigMap yang dipasang sebagai volume mengalami perubahan atau tidak
2. Jika ConfigMap mengalami perubahan, kontainer configmap-reload akan memberikan notifikasi kepada aplikasi yang memiliki endpoint `/-/reload` (sesuai dengan konfigurasi parameter `--webhook-url`)
3. Aplikasi yang menerima notifikasi akan membaca ulang semua variabel lingkungan yang ada di ConfigMap lalu menyimpan ulang ke sebuah variabel global. Karena contoh di atas menggunakan NodeJS, maka akan disimpan ke variabel `process.env`

Dengan metode seperti ini, kita bisa implementasi **_"live-update"_** dengan bahasa pemrograman apapun. Selamat bereksperimen!

---

# Referensi

- https://unofficial-kubernetes.readthedocs.io/en/latest/tasks/configure-pod-container/configmap/
- https://cloud.google.com/kubernetes-engine/docs/concepts/configmap
- https://www.slideshare.net/kubecon/kubecon-eu-2016-keynote-kubernetes-state-of-the-union
- https://medium.com/@xcoulon/kubernetes-configmap-hot-reload-in-action-with-viper-d413128a1c9a
- https://github.com/kubernetes/kubernetes/issues/30189
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap
- https://github.com/jimmidyson/configmap-reload
