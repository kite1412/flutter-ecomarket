import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

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
                  _buildFilterChip('Semua', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Proses', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Selesai', false),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Order List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildOrderCard(
                    orderId: '#ORD1234',
                    storeName: 'Botol Plastik PET Bersih',
                    date: '2 Des, 2024',
                    weight: '',
                    status: 'Selesai',
                    statusColor: Colors.yellow[700]!,
                    price: 'Rp 15.000',
                    icon: Icons.recycling,
                    iconBg: Colors.orange[100]!,
                    iconColor: Colors.orange[700]!,
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    orderId: '#ORD1235',
                    storeName: 'Kardus Bekas untuk daur',
                    date: '5 Des, 2024',
                    weight: 'Lihat Detail',
                    status: 'Sedang diproses',
                    statusColor: Colors.green[600]!,
                    price: 'Rp 12.000',
                    icon: Icons.description,
                    iconBg: Colors.blue[100]!,
                    iconColor: Colors.blue[700]!,
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    orderId: '#ORD1236',
                    storeName: 'Kardus Bekas Kondisi Bagus',
                    date: '7 Des, 2024',
                    weight: '',
                    status: 'Belum dibayar',
                    statusColor: Colors.red[400]!,
                    price: 'Rp 45.000',
                    icon: Icons.description,
                    iconBg: Colors.purple[100]!,
                    iconColor: Colors.purple[700]!,
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    orderId: '#ORD1237',
                    storeName: 'Kaleng Alumunium',
                    date: '9 Des, 2024',
                    weight: '',
                    status: 'Sedang diproses',
                    statusColor: Colors.green[600]!,
                    price: 'Rp 30.000',
                    icon: Icons.recycling,
                    iconBg: Colors.orange[100]!,
                    iconColor: Colors.orange[700]!,
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    orderId: '#ORD1238',
                    storeName: 'Botol Kaca Campur',
                    date: '12 Des, 2024',
                    weight: 'Lihat Detail',
                    status: 'Menunggu',
                    statusColor: Colors.red[400]!,
                    price: 'Rp 100.000',
                    icon: Icons.wine_bar_outlined,
                    iconBg: Colors.teal[100]!,
                    iconColor: Colors.teal[700]!,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
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
