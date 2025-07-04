import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_cart_flutter/screens/cart_screen.dart';
import 'package:e_cart_flutter/screens/product_list_screen.dart';
import 'package:e_cart_flutter/screens/profile_screen.dart';
import 'package:e_cart_flutter/services/api_service.dart';
import 'package:lottie/lottie.dart';

import '../models/model_produts_list.dart';
import '../providers/cart_provider.dart';
import '../utils/sqflite_storage.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Services apiServices = Services();
  int _selectedIndex = 0;
  int _cartItemLength = 0;
  final db = SqFlightStorage();
  late Future<List<ProductDetailsModel>> cartList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductCount();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final routeArguments =
          ModalRoute.of(context)?.settings.arguments as int?;
      if (routeArguments != null) {
        _selectedIndex = routeArguments;
        setState(() {});
      }
    });
  }

  Future<void> getProductCount() async {
    final products = await db.getAllCartProducts();
    _cartItemLength = products.length;
  }

  final List<Widget> widgetOptions = const [
    ProductsListScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartItemCountProvider);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -2,
        title:
            const Text('Electronic Cart 2025', style: TextStyle(fontSize: 16)),
        leading: Lottie.network(
          'https://lottie.host/b239f9be-2fbf-47b9-9347-4544f7c8a395/Kyn33rsL3W.json',
          width: 30,
          height: 20,
          fit: BoxFit.contain,
        ),
      ),
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.blueGrey,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_bag),
                Positioned(
                  right: 0,
                  top: 0,
                  child: cartCount == 0 ? const SizedBox.shrink() : Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      cartCount.toString(), // Replace with your cart count
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile')
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
}
