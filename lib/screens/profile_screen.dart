import 'package:flutter/material.dart';
import '../services/mock_store.dart';
import '../services/local_db.dart';
import '../utils/format.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Sidiq Recycling';
  String _email = 'Sidiq@email.com';
  String _address = '';

  final _editFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    MockStore.instance.currentUser.removeListener(_onUserChanged);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize from mock store if available and listen for changes
    final user = MockStore.instance.currentUser.value;
    if (user != null) {
      _name = (user['name'] ?? _name) as String;
      _email = (user['email'] ?? _email) as String;
      _address = (user['address'] ?? '') as String;
    }
    MockStore.instance.currentUser.addListener(_onUserChanged);
  }

  void _onUserChanged() {
    final user = MockStore.instance.currentUser.value;
    setState(() {
      if (user == null) {
        _name = 'Sidiq Recycling';
        _email = 'Sidiq@email.com';
        _address = '';
      } else {
        _name = (user['name'] ?? _name) as String;
        _email = (user['email'] ?? _email) as String;
         _address = (user['address'] ?? '') as String;
      }
    });
  }

  void _showEditProfileDialog() {
    _nameController.text = _name;
    _emailController.text = _email;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: Form(
          key: _editFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email tidak boleh kosong';
                  if (!v.contains('@')) return 'Masukkan email yang valid';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (!(_editFormKey.currentState?.validate() ?? false)) return;
              final newName = _nameController.text.trim();
              final newEmail = _emailController.text.trim();
              // Fetch existing user to preserve password when only name changes
              final existing = await LocalDb.instance.getUserByEmail(_email);
              final preservedPassword = existing?['password'] ?? '';
              final preservedAddress = existing?['address'] ?? (MockStore.instance.currentUser.value?['address'] ?? '');
              final preservedCreated = existing?['created_at'] ?? MockStore.instance.currentUser.value?['created_at'] ?? DateTime.now().toIso8601String();
              // Build map for upsert (will update by email)
              final userMap = {
                'name': newName,
                'email': newEmail,
                'password': preservedPassword,
                'address': preservedAddress,
                'created_at': preservedCreated,
              };
              try {
                await LocalDb.instance.upsertUser(userMap);
                final refreshed = await LocalDb.instance.getUserByEmail(newEmail);
                if (refreshed != null) {
                  MockStore.instance.currentUser.value = refreshed;
                  setState(() {
                    _name = refreshed['name']?.toString() ?? newName;
                    _email = refreshed['email']?.toString() ?? newEmail;
                  });
                }
                if (mounted) Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog() {
    final user = MockStore.instance.currentUser.value;
    if (user == null) return;
    final TextEditingController addrController = TextEditingController(text: _address);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Alamat'),
        content: TextField(
          controller: addrController,
          decoration: const InputDecoration(labelText: 'Alamat'),
          minLines: 1,
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final newAddr = addrController.text.trim();
              final id = user['id'];
              if (id is int) {
                try {
                  await LocalDb.instance.updateUser(id, {'address': newAddr});
                  final refreshed = await LocalDb.instance.getUserById(id);
                  if (refreshed != null) {
                    MockStore.instance.currentUser.value = refreshed;
                  }
                  setState(() { _address = newAddr; });
                  if (mounted) Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Alamat diperbarui')));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan alamat: $e')));
                }
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // --- Stats helpers ---
  double _asDouble(dynamic v) {
    if (v is num) return v.toDouble();
    return double.tryParse(v?.toString() ?? '') ?? 0.0;
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  String _fmtWeight(num kg) {
    if (kg >= 1000) {
      final ton = kg / 1000.0;
      return '${ton.toStringAsFixed(1)} Ton';
    }
    // Show without decimals when integer
    final isInt = kg.roundToDouble() == kg;
    final str = isInt ? kg.toInt().toString() : kg.toStringAsFixed(1);
    return '${str}Kg';
  }

  Future<Map<String, dynamic>> _loadStats() async {
    final current = MockStore.instance.currentUser.value;
    final int? userId = current != null && current['id'] is int ? current['id'] as int : null;

    final allItems = await LocalDb.instance.listItems();
    // Fetch all transactions to account for bought trash quantities
    final allTx = await LocalDb.instance.listTransactions();
    final Map<int, int> purchasedQtyByItem = {};
    for (final tx in allTx) {
      final itemId = tx['item_id'];
      final qty = tx['quantity'];
      if (itemId is int) {
        final addQty = (qty is int) ? qty : int.tryParse(qty?.toString() ?? '') ?? 1;
        purchasedQtyByItem[itemId] = (purchasedQtyByItem[itemId] ?? 0) + addQty;
      }
    }
    final myItems = userId != null ? await LocalDb.instance.listItems(userId: userId) : <Map<String, dynamic>>[];

    double totalAllKg = 0.0;
    for (final it in allItems) {
      final w = it.containsKey('weight_kg') ? _asDouble(it['weight_kg']) : _asDouble(it['weight']);
      final q = _asInt(it['quantity']);
      final itemId = it['id'];
      int purchased = 0;
      if (itemId is int && purchasedQtyByItem.containsKey(itemId)) {
        purchased = purchasedQtyByItem[itemId]!;
      }
      // Total weight counts both remaining quantity and purchased quantity
      final effectiveQty = (q <= 0 ? 0 : q) + purchased;
      totalAllKg += (w * (effectiveQty <= 0 ? 1 : effectiveQty));
    }

    double totalMyKg = 0.0;
    for (final it in myItems) {
      final w = it.containsKey('weight_kg') ? _asDouble(it['weight_kg']) : _asDouble(it['weight']);
      final q = _asInt(it['quantity']);
      final itemId = it['id'];
      int purchased = 0;
      if (itemId is int && purchasedQtyByItem.containsKey(itemId)) {
        purchased = purchasedQtyByItem[itemId]!;
      }
      final effectiveQty = (q <= 0 ? 0 : q) + purchased;
      totalMyKg += (w * (effectiveQty <= 0 ? 1 : effectiveQty));
    }

    return {
      'myCount': myItems.length,
      'allKg': totalAllKg,
      'myKg': totalMyKg,
    };
  }

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
                              Text(
                                _name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _email,
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
                          onPressed: _showEditProfileDialog,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Stats Cards (dynamic)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _loadStats(),
                  builder: (context, snap) {
                    final myCount = snap.data != null ? snap.data!['myCount'] as int : 0;
                    final allKg = snap.data != null ? (snap.data!['allKg'] as double) : 0.0;
                    final myKg = snap.data != null ? (snap.data!['myKg'] as double) : 0.0;
                    return Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '$myCount',
                            'Total Items',
                            Icons.inventory_2_outlined,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            _fmtWeight(allKg),
                            'Total Sampah',
                            Icons.recycling,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            _fmtWeight(myKg),
                            'Total',
                            Icons.eco,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Menu Items (Updated)
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
                    // Alamat + Balance
                    FutureBuilder<Map<String, dynamic>?>(
                      future: () async {
                        final user = MockStore.instance.currentUser.value;
                        if (user == null) return null;
                        final bal = await LocalDb.instance.getBalance(user['id'] as int);
                        return bal;
                      }(),
                      builder: (context, snapshot) {
                        final amount = snapshot.data?['amount'] is num ? snapshot.data!['amount'] as num : null;
                        final trailing = amount != null ? formatRupiah(amount) : null;
                        return _buildMenuItem(
                          icon: Icons.location_on_outlined,
                          title: _address.isNotEmpty ? 'Alamat' : 'Tambah Alamat',
                          trailing: trailing,
                          iconColor: Colors.blue[700]!,
                          iconBg: Colors.blue[50]!,
                          onTap: _showEditAddressDialog,
                        );
                      },
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
                            'Jual sampahmu & dapatkan nilai lebih',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Listing lebih banyak item hari ini untuk dampak hijau!',
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
                      icon: Icons.logout,
                      title: 'Keluar',
                      iconColor: Colors.red[700]!,
                      iconBg: Colors.red[50]!,
                      showArrow: false,
                      onTap: () {
                        // sign out from mock store
                        MockStore.instance.signOut();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anda telah keluar')));
                      },
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
    VoidCallback? onTap,
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
      onTap: onTap,
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
