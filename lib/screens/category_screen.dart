import 'package:flutter/material.dart';
import '../widgets/product_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Search
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kategori Sampah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey[400]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Cari Sampah',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Semua Kategori Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Semua Kategori',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Category Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    _buildCategoryCard(
                      'Plastik',
                      '120 Items',
                      Icons.recycling,
                      Colors.blue,
                    ),
                    _buildCategoryCard(
                      'Kertas',
                      '89 Items',
                      Icons.description,
                      Colors.orange,
                    ),
                    _buildCategoryCard(
                      'Elektronik',
                      '45 Items',
                      Icons.lightbulb_outline,
                      Colors.purple,
                    ),
                    _buildCategoryCard(
                      'Organik',
                      '67 Items',
                      Icons.eco,
                      Colors.green,
                    ),
                    _buildCategoryCard(
                      'Kaca',
                      '34 Items',
                      Icons.wine_bar_outlined,
                      Colors.teal,
                    ),
                    _buildCategoryCard(
                      'Logam',
                      '52 Items',
                      Icons.settings,
                      Colors.grey,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Produk Terbaru Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Produk Terbaru',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Product Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                  children: [
                    ProductCard(
                      imageUrl: 'assets/images/product1.jpg',
                      title: 'Botol Plastik Bekas 5 Kecil',
                      price: 'Rp 75.000',
                      weight: '10 Kg',
                    ),
                    ProductCard(
                      imageUrl: 'assets/images/product2.jpg',
                      title: 'Gelas (Art) Kaleng Kontra',
                      price: 'Rp 45.000',
                      weight: '5 Kg',
                    ),
                    ProductCard(
                      imageUrl: 'assets/images/product3.jpg',
                      title: 'Kaleng Bekas(Art) 20kg',
                      price: 'Rp 125.000',
                      weight: '20 Kg',
                    ),
                    ProductCard(
                      imageUrl: 'assets/images/product4.jpg',
                      title: 'Botol X Kompress',
                      price: 'Rp 450.000',
                      weight: '50 Kg',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Tips Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Colors.green[700],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Tips Memilah Sampah!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildTipItem('Pisahkan sampah organik dari anorganik'),
                      _buildTipItem('Cuci bersih kemasan plastik sebelum dijual'),
                      _buildTipItem('Lipat kardus agar lebih mudah disimpan'),
                      _buildTipItem('Kumpulkan sampah dalam jumlah yang cukup'),
                      _buildTipItem('Pastikan dalam dalam kondisi bersih agar mendapat harga terbaik'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.green[700],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
