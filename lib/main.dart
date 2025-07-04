import 'package:e_cart_flutter/screens/cart_screen.dart';
import 'package:e_cart_flutter/screens/favorites_screen.dart';
import 'package:e_cart_flutter/screens/home_screen.dart';
import 'package:e_cart_flutter/screens/product_deatails_screen.dart';
import 'package:e_cart_flutter/screens/spash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(child:
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/productDetails': (context) => const ProductDetailsScreen(),
        '/cartScreen': (context) => const CartScreen(),
        '/favorites': (context) => const FavoritesScreen(),

      },
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    )
    );
  }
}

