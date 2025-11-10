# 🔧 Panduan Implementasi Fitur Jual Sampah

## Komponen Form yang Sudah Diimplementasi

### 1. State Management
```dart
final _formKey = GlobalKey<FormState>();
final _nameController = TextEditingController();
final _weightController = TextEditingController();
final _priceController = TextEditingController();
final _descriptionController = TextEditingController();
final _addressController = TextEditingController();
String? _selectedCategory;
List<String?> _images = [null, null, null, null];
```

### 2. Validasi Form
Setiap field memiliki validator:
- **Nama Produk**: Tidak boleh kosong
- **Kategori**: Harus dipilih
- **Berat**: Harus diisi (numeric only)
- **Harga**: Harus diisi (numeric only)
- **Deskripsi**: Tidak boleh kosong
- **Alamat**: Tidak boleh kosong
- **Foto**: Minimal 3 foto (validasi custom)

### 3. Upload Foto
```dart
Widget _buildImageUploadBox(int index) {
  // Container dengan border untuk upload
  // Tap untuk memilih gambar
  // Icon close untuk hapus gambar
}
```

**TODO untuk implementasi penuh:**
```dart
import 'package:image_picker/image_picker.dart';

Future<void> _pickImage(int index) async {
  final picker = ImagePicker();
  
  // Pilihan: Camera atau Gallery
  showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Kamera'),
            onTap: () async {
              Navigator.pop(context);
              final photo = await picker.pickImage(
                source: ImageSource.camera,
                maxWidth: 1920,
                maxHeight: 1080,
                imageQuality: 85,
              );
              if (photo != null) {
                setState(() => _images[index] = photo.path);
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text('Galeri'),
            onTap: () async {
              Navigator.pop(context);
              final photo = await picker.pickImage(
                source: ImageSource.gallery,
                maxWidth: 1920,
                maxHeight: 1080,
                imageQuality: 85,
              );
              if (photo != null) {
                setState(() => _images[index] = photo.path);
              }
            },
          ),
        ],
      ),
    ),
  );
}
```

### 4. Lokasi Saat Ini
```dart
void _useCurrentLocation() {
  // Simulasi saat ini
  // Implementasi lengkap di bawah
}
```

**TODO untuk implementasi penuh:**
```dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<void> _useCurrentLocation() async {
  try {
    // Cek permission
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Akses lokasi ditolak')),
        );
        return;
      }
    }
    
    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    
    // Dapatkan posisi
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    
    // Convert ke alamat
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    
    Navigator.pop(context); // Close loading
    
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String address = '${place.street}, ${place.subLocality}, '
                      '${place.locality}, ${place.subAdministrativeArea}, '
                      '${place.postalCode}';
      
      setState(() {
        _addressController.text = address;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lokasi berhasil digunakan')),
      );
    }
  } catch (e) {
    Navigator.pop(context); // Close loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal mendapatkan lokasi: $e')),
    );
  }
}
```

### 5. Saran Harga
Kalkulasi otomatis berdasarkan kategori dan berat:

```dart
String _calculateSuggestedPrice() {
  if (_selectedCategory == null || _weightController.text.isEmpty) {
    return '60-80 ribu';
  }

  final weight = int.tryParse(_weightController.text) ?? 0;
  
  // Harga per kg untuk setiap kategori
  final pricePerKg = {
    'Plastik': 1500,
    'Kertas': 1000,
    'Kaca': 500,
    'Logam': 5000,
  };

  final basePrice = (pricePerKg[_selectedCategory] ?? 1000) * weight;
  final minPrice = (basePrice * 0.8).toInt();
  final maxPrice = (basePrice * 1.2).toInt();

  return '$minPrice-$maxPrice';
}
```

### 6. Submit Form
```dart
void _submitForm() {
  if (_formKey.currentState!.validate()) {
    // Validasi foto
    final uploadedImages = _images.where((img) => img != null).length;
    if (uploadedImages < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tambahkan minimal 3 foto produk'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Kirim data ke backend
    // TODO: Implementasi API call
    _submitToBackend();
  }
}
```

