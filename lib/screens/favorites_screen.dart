import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorite_provider.dart';
import '../utils/sqflite_storage.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final productListItems =
        ref.watch(allFavoriteProductProvider).favoriteItems;

    debugPrint('Favorite items count: $productListItems');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            style: IconButton.styleFrom(
              foregroundColor: Colors.black,
              iconSize: 25,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/cartScreen');
            },
          ),
        ],
      ),
      body: productListItems.isEmpty
          ? const Center(
              child: Text(
                'No favorite products found',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : Container(
              color: Colors.white,
              child: SizedBox(
                  child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.80,
                      ),
                      itemCount: productListItems.length,
                      itemBuilder: (context, index) {
                        final product = productListItems[index];
                        debugPrint('Favorite items context: $context');
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        product.image ?? '',
                                        height: 150,
                                        width: 150,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 20),
                                          Text(product.title ?? '',
                                              maxLines: 1),
                                          const SizedBox(height: 5),
                                           Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '₹${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                            color:
                                                                Colors.black12,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            8))),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: Row(
                                                      children: [
                                                        const Icon(Icons.star,
                                                            size: 10,
                                                            color:
                                                                Colors.black),
                                                        Text(
                                                            product.rating?.rate
                                                                    ?.toStringAsFixed(
                                                                        1) ??
                                                                '0.0',
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal)),
                                                        const SizedBox(
                                                            width: 5),
                                                        const Text('|',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                            product.rating
                                                                    ?.count
                                                                    ?.toString() ??
                                                                '0',
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal))
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
                                        await SqFlightStorage()
                                            .updateFavoriteStatus(
                                                product.id!, product.favorite);
                                        ref
                                            .read(allFavoriteProductProvider
                                                .notifier)
                                            .refreshAllProducts();
                                        ref
                                            .read(allFavoriteProductProvider
                                                .notifier)
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
                      }))),
    );
  }
}
