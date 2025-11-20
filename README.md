# Right Line

![Logo](assetss/logo_right_line.png)
![Splash](assetss/splash.jpeg)

## Deskripsi Proyek

**Right Line** adalah aplikasi penuntun jalan digital yang dirancang untuk membantu umat Islam menuju ketaatan yang lebih baik. Aplikasi ini berfungsi sebagai pengingat dan alat bantu untuk menunaikan ibadah, senantiasa taat, dan bersyukur kepada Allah SWT.

---

## Fitur Utama

Aplikasi ini menyediakan fitur-fitur penting yang berfokus pada jadwal ibadah dan lokasi tempat ibadah terdekat:

### ⏱️ Jadwal Waktu Ibadah

Aplikasi ini menampilkan waktu-waktu penting dalam sehari yang berkaitan dengan ibadah:

1. **Sahur**
2. **Imsak**
3. **Waktu Adzan** (Subuh, Zuhur, Ashar, Maghrib, Isya)

### 🗺️ Pencari Masjid Terdekat

Melalui menu **Map** yang terletak di _bottom navbar_, pengguna dapat menemukan dan menavigasi ke masjid terdekat untuk melaksanakan salat berjamaah.

---

## 🛠️ Teknologi dan Framework

Aplikasi **Right Line** dikembangkan menggunakan:

- **Flutter**: Framework UI untuk membangun aplikasi _cross-platform_ (Android dan iOS) dari satu basis kode.
  - **Target Platform:** Android dan iOS.

### Dependencies (Pubspec.yaml)

Dependencies utama yang digunakan dalam proyek ini:

- `shared_preferences: ^2.2.2`
- `flutter_map: ^8.2.2`
- `geolocator: ^13.0.1`
- `latlong2: ^0.9.1`
- `http: ^1.2.1`
- `url_launcher: ^6.1.7`
- `flutter_launcher_icons: ^0.13.1`

### API yang Digunakan

#### 1. Waktu Salat/Adzan

**URL:**  
`http://api.aladhan.com/v1/timings/$date?latitude=${userLocation!.latitude}&longitude=${userLocation!.longitude}&method=2`  
**Tujuan:** Mengambil data waktu salat berdasarkan tanggal dan lokasi pengguna.

#### 2. Pencarian Masjid Terdekat (Overpass API)

**URL:**  
`https://overpass-api.de/api/interpreter?data=[out:json];'(node["amenity"="place_of_worship"]["religion"="muslim"](around:2000,$lat,$lon););out;'`  
**Tujuan:** Mengambil data lokasi masjid di radius 2000 meter dari database OpenStreetMap.

#### 3. Navigasi/Directions (Google Maps)

**URL:**  
`https://www.google.com/maps/dir/?api=1&origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&travelmode=driving`  
**Tujuan:** Membuka navigasi Google Maps menuju masjid yang dipilih.

---

## 📽️ Demo Aplikasi

Tonton video demo berikut untuk melihat cara kerja aplikasi secara keseluruhan:

![Video Demo Right Line App](assetss/demo.mp4)

---

## 📥 Instalasi dan Unduh

Aplikasi versi Android (APK) siap dipasang dapat diunduh langsung melalui tautan Google Drive berikut:

**Unduh Aplikasi Android (APK):**  
[[Link to Google Drive APK File](https://drive.google.com/drive/folders/1s8hC8SxGUWLsYpgnyNS33yALik3pVoo2?usp=sharing)]

---

## Informasi Awal Proyek (Flutter Default)

Bagian ini adalah template bawaan Flutter saat proyek dibuat.

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- Dokumentasi Flutter: https://docs.flutter.dev/
