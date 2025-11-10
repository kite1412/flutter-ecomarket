import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/category_screen.dart';
import '../screens/order_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/add_product_screen.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CategoryScreen(),
    const Center(child: Text('Jual Screen')), // Placeholder
    const OrderScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home_outlined,
                  label: 'Beranda',
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.grid_view_outlined,
                  label: 'Kategori',
                  index: 1,
                ),
                _buildNavItemCenter(
                  icon: Icons.add,
                  label: 'Jual',
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Pesanan',
                  index: 3,
                ),
                _buildNavItem(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  index: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.green[700] : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.green[700] : Colors.grey[600],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItemCenter({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        // Navigate to Add Product Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductScreen(),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.green[700],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
