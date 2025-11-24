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
}
