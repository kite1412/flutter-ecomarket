import 'package:flutter/material.dart';
import '../services/local_db.dart';
import '../services/mock_store.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String _selectedFilter = 'Semua';
  late Future<List<Map<String, dynamic>>> _futureTx;

  @override
  void initState() {
    super.initState();
    _futureTx = _fetchTransactions();
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    final buyerId = MockStore.instance.currentUser.value?['id'] as int?; // null means all
    String? statusParam;
    switch (_selectedFilter) {
      case 'Pending':
        statusParam = 'pending';
        break;
      case 'Proses':
        statusParam = 'process';
        break;
      case 'Selesai':
        statusParam = 'completed';
        break;
      default:
        statusParam = null;
    }
    final txs = await LocalDb.instance.listTransactions(buyerId: buyerId, status: statusParam);
    final List<Map<String, dynamic>> enriched = [];
    for (final tx in txs) {
      final itemId = tx['item_id'] as int?;
      Map<String, dynamic>? item;
      if (itemId != null) {
        item = await LocalDb.instance.getItem(itemId);
      }
      final category = item?['category']?.toString() ?? '';
      final iconData = _iconForCategory(category);
      final statusLabel = _statusLabel(tx['status']?.toString() ?? '');
      final statusColor = _statusColor(tx['status']?.toString() ?? '');
      enriched.add({
        'orderId': 'TX${tx['id']}',
        'storeName': item?['title']?.toString() ?? 'Item ${itemId ?? ''}',
        'date': tx['created_at']?.toString() ?? '',
        'weight': item?['weight_kg'] != null ? '${item!['weight_kg']} kg' : '',
        'status': statusLabel,
        'statusColor': statusColor.value,
        'price': tx['price'] != null ? 'Rp ${tx['price'].round()}' : 'Rp 0',
        'icon': iconData.codePoint,
        'iconBg': _iconBg(category).value,
        'iconColor': _iconColor(category).value,
      });
    }
    return enriched;
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Plastik':
        return Icons.recycling;
      case 'Kertas':
        return Icons.description;
      case 'Elektronik':
        return Icons.lightbulb_outline;
      case 'Logam':
        return Icons.settings;
      default:
        return Icons.category;
    }
  }

  Color _iconBg(String category) {
    switch (category) {
      case 'Plastik':
        return Colors.blue[50]!;
      case 'Kertas':
        return Colors.orange[50]!;
      case 'Elektronik':
        return Colors.purple[50]!;
      case 'Logam':
        return Colors.grey[200]!;
      default:
        return Colors.green[50]!;
    }
  }

  Color _iconColor(String category) {
    switch (category) {
      case 'Plastik':
        return Colors.blue[700]!;
      case 'Kertas':
        return Colors.orange[700]!;
      case 'Elektronik':
        return Colors.purple[700]!;
      case 'Logam':
        return Colors.grey[700]!;
      default:
        return Colors.green[700]!;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'process':
        return 'Proses';
      case 'completed':
        return 'Selesai';
      default:
        return 'Unknown';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'process':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _selectFilter(String label) {
    setState(() {
      _selectedFilter = label;
      _futureTx = _fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'Pesanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Lihat Riwayat Jual Beli',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Filter Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip('Semua', _selectedFilter == 'Semua'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', _selectedFilter == 'Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Proses', _selectedFilter == 'Proses'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Selesai', _selectedFilter == 'Selesai'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order List (from LocalDb transactions)
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureTx,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final orders = snap.data ?? [];
                  if (orders.isEmpty) {
                    return Center(child: Text('Belum ada transaksi.'));
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      _futureTx = _fetchTransactions();
                      setState(() {});
                      await _futureTx;
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final o = orders[index];
                        final statusColor = Color(o['statusColor'] ?? Colors.grey.value);
                        final icon = IconData(o['icon'] ?? Icons.category.codePoint, fontFamily: 'MaterialIcons');
                        final iconBg = Color(o['iconBg'] ?? Colors.grey[100]!.value);
                        final iconColor = Color(o['iconColor'] ?? Colors.grey[700]!.value);
                        return _buildOrderCard(
                          orderId: o['orderId'] ?? '',
                          storeName: o['storeName'] ?? '',
                          date: o['date']?.toString().split('T').first ?? '',
                          weight: o['weight'] ?? '',
                          status: o['status'] ?? '',
                          statusColor: statusColor,
                          price: o['price'] ?? '',
                          icon: icon,
                          iconBg: iconBg,
                          iconColor: iconColor,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return InkWell(
      onTap: () => _selectFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[700] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green[700]! : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String storeName,
    required String date,
    required String weight,
    required String status,
    required Color statusColor,
    required String price,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderId,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      storeName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Date and Weight
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              if (weight.isNotEmpty) ...[
                const Spacer(),
                Text(
                  weight,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          
          // Divider
          Divider(
            color: Colors.grey[200],
            height: 1,
          ),
          const SizedBox(height: 12),
          
          // Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Harga',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
