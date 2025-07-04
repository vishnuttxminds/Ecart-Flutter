import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/model_produts_list.dart';
import '../utils/sqflite_storage.dart';


class FavoriteState {
  final List<ProductDetailsModel> products;
  final List<ProductDetailsModel> favoriteItems;

  FavoriteState({ this.products = const [], this.favoriteItems = const[]});

  FavoriteState copyWith({
    List<ProductDetailsModel>? products,
    List<ProductDetailsModel>? favoriteItems,
  }) {
    return FavoriteState(
      products: products ?? this.products,
      favoriteItems: favoriteItems ?? this.favoriteItems,
    );
  }


}

class FavoriteProvider extends StateNotifier<FavoriteState> {
  FavoriteProvider() : super(FavoriteState(products: [], favoriteItems: [])) {
    _loadProductItems();
    _findAllFavoriteItems();
  }

  void _loadProductItems() async {
    final db = SqFlightStorage();
    final items = await db.getAllProducts();
    state = state.copyWith(products: items);
  }

  void _findAllFavoriteItems() async {
    final db = SqFlightStorage();
    final items = await db.getFavoriteStatusItems();
    state = state.copyWith(favoriteItems: items);
  }


  void refreshAllProducts() => _loadProductItems();
  void refreshFavorites() => _findAllFavoriteItems();
}

final allFavoriteProductProvider =
    StateNotifierProvider<FavoriteProvider, FavoriteState>(
        (ref) => FavoriteProvider());


