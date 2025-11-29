import 'package:flutter/foundation.dart';

class MockStore {
  MockStore._();
  static final MockStore instance = MockStore._();

  // Simple in-memory products list. Each product is a Map<String, dynamic>
  final ValueNotifier<List<Map<String, dynamic>>> products =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  void addProduct(Map<String, dynamic> product) {
    final copy = List<Map<String, dynamic>>.from(products.value);
    copy.insert(0, product);
    products.value = copy;
  }

  void updateProduct(int id, Map<String, dynamic> fields) {
    final copy = List<Map<String, dynamic>>.from(products.value);
    final idx = copy.indexWhere((p) => p['id'] == id);
    if (idx != -1) {
      copy[idx] = {...copy[idx], ...fields};
      products.value = copy;
    }
  }

  // Simple in-memory orders list
  final ValueNotifier<List<Map<String, dynamic>>> orders =
      ValueNotifier<List<Map<String, dynamic>>>([]);

  void addOrder(Map<String, dynamic> order) {
    final copy = List<Map<String, dynamic>>.from(orders.value);
    copy.insert(0, order);
    orders.value = copy;
  }

  void clear() {
    products.value = [];
  }

  // Simple auth simulation
  final ValueNotifier<Map<String, dynamic>?> currentUser =
      ValueNotifier<Map<String, dynamic>?>(null);

  // Registered users (in-memory)
  final List<Map<String, dynamic>> _registeredUsers = [];

  /// Register a new user (in-memory). Returns true on success, false if email exists.
  bool register({required String name, required String email, required String password}) {
    final exists = _registeredUsers.any((u) => u['email'] == email);
    if (exists) return false;
    final user = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'password': password, // store plain for mock only
    };
    _registeredUsers.add(user);
    currentUser.value = {'id': user['id'], 'name': name, 'email': email};
    return true;
  }

  /// Login with email/password. Returns true on success.
  bool login({required String email, required String password}) {
    final user = _registeredUsers.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );
    if (user.isEmpty) return false;
    currentUser.value = {'id': user['id'], 'name': user['name'], 'email': user['email']};
    return true;
  }

  /// Sign out current user
  void signOut() {
    currentUser.value = null;
  }
}
