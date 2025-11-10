import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categories = ['Plastik', 'Kertas', 'Kaca', 'Logam'];
  
  final List<String?> _images = [null, null, null, null];

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _addImage(int index) {
    // Simulasi pemilihan gambar
    // Dalam implementasi nyata, gunakan image_picker package
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur upload foto akan menggunakan image_picker package'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _useCurrentLocation() {
    // Simulasi penggunaan lokasi saat ini
    // Dalam implementasi nyata, gunakan geolocator package
    setState(() {
      _addressController.text = 'Jl. Contoh No. 123, Jakarta Selatan';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lokasi berhasil digunakan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validasi minimal 3 foto
      final uploadedImages = _images.where((img) => img != null).length;
      if (uploadedImages < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tambahkan minimal 3 foto produk'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Proses posting iklan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil!'),
          content: const Text('Iklan Anda berhasil diposting'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[700],
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'Jual Sampah',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(
                      'Ubah sampahmu jadi uang tunai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto Produk Section
                      const Text(
                        'Foto Produk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: _buildImageUploadBox(index),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tambahkan minimal 3 foto produk',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Detail Produk Section
                      const Text(
                        'Detail Produk',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Nama Produk
                      const Text(
                        'Nama Produk',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Contoh: Botol Plastik Bersih',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama produk harus diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Kategori
                      const Text(
                        'Kategori',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: InputDecoration(
                          hintText: 'Pilih kategori',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kategori harus dipilih';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Berat dan Harga
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Berat (kg)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Harga (Rp)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _priceController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '0',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Wajib diisi';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Deskripsi
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Jelaskan kondisi dan detail sampah yang dijual...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Deskripsi harus diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Lokasi Pengambilan Section
                      const Text(
                        'Lokasi Pengambilan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Alamat Lengkap
                      const Text(
                        'Alamat Lengkap',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Masukkan alamat lengkap...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat harus diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      // Gunakan Lokasi Saat Ini Button
                      OutlinedButton.icon(
                        onPressed: _useCurrentLocation,
                        icon: const Icon(Icons.location_on_outlined),
                        label: const Text('Gunakan Lokasi Saat Ini'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green[700],
                          side: BorderSide(color: Colors.green[700]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Saran Harga Info Box
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F5FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.local_shipping_outlined,
                                color: Colors.green[700],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Saran Harga',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedCategory != null && _weightController.text.isNotEmpty
                                        ? 'Untuk kategori $_selectedCategory dengan berat ${_weightController.text}kg, harga pasar saat ini sekitar ${_calculateSuggestedPrice()} rupiah'
                                        : 'Untuk kategori Plastik dengan berat 50kg, harga pasar saat ini sekitar 60-80 ribu rupiah',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Posting Iklan Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Posting Iklan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Disclaimer Text
                      Center(
                        child: Text(
                          'Dengan memposting, Anda menyetujui syarat dan ketentuan kami',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadBox(int index) {
    return GestureDetector(
      onTap: () => _addImage(index),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: _images[index] == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.grey[400],
                    size: 32,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    index == 0 ? 'Tambah' : '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _images[index]!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _images[index] = null;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

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
}
