import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/model_produts_list.dart';
import '../providers/favorite_provider.dart';
import '../services/api_service.dart';
import '../utils/sqflite_storage.dart';

class ProductsListScreen extends ConsumerStatefulWidget {
  const ProductsListScreen({super.key});

  @override
  ConsumerState<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends ConsumerState<ProductsListScreen> {
  Services apiServices = Services();
  late Future<List<ProductDetailsModel>> productList;
  final db = SqFlightStorage();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    productList = SqFlightStorage().getAllProducts();
    productList.then((products) {
      final jsonList = products.map((p) => p.toJson()).toList();
      if (jsonList.isEmpty) {
        debugPrint('No products found in the database, fetching from API...');
        getProductsApi();
      } else {
        debugPrint('Products fetched from database: ${jsonList.length}');
      }
      // final compactJson = jsonEncode(jsonList);
      // debugPrint('Fetched products: $compactJson');
    }).catchError((error) {
      debugPrint('Error fetching products: $error');
    });
  }

  getProductsApi() async {
    final response = await apiServices.getProducts();
    if (response.statusCode == 200) {
      final List<dynamic> dataList = response.data;
      final List<ProductDetailsModel> products = dataList.map((item) {
        final product = ProductDetailsModel.fromJson(item);
        product.favorite = false; // Set favorite to false by default
        return product;
      }).toList();

      await SqFlightStorage().insertAllProducts(products);
      debugPrint(
          'Successfully inserted ${products.length} products into database.');
    } else {
      debugPrint('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.read(allFavoriteProductProvider.notifier).refreshAllProducts();
    final productListItems = ref.watch(allFavoriteProductProvider).products;

    return Container(
      color: Colors.cyan.shade50,
      child: SizedBox(
          child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.80,
              ),
              itemCount: productListItems.length,
              itemBuilder: (context, index) {
                final product = productListItems[index];
                return Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/productDetails',
                          arguments: product,
                        );
                      },
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                product.image ?? '',
                                height: 150,
                                width: 150,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(children: [
                                    const SizedBox(height: 20),
                                    Text(product.title ?? '', maxLines: 1),
                                    const SizedBox(height: 5),
                                  ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            '₹${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,),
                                        Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    size: 10,
                                                    color: Colors.black),
                                                Text(
                                                    product.rating?.rate
                                                            ?.toStringAsFixed(
                                                                1) ??
                                                        '0.0',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                const SizedBox(width: 5),
                                                const Text('|',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                const SizedBox(width: 5),
                                                Text(
                                                    product.rating?.count
                                                            ?.toString() ??
                                                        '0',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal))
                                              ],
                                            ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            top: 15,
                            left: 155,
                            child: GestureDetector(
                              onTap: () async {
                                setState(() {
                                  product.favorite = !product.favorite;
                                });
                                await SqFlightStorage().updateFavoriteStatus(
                                    product.id!, product.favorite);
                                ref
                                    .read(allFavoriteProductProvider.notifier)
                                    .refreshAllProducts();
                                ref
                                    .read(allFavoriteProductProvider.notifier)
                                    .refreshFavorites();
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(
                                  product.favorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: product.favorite
                                      ? Colors.red
                                      : Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
              })),
    );
  }
}
