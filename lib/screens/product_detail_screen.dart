import 'package:flutter/material.dart';
import '../services/mock_store.dart';
import '../widgets/product_card.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final images = product['images'] as List? ?? [];
    final imageUrl = images.isNotEmpty ? images.first as String? : null;
    final title = product['title'] ?? '';
    final price = product['price'] ?? '';
    final weight = product['weight'] ?? '';
    final description = product['description'] ?? '';
    final address = product['address'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Text('Detail Produk'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / preview
            Container(
              color: Colors.grey[200],
              height: 260,
              width: double.infinity,
              child: imageUrl == null
                  ? const Center(child: Icon(Icons.image, size: 80, color: Colors.grey))
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
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
                        price != null && price.toString().isNotEmpty ? 'Rp $price' : 'Rp 0',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                      if (weight != null && weight.toString().isNotEmpty)
                        Text(
                          '${weight} Kg',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18),
                      const SizedBox(width: 6),
                      Expanded(child: Text(address)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
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
                          child: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          // Simple quick buy: create order and return
                          final order = {
                            'orderId': '#ORD${DateTime.now().millisecondsSinceEpoch % 100000}',
                            'storeName': title,
                            'date': DateTime.now().toIso8601String(),
                            'weight': weight?.toString() ?? '',
                            'status': 'Menunggu',
                            'statusColor': Colors.orange[700]!.value,
                            'price': price != null && price.toString().isNotEmpty ? 'Rp $price' : 'Rp 0',
                            'icon': Icons.recycling.codePoint,
                            'iconBg': Colors.orange[100]!.value,
                            'iconColor': Colors.orange[700]!.value,
                          };
                          MockStore.instance.addOrder(order);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat (mock)')));
                        },
                        child: const Text('Beli Cepat'),
                      ),
                    ],
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

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;
  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _quantity = 1; // not used extensively but available

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final priceVal = int.tryParse(p['price']?.toString() ?? '') ?? 0;
    final total = priceVal * _quantity;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green[700], title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Harga: Rp ${p['price'] ?? '0'}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Jumlah:'),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () => setState(() => _quantity = (_quantity - 1).clamp(1, 999)),
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('$_quantity'),
                IconButton(
                  onPressed: () => setState(() => _quantity = (_quantity + 1).clamp(1, 999)),
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Rp $total', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final order = {
                    'orderId': '#ORD${DateTime.now().millisecondsSinceEpoch % 100000}',
                    'storeName': p['title'] ?? '',
                    'date': DateTime.now().toIso8601String(),
                    'weight': p['weight'] ?? '',
                    'status': 'Belum dibayar',
                    'statusColor': Colors.red[400]!.value,
                    'price': 'Rp $total',
                    'icon': Icons.description.codePoint,
                    'iconBg': Colors.purple[100]!.value,
                    'iconColor': Colors.purple[700]!.value,
                  };
                  MockStore.instance.addOrder(order);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout berhasil (mock). Pesanan ditambahkan.')));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: const EdgeInsets.symmetric(vertical: 14)),
                child: const Text('Konfirmasi Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
