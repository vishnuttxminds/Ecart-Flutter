import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/model_produts_list.dart';
import '../utils/sqflite_storage.dart';

class CardProvider extends StateNotifier<List<ProductDetailsModel>> {
  CardProvider() : super([]) {
    _loadCartItems();
  }
  void _loadCartItems() async {
    final db = SqFlightStorage();
    final items = await db.getAllCartProducts();
    state = items;
  }
  void refreshCart() => _loadCartItems();
}

final cartItemsProvider =
StateNotifierProvider<CardProvider, List<ProductDetailsModel>>(
        (ref) => CardProvider());

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartItemsProvider);
  return items.fold(0.0, (sum, item) => sum + (item.price ?? 0.0));
});

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartItemsProvider);
  return items.length;
});

