import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Services {
  final baseUrl = 'https://fakestoreapi.com';
  final dio = Dio();

  Future<Response> getProducts() async {
    final response = await dio.get('$baseUrl/products');
    return response;
  }

  Future<Response> getProductDetails(String productId) async {
    final response = await dio.get('$baseUrl/products/{$productId}');
    if (kDebugMode) {
      print(response);
    }
    return response;
  }
}
