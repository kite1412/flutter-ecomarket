import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with Profile Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[700],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Profile Picture
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Name and Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sidiq Recycling',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sidiq@email.com',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Edit Button
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Stats Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '245',
                        'Total Items',
                        Icons.inventory_2_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '1.2 Ton',
                        'Sampah terkait',
                        Icons.recycling,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        '850Kg',
                        'Total',
                        Icons.eco,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Menu Items
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  children: [
                    _buildMenuItem(
                      icon: Icons.access_time,
                      title: 'Riwayat Daur',
                      iconColor: Colors.green[700]!,
                      iconBg: Colors.green[50]!,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.attach_money,
                      title: 'Riwayat Saldo',
                      iconColor: Colors.orange[700]!,
                      iconBg: Colors.orange[50]!,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.favorite_outline,
                      title: 'Favorit',
                      iconColor: Colors.pink[700]!,
                      iconBg: Colors.pink[50]!,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat',
                      trailing: 'Rp 246.000',
                      iconColor: Colors.blue[700]!,
                      iconBg: Colors.blue[50]!,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Mission Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[600]!, Colors.green[800]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selesaikan 5 misi untuk unlock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Bonus poin khusus menanti!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Settings Menu
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
                  children: [
                    _buildMenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan Akun',
                      iconColor: Colors.grey[700]!,
                      iconBg: Colors.grey[100]!,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Pusat Bantuan',
                      iconColor: Colors.grey[700]!,
                      iconBg: Colors.grey[100]!,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.description_outlined,
                      title: 'Ketentuan & Privasi',
                      iconColor: Colors.grey[700]!,
                      iconBg: Colors.grey[100]!,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Keluar',
                      iconColor: Colors.red[700]!,
                      iconBg: Colors.red[50]!,
                      showArrow: false,
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

  Widget _buildStatCard(String value, String label, IconData icon) {
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
        children: [
          Icon(
            icon,
            color: Colors.green[700],
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailing,
    required Color iconColor,
    required Color iconBg,
    bool showArrow = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          if (showArrow) ...[
            if (trailing != null) const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 60,
    );
  }
}
