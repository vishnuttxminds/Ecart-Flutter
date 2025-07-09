import 'package:e_cart_flutter/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_cart_flutter/models/model_produts_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../utils/sqflite_storage.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  final db = SqFlightStorage();


  @override
  initState() {
    super.initState();
    getCartItems();
  }

  void getCartItems() async {
    final cartItems = await db.getAllCartProducts();
    debugPrint('Cart items: ${cartItems.length}');
  }

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)?.settings.arguments as ProductDetailsModel;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Product Details',
            style: GoogleFonts.abhayaLibre(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              style: IconButton.styleFrom(
                foregroundColor: Colors.black,
                iconSize: 25,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/home',
                  arguments: 1,
                );
              },
            ),
          ]),
      body: SingleChildScrollView(
          child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(children: [
              const SizedBox(height: 50),
              Image.network(product.image.toString(), height: 200, width: 200),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      product.title.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.aboreto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 10, color: Colors.black),
                          Text(
                              product.rating?.rate?.toStringAsFixed(1) ?? '0.0',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal)),
                          const SizedBox(width: 5),
                          const Text('|',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
                          Text(product.rating?.count?.toString() ?? '0',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal))
                        ],
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₹${product.price?.toStringAsFixed(2) ?? '0.00'}',
                        textAlign: TextAlign.start,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      product.description.toString(),
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 140),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 50,
                      width: 50,
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
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 20,
                          child: Icon(
                            product.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: product.favorite ? Colors.red : Colors.black,
                            size: 25,
                          ),
                        ),
                      )),
                  const SizedBox(width: 10),
                  SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: TextButton.icon(
                        key: const Key('add_to_cart_button'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          SqFlightStorage().insertProductToCart(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(AppStrings.productAddedCart),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          ref.read(cartItemsProvider.notifier).refreshCart();
                          ref
                              .read(allFavoriteProductProvider.notifier)
                              .refreshFavorites();
                        },
                        icon: const Icon(Icons.shopping_cart_checkout),
                        label: const Text(AppStrings.addToCart),
                      )),
                ],
              ),
            ]),
          ],
        ),
      )),
    );
  }
}
