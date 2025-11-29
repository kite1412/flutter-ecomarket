import 'package:flutter/material.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import '../services/mock_store.dart';
import '../services/local_db.dart';
import '../utils/format.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _showTopUpDialog() async {
    final user = MockStore.instance.currentUser.value;
    if (user == null) return;
    final id = user['id'] as int;
    final ctrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Top Up Saldo'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Nominal (Rp)', hintText: '10000'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Masukkan nominal';
              final val = double.tryParse(v.replaceAll('.', '').trim());
              if (val == null || val <= 0) return 'Nominal tidak valid';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final val = double.parse(ctrl.text.replaceAll('.', '').trim());
                Navigator.pop(ctx, val);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
    if (result != null && result > 0) {
      await LocalDb.instance.addToBalance(id, result);
      setState(() {}); // trigger rebuild for new balance
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saldo bertambah Rp ${result.toInt()}')),
        );
      }
    }
  }

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
                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              ValueListenableBuilder<Map<String, dynamic>?>(
                                valueListenable: MockStore.instance.currentUser,
                                builder: (context, user, _) {
                                  if (user == null) {
                                    return const Text('Rp 0', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                                  }
                                  return FutureBuilder<Map<String, dynamic>?>(
                                    future: LocalDb.instance.getBalance(user['id'] as int),
                                    builder: (context, snap) {
                                      final amount = (snap.data != null ? snap.data!['amount'] : 0.0) as num;
                                      final formatted = formatRupiah(amount); // use utility
                                      return Text(formatted, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: MockStore.instance.currentUser.value == null ? null : _showTopUpDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: const Text('Top Up', style: TextStyle(fontWeight: FontWeight.bold)),
                          )
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
              
              // Product Grid (loads from local DB and refreshes when MockStore changes)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: MockStore.instance.products,
                  builder: (context, _, __) {
                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: LocalDb.instance.listItems(),
                      builder: (context, snap) {
                        var products = snap.data ?? [];
                        // Merge in-memory updates (e.g., images or recent edits) from MockStore
                        final memory = MockStore.instance.products.value;
                        products = products.map((dbItem) {
                          final match = memory.firstWhere(
                            (m) => m['id'] == dbItem['id'],
                            orElse: () => const {},
                          );
                          return {...dbItem, ...match};
                        }).toList();
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        if (products.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: const Center(child: Text('Belum ada produk. Tambah produk baru dari halaman Jual Sampah.')),
                          );
                        }
                        return GridView.builder(
                          itemCount: products.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemBuilder: (context, index) {
                            final p = products[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(product: p),
                                  ),
                                );
                              },
                              child: ProductCard(
                                imageUrl: (p['images'] is List && (p['images'] as List).isNotEmpty) ? (p['images'] as List).first as String? : null,
                                title: p['title'] ?? '',
                                price: formatRupiah(p['price']),
                                subtitle: (p['category'] != null ? '${p['category']}' : '') + (p['condition'] != null ? ' · ${p['condition']}' : ''),
                                quantity: p['quantity'] is int ? p['quantity'] as int : int.tryParse(p['quantity']?.toString() ?? '') ?? 1,
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // Removed donated books section
}
