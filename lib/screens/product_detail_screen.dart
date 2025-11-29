import 'package:flutter/material.dart';
import '../services/mock_store.dart';
import '../services/local_db.dart';
import '../widgets/product_card.dart';
import 'add_product_screen.dart';
import '../utils/format.dart';
import 'dart:io';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Map<String, dynamic> product;

  @override
  void initState() {
    super.initState();
    product = Map<String, dynamic>.from(widget.product);
    // listen for product updates in MockStore and refresh by id
    MockStore.instance.products.addListener(_onProductsChanged);
  }

  void _onProductsChanged() {
    final id = product['id'];
    if (id == null) return;
    // Prefer DB as source of truth after edits
    _refreshFromDb(id);
  }

  Future<void> _refreshFromDb(int id) async {
    try {
      final row = await LocalDb.instance.getItem(id);
      if (row != null && mounted) {
        setState(() {
          product = {...product, ...row};
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    MockStore.instance.products.removeListener(_onProductsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = product['images'] as List? ?? [];
    final imageUrl = images.isNotEmpty
      ? images.first as String?
      : (product['image_path']?.toString());
    final title = product['title'] ?? '';
    final price = product['price'];
    final weight = product['weight_kg'] ?? product['weight'] ?? '';
    final quantity = product['quantity'] ?? 1;
    final description = product['description'] ?? '';
    final category = product['category']?.toString() ?? '';
    final condition = product['condition']?.toString() ?? '';
    final rawStatus = product['status']?.toString() ?? '';
    String mapStatus(String s) {
      switch (s) {
        case 'available':
          return 'Tersedia';
        case 'sold_out':
          return 'Habis';
        case 'reserved':
          return 'Dipesan';
        case 'pending':
          return 'Menunggu';
        default:
          return s
              .replaceAll('_', ' ')
              .split(' ')
              .where((e) => e.isNotEmpty)
              .map((e) => e[0].toUpperCase() + e.substring(1))
              .join(' ');
      }
    }
    final status = mapStatus(rawStatus);
    final createdAtRaw = product['created_at']?.toString();
    DateTime? createdAt; 
    if (createdAtRaw != null) {
      try { createdAt = DateTime.parse(createdAtRaw); } catch (_) {}
    }
    final createdAtStr = createdAt != null ? '${createdAt.day.toString().padLeft(2,'0')}/${createdAt.month.toString().padLeft(2,'0')}/${createdAt.year}' : '-';
    final userId = product['user_id'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        title: const Text('Detail Produk'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / preview with overlay chips
            Stack(
              children: [
                Container(
                  color: Colors.grey[200],
                  height: 260,
                  width: double.infinity,
                  child: imageUrl == null
                      ? const Center(child: Icon(Icons.image, size: 80, color: Colors.grey))
                      : (imageUrl.startsWith('http')
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Image.file(
                              File(imageUrl),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (category.isNotEmpty) _buildChip(category, Icons.category, Colors.green[700]!),
                      if (condition.isNotEmpty) _buildChip(condition, Icons.check_circle_outline, Colors.blue[700]!),
                      if (status.isNotEmpty) _buildChip(status, Icons.sync, Colors.orange[700]!),
                      if (weight != null && weight.toString().isNotEmpty) _buildChip('${weight} Kg', Icons.scale, Colors.purple[700]!),
                      _buildChip('Qty: $quantity', Icons.numbers, Colors.teal[700]! ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatRupiah(price),
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                      if (createdAtStr != '-')
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                            const SizedBox(width:4),
                            Text(createdAtStr, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0,4),
                        )
                      ],
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Informasi Produk', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        _buildInfoRow('Kategori', category, Icons.category),
                        _buildInfoRow('Kondisi', condition, Icons.check_circle_outline),
                        _buildInfoRow('Status', status, Icons.sync),
                        _buildInfoRow('Berat', weight != null && weight.toString().isNotEmpty ? '${weight} Kg' : '-', Icons.scale),
                        _buildInfoRow('Jumlah', quantity.toString(), Icons.numbers),
                        _buildInfoRow('Dibuat', createdAtStr, Icons.calendar_today),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(description, style: TextStyle(color: Colors.grey[700], height: 1.4)),
                  const SizedBox(height: 12),
                  if (userId is int)
                    FutureBuilder<Map<String, dynamic>?>(
                      future: LocalDb.instance.getUserById(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const SizedBox();
                        }
                        final addr = snapshot.data?['address']?.toString().trim() ?? '';
                        if (addr.isEmpty) return const SizedBox();
                        return Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 18),
                            const SizedBox(width: 6),
                            Expanded(child: Text(addr)),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                  Builder(
                    builder: (context) {
                      final currentUserId = MockStore.instance.currentUser.value?['id'];
                      final ownerId = product['user_id'];
                      final isOwner = currentUserId != null && ownerId != null && currentUserId == ownerId;
                      if (isOwner) {
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddProductScreen(product: product),
                                    ),
                                  );
                                  final id = product['id'];
                                  if (id is int) {
                                    await _refreshFromDb(id);
                                  }
                                },
                                child: const Text('Edit Produk', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(product: product),
                                  ),
                                );
                              },
                              child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoRow(String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, size: 16, color: Colors.green[700]),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Text(value.isNotEmpty ? value : '-', style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildChip(String text, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.85),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.4)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    ),
  );
}

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _quantity = 1; // not used extensively but available
  final _db = LocalDb.instance;

  Widget _miniInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final priceVal = (p['price'] is num)
        ? (p['price'] as num).toDouble()
        : double.tryParse(p['price']?.toString() ?? '') ?? 0;
    final stock = int.tryParse(p['quantity']?.toString() ?? '') ?? (p['quantity'] is int ? p['quantity'] as int : 1);
    final category = p['category']?.toString() ?? '';
    final condition = p['condition']?.toString() ?? '';
    final weight = p['weight_kg'] ?? p['weight'];
    final total = priceVal * _quantity;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        title: const Text('Checkout'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Harga: ${formatRupiah(p['price'])}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Jumlah:'),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _quantity > 1 ? () => setState(() => _quantity = (_quantity - 1).clamp(1, stock)) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_quantity'),
                IconButton(
                  onPressed: _quantity < stock ? () => setState(() => _quantity = (_quantity + 1).clamp(1, stock)) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
                const SizedBox(width: 12),
                Text('Stok: $stock', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
            const SizedBox(height: 12),
            if (category.isNotEmpty || condition.isNotEmpty || weight != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Info Item', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  if (category.isNotEmpty) _miniInfo('Kategori', category),
                  if (condition.isNotEmpty) _miniInfo('Kondisi', condition),
                  if (weight != null && weight.toString().isNotEmpty) _miniInfo('Berat', '${weight} Kg'),
                ],
              ),
            if (stock <= 0)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Stok habis. Tidak dapat membeli.', style: TextStyle(color: Colors.red)),
              ),
            const SizedBox(height: 8),
            Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total (${_quantity} x ${formatRupiah(priceVal)})', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(formatRupiah(total), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: stock > 0 ? () async {
                  // Insert transaction row (default 'completed' per DB schema)
                  final buyerId = MockStore.instance.currentUser.value?['id'];
                  final itemId = p['id'];
                  if (buyerId is int && itemId is int) {
                    try {
                      await _db.insertTransaction({
                        'buyer_id': buyerId,
                        'item_id': itemId,
                        'price': total,
                        // omit status & created_at to use defaults ('completed')
                      });
                    } catch (_) {}
                  }
                  final order = {
                    'orderId': '#ORD${DateTime.now().millisecondsSinceEpoch % 100000}',
                    'storeName': p['title'] ?? '',
                    'date': DateTime.now().toIso8601String(),
                    'weight': p['weight'] ?? '',
                    'status': 'Selesai',
                    'statusColor': Colors.green[600]!.value,
                    'price': formatRupiah(total),
                    'icon': Icons.description.codePoint,
                    'iconBg': Colors.purple[100]!.value,
                    'iconColor': Colors.purple[700]!.value,
                  };
                  MockStore.instance.addOrder(order);
                  // Attempt to decrement stock in DB if id available
                  final id = p['id'];
                  if (id is int) {
                    try {
                      final newQty = stock - _quantity;
                      if (newQty >= 0) {
                        await _db.updateItem(id, {
                          'quantity': newQty,
                          if (newQty == 0) 'status': 'sold_out',
                        });
                        // Also reflect in in-memory store to refresh all product cards
                        MockStore.instance.updateProduct(id, {
                          'quantity': newQty,
                          if (newQty == 0) 'status': 'sold_out',
                        });
                      }
                    } catch (_) {}
                  }
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout berhasil. Pesanan ditambahkan.')));
                } : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Konfirmasi Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
