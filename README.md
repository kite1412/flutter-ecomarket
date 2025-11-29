<!-- # 📱 EcoMarket - Aplikasi Jual Beli Sampah

Aplikasi mobile berbasis Flutter untuk marketplace jual beli sampah daur ulang dengan fitur lengkap untuk memudahkan pengguna menjual sampah mereka.

## ✨ Fitur Utama

### 🏠 Halaman Beranda
- Tampilan produk sampah yang tersedia
- Pencarian produk
- Kategori sampah (Plastik, Kertas, Kaca, Logam)
- Produk terbaru dan populer

### ➕ Halaman Jual Sampah (BARU!)
Fitur lengkap untuk menjual sampah dengan komponen:

#### 📸 Upload Foto Produk
- Upload minimal 3 foto produk
- Preview foto sebelum upload
- Hapus foto yang sudah diupload
- Maksimal 4 foto per produk

#### 📝 Detail Produk
- **Nama Produk**: Input nama dengan validasi
- **Kategori**: Dropdown dengan pilihan (Plastik, Kertas, Kaca, Logam)
- **Berat (kg)**: Input numerik untuk berat sampah
- **Harga (Rp)**: Input numerik untuk harga jual
- **Deskripsi**: Text area untuk detail kondisi sampah

#### 📍 Lokasi Pengambilan
- Input alamat lengkap manual
- Tombol "Gunakan Lokasi Saat Ini" untuk auto-fill alamat
- Validasi alamat wajib diisi

#### 💡 Saran Harga
- Info box dengan saran harga pasar
- Kalkulasi otomatis berdasarkan kategori dan berat
- Harga per kg untuk setiap kategori:
  - Plastik: Rp 1.500/kg
  - Kertas: Rp 1.000/kg
  - Kaca: Rp 500/kg
  - Logam: Rp 5.000/kg

#### ✅ Validasi Form
- Semua field wajib diisi
- Minimal 3 foto produk
- Notifikasi error yang jelas
- Konfirmasi setelah berhasil posting

### 🔍 Fitur Lainnya
- **Kategori**: Lihat produk berdasarkan kategori
- **Pesanan**: Kelola transaksi jual beli
- **Profil**: Manajemen akun pengguna

## 🎨 Desain UI/UX

### Warna Tema
- **Primary**: `#00A86B` (Hijau Eco-friendly)
- **Background**: `#F5F5F5` (Abu-abu terang)
- **Card**: `#FFFFFF` (Putih)
- **Info Box**: `#E3F5FF` (Biru muda)

### Komponen UI
- Header hijau dengan radius rounded
- Form fields dengan background abu-abu
- Button hijau dengan radius rounded
- Upload box dengan border dashed
- Info box dengan icon dan warna lembut

## 📂 Struktur Project

```
lib/
├── main.dart                          # Entry point aplikasi
├── screens/
│   ├── home_screen.dart              # Halaman beranda
│   ├── add_product_screen.dart       # 🆕 Halaman jual sampah
│   ├── category_screen.dart          # Halaman kategori
│   ├── order_screen.dart             # Halaman pesanan
│   └── profile_screen.dart           # Halaman profil
└── widgets/
    ├── main_navigator.dart           # Bottom navigation
    ├── product_card.dart             # Widget kartu produk
    └── category_card.dart            # Widget kartu kategori
```

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK >= 3.0.0
- Dart >= 3.0.0
- Android Studio / VS Code
- Emulator Android atau iOS

### Instalasi

1. **Masuk ke folder project**
   ```bash
   cd "d:\BelajarPemrograman\app sampah\app_sampah"
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

## 📦 Dependencies (Recommended untuk fitur lengkap)

Tambahkan ke `pubspec.yaml` untuk fitur tambahan:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Image Picker untuk upload foto
  image_picker: ^1.0.4
  
  # Geolocator untuk lokasi saat ini
  geolocator: ^10.1.0
  permission_handler: ^11.0.1
  
  # Format currency
  intl: ^0.18.1
  
  # HTTP request (optional)
  http: ^1.1.0
```

## 🔧 Implementasi Fitur Lanjutan

### 1. Upload Foto Produk
```dart
// Tambahkan image_picker package
import 'package:image_picker/image_picker.dart';

Future<void> _pickImage(int index) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    setState(() {
      _images[index] = pickedFile.path;
    });
  }
}
```

### 2. Gunakan Lokasi Saat Ini
```dart
// Tambahkan geolocator package
import 'package:geolocator/geolocator.dart';

Future<void> _getCurrentLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  
  if (permission == LocationPermission.always || 
      permission == LocationPermission.whileInUse) {
    Position position = await Geolocator.getCurrentPosition();
    
    // Convert koordinat ke alamat menggunakan geocoding
    // Kemudian set ke _addressController
  }
}
```

## 📱 Cara Menggunakan Fitur Jual Sampah

1. **Buka aplikasi** dan tap tombol **+** (hijau) di tengah bottom navigation
2. **Upload foto** - Tap kotak upload dan pilih minimal 3 foto produk
3. **Isi detail produk**:
   - Masukkan nama produk (contoh: "Botol Plastik Bersih")
   - Pilih kategori dari dropdown
   - Input berat dalam kg
   - Input harga yang diinginkan
   - Jelaskan kondisi sampah di deskripsi
4. **Isi lokasi pengambilan**:
   - Ketik alamat lengkap, atau
   - Tap "Gunakan Lokasi Saat Ini" untuk auto-fill
5. **Lihat saran harga** - Info box akan menampilkan harga pasar
6. **Tap "Posting Iklan"** untuk mempublikasikan
7. **Konfirmasi** akan muncul jika berhasil

## 🎯 Fitur yang Akan Datang

- [ ] Integrasi kamera untuk foto produk
- [ ] Map picker untuk lokasi
- [ ] Chat dengan pembeli
- [ ] Notifikasi real-time
- [ ] History transaksi
- [ ] Rating dan review
- [ ] Payment gateway

## 🐛 Troubleshooting

### Error: Flutter SDK not found
```bash
flutter doctor
```

### Error: Gradle build failed
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

## 📄 Lisensi

© 2025 EcoMarket - Aplikasi Jual Beli Sampah Daur Ulang

## 👨‍💻 Developer

Dibuat dengan ❤️ menggunakan Flutter

---

**Note**: Aplikasi ini menggunakan simulasi untuk fitur upload foto dan lokasi. Untuk implementasi production, tambahkan package yang disebutkan di bagian Dependencies. -->
