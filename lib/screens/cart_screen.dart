import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../animation/animation.dart';
import '../models/model_produts_list.dart';
import '../providers/cart_provider.dart';
import '../utils/sqflite_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = SqFlightStorage();
    late Future<List<ProductDetailsModel>> productList;

    //providers
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final cartTotal = ref.watch(cartTotalProvider);


    productList = SqFlightStorage().getAllCartProducts();


    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.cyan.shade50,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<ProductDetailsModel>>(
                future: productList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No items in the cart.'));
                  } else {
                    final products = snapshot.data!;
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          child: Slidable(
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      await db.deleteCartProduct(product.id!);
                                      productList = db.getAllCartProducts();
                                      ref.read(cartItemsProvider.notifier).refreshCart();
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.network(product.image ?? '',
                                      height: 80, width: 80),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(product.title ?? '',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        Text(
                                            '₹${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.normal),),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Amount : ',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹${cartTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextButton.icon(
                        key: const Key('add_to_cart_button'),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          cartTotal.toStringAsFixed(2) == '0.00'
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cart is empty!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                )
                              :
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const FullScreenAnimation(),
                          );

                        },
                        icon: const Icon(Icons.local_shipping_sharp),
                        label: const Text('Place Order'),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
