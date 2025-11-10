import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.store,
                                color: Colors.green[700],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'EcoMarket',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Balance Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Saldo',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Rp 245.000',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Poin',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    '1.2 Ton',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          color: Colors.green[700],
                                          size: 12,
                                        ),
                                        Text(
                                          '4.8 %',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Kategori',
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
              
              // Category Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryCard(
                      icon: Icons.recycling,
                      label: 'Plastik',
                      color: Colors.blue[100]!,
                      iconColor: Colors.blue[700]!,
                    ),
                    CategoryCard(
                      icon: Icons.description,
                      label: 'Kertas',
                      color: Colors.orange[100]!,
                      iconColor: Colors.orange[700]!,
                    ),
                    CategoryCard(
                      icon: Icons.lightbulb_outline,
                      label: 'Elektronik',
                      color: Colors.purple[100]!,
                      iconColor: Colors.purple[700]!,
                    ),
                    CategoryCard(
                      icon: Icons.eco,
                      label: 'Organik',
                      color: Colors.green[100]!,
                      iconColor: Colors.green[700]!,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Featured Mission Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[600]!, Colors.green[800]!],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diskon 20% untuk Malam',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Kumpulkan sampah organik untuk mendapatkan bonus poin',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Ambil Misi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Pickup Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sampah Terbaru',
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
                      title: 'Botol Plastik Bekas 5kg',
                      price: 'Rp 15.000',
                    ),
                    ProductCard(
                      imageUrl: 'assets/images/product2.jpg',
                      title: 'Kardus Bekas Kondisi Baik',
                      price: 'Rp 45.000',
                      weight: '10 Kg',
                    ),
                    ProductCard(
                      imageUrl: 'assets/images/product3.jpg',
                      title: 'Kaleng Bekas(Art) 20kg',
                      price: 'Rp 70.000',
                      weight: '10 Kg',
                    ),
                    ProductCard(
                      imageUrl: 'assets/images/product4.jpg',
                      title: 'Botol Kaca Campur',
                      price: 'Rp 100.000',
                      weight: '30 Kg',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Buku Disumbangkan Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Buku Disumbangkan',
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
              
              // Book Items
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildBookItem(
                      'Buku Hukum Tata Negara 226g',
                      'Rp 50.000',
                      'Kondisi Baik',
                    ),
                    const SizedBox(height: 12),
                    _buildBookItem(
                      'Buku A Symposium Elektronik',
                      'Rp 100.000',
                      'Kurang Baik & Sampul Hilang',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookItem(String title, String price, String condition) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.book,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  condition,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
