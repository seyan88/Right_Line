# Right Line

[![]
[![]

## Deskripsi Proyek

**Right Line** adalah aplikasi penuntun jalan digital yang dirancang untuk membantu umat Islam menuju ketaatan yang lebih baik. Aplikasi ini berfungsi sebagai pengingat dan alat bantu untuk menunaikan ibadah, senantiasa taat, dan bersyukur kepada Allah SWT.



---

## Fitur Utama

Aplikasi ini menyediakan fitur-fitur penting yang berfokus pada jadwal ibadah dan lokasi tempat ibadah terdekat:

### ⏱️ Jadwal Waktu Ibadah

Aplikasi ini menampilkan waktu-waktu penting dalam sehari yang berkaitan dengan ibadah:
1.  **Sahur**
2.  **Imsak**
3.  **Waktu Adzan** (Subuh, Zuhur, Ashar, Maghrib, Isya)

### 🗺️ Pencari Masjid Terdekat

Melalui menu **Map** yang terletak di *bottom navbar*, pengguna dapat menemukan dan menavigasi ke masjid terdekat [Icon of a mosque] untuk melaksanakan salat berjamaah.

---

## 🛠️ Teknologi dan Framework

Aplikasi **Right Line** dikembangkan menggunakan:

* **Flutter:** Framework UI yang digunakan untuk membangun aplikasi *cross-platform* (Android dan iOS) dari satu basis kode.
    * **Target Platform:** Android dan iOS.

### Dependencies (Pubspec.yaml)

Dependencies utama yang digunakan dalam proyek ini meliputi:

* `shared_preferences: ^2.2.2` (Untuk menyimpan data lokal sederhana)
* `flutter_map: ^8.2.2` (Untuk menampilkan peta interaktif)
* `geolocator: ^13.0.1` (Untuk mendapatkan data lokasi pengguna/geolocation)
* `latlong2: ^0.9.1` (Untuk memanipulasi koordinat geografis)
* `http: ^1.2.1` (Untuk melakukan permintaan HTTP ke API)
* `url_launcher: ^6.1.7` (Untuk membuka tautan eksternal, seperti navigasi)
* `flutter_launcher_icons: ^0.13.1` (Untuk kustomisasi ikon aplikasi)

### API yang Digunakan

Aplikasi ini mengandalkan beberapa API eksternal untuk fungsionalitas utama:

1.  **Waktu Salat/Adzan:**
    * **URL:** `http://api.aladhan.com/v1/timings/$date?latitude=${userLocation!.latitude}&longitude=${userLocation!.longitude}&method=2`
    * **Tujuan:** Mengambil data waktu salat berdasarkan tanggal dan lokasi geografis pengguna.
2.  **Pencarian Masjid Terdekat (Overpass API):**
    * **URL:** `https://overpass-api.de/api/interpreter?data=[out:json];'(node["amenity"="place_of_worship"]["religion"="muslim"](around:2000,$lat,$lon););out;'`
    * **Tujuan:** Mengambil data lokasi masjid (place of worship dengan religion Muslim) di sekitar lokasi pengguna (radius 2000m) dari database OpenStreetMap.
3.  **Navigasi/Directions (Google Maps):**
    * **URL:** `https://www.google.com/maps/dir/?api=1&origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&travelmode=driving`
    * **Tujuan:** Membuat tautan Google Maps untuk navigasi dari lokasi pengguna ke masjid yang dipilih.

---

## 📽️ Demo Aplikasi

Tonton video demo berikut untuk melihat cara kerja aplikasi secara keseluruhan:

[Video Demo Right Line App]

---

## 📥 Instalasi dan Unduh

Aplikasi versi Android (APK) siap dipasang dapat diunduh langsung melalui tautan Google Drive di bawah ini.

**Unduh Aplikasi Android (APK):**
[Link to Google Drive APK File]

---

## Kontribusi

Kami menyambut kontribusi dari komunitas! Jika Anda memiliki saran atau menemukan *bug*, silakan buka *issue* atau kirimkan *pull request*.

---

## Lisensi

Proyek ini dilisensikan di bawah **MIT License**. Lihat berkas `LICENSE` untuk detail lebih lanjut.