**TODO untuk backend integration:**
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> _submitToBackend() async {
  try {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    
    // Prepare data
    final data = {
      'name': _nameController.text,
      'category': _selectedCategory,
      'weight': _weightController.text,
      'price': _priceController.text,
      'description': _descriptionController.text,
      'address': _addressController.text,
      'images': _images.where((img) => img != null).toList(),
    };
    
    // Upload images first (if using separate endpoint)
    List<String> uploadedImageUrls = [];
    for (var imagePath in _images.where((img) => img != null)) {
      var imageUrl = await _uploadImage(imagePath!);
      if (imageUrl != null) {
        uploadedImageUrls.add(imageUrl);
      }
    }
    
    data['image_urls'] = uploadedImageUrls;
    
    // Submit to API
    final response = await http.post(
      Uri.parse('https://your-api.com/api/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    
    Navigator.pop(context); // Close loading
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Success
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Berhasil!'),
          content: Text('Iklan Anda berhasil diposting'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Error
      throw Exception('Failed to post product');
    }
  } catch (e) {
    Navigator.pop(context); // Close loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal memposting iklan: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<String?> _uploadImage(String imagePath) async {
  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://your-api.com/api/upload'),
    );
    
    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath),
    );
    
    var response = await request.send();
    
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var json = jsonDecode(responseData);
      return json['url'];
    }
    
    return null;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
```

## Packages yang Diperlukan

Tambahkan ke `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Image picker
  image_picker: ^1.0.4
  
  # Location
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  permission_handler: ^11.0.1
  
  # HTTP & File upload
  http: ^1.1.0
  dio: ^5.4.0  # Alternative untuk HTTP dengan progress
  
  # Format & Utilities
  intl: ^0.18.1
```

Kemudian jalankan:
```bash
flutter pub get
```

## Permission Setup

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    
    <application ...>
        <!-- Provider for image picker -->
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="${applicationId}.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>
    </application>
</manifest>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<dict>
    <!-- Camera -->
    <key>NSCameraUsageDescription</key>
    <string>Aplikasi membutuhkan akses kamera untuk mengambil foto produk</string>
    
    <!-- Photo Library -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Aplikasi membutuhkan akses galeri untuk memilih foto produk</string>
    
    <!-- Location -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Aplikasi membutuhkan akses lokasi untuk menentukan alamat pengambilan</string>
</dict>
```

## Testing

### Test Form Validation
```dart
// Test nama produk kosong
_nameController.text = '';
_formKey.currentState!.validate(); // Should show error

// Test kategori tidak dipilih
_selectedCategory = null;
_formKey.currentState!.validate(); // Should show error

// Test foto kurang dari 3
_images = [null, null, null, null];
_submitForm(); // Should show snackbar error
```

### Test Kalkulasi Harga
```dart
// Test plastik 50kg
_selectedCategory = 'Plastik';
_weightController.text = '50';
// Expected: 60000-90000 (50 * 1500 * 0.8 = 60000, 50 * 1500 * 1.2 = 90000)

// Test logam 10kg
_selectedCategory = 'Logam';
_weightController.text = '10';
// Expected: 40000-60000 (10 * 5000 * 0.8 = 40000, 10 * 5000 * 1.2 = 60000)
```

## Optimasi & Best Practices

1. **Image Compression**: Kompres gambar sebelum upload
2. **Loading States**: Tampilkan loading indicator saat proses
3. **Error Handling**: Tangani semua error dengan baik
4. **Validation**: Validasi di client dan server
5. **Caching**: Cache data kategori untuk performa
6. **Offline Support**: Simpan draft jika offline

## Troubleshooting

### Permission denied untuk kamera/galeri
```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> _requestPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    status = await Permission.camera.request();
  }
  return status.isGranted;
}
```

### Image picker tidak bekerja di iOS
Pastikan Info.plist sudah dikonfigurasi dengan benar dan build ulang aplikasi.

### Lokasi tidak akurat
Gunakan `LocationAccuracy.high` untuk akurasi terbaik (tapi konsumsi baterai lebih tinggi).
