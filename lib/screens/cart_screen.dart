import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';

import '../animation/animation.dart';
import '../models/model_produts_list.dart';
import '../providers/cart_provider.dart';
import '../utils/shared_preferences.dart';
import '../utils/sqflite_storage.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final GlobalKey _cartItemKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  late BuildContext showcaseContext;
  bool showShowcase = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Refresh the cart items when the screen is first built
      _startShowcase();
      _loadShowcaseFlag();
    });
  }

  void _startShowcase() async {
    debugPrint("Starting showcase...");

    await Future.delayed(const Duration(milliseconds: 300));

    if (_scrollController.hasClients) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      debugPrint("Launching showcase now...");
      if (mounted) {
        ShowCaseWidget.of(showcaseContext).startShowCase([_cartItemKey]);
        SharedPreferencesCustom.saveShowcaseFirstLocal(true);
      }
    } else {
      debugPrint("ScrollController not ready yet.");
    }
  }

  void _loadShowcaseFlag() async {
    bool value = await SharedPreferencesCustom.getShowcaseFirstLocal();
    setState(() {
      showShowcase = !value; // Show showcase if value is false or null
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = SqFlightStorage();
    late Future<List<ProductDetailsModel>> productList;

    //providers
    final cartItemsAsync = ref.watch(cartItemsProvider);
    final cartTotal = ref.watch(cartTotalProvider);

    productList = SqFlightStorage().getAllCartProducts();

    return ShowCaseWidget(
      builder: (context) {
        showcaseContext = context;
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
                        return const Center(
                            child: Text('No items in the cart.'));
                      } else {
                        final products = snapshot.data!;
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final itemWidget = Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow:  [
                                  BoxShadow(
                                    color: Colors.cyan.shade100,
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Slidable(
                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) async {
                                        await db.deleteCartProduct(product.id!);
                                        ref
                                            .read(cartItemsProvider.notifier)
                                            .refreshCart();
                                      },
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: [
                                      Image.network(product.image ?? '',
                                          height: 80, width: 80),
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(product.title ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Text(
                                                  '₹${product.price?.toStringAsFixed(2) ?? '0.00'}',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            // Only showcase the first item
                            return index == 0 && showShowcase
                                ? Showcase(
                                    key: _cartItemKey,
                                    title: 'For Delete',
                                    description:
                                        'Slide left to delete an item from the cart.',
                                    child: itemWidget,
                                  )
                                : itemWidget;
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
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
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
                                  : showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (_) =>
                                          const FullScreenAnimation(),
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
      },
    );
  }
}
