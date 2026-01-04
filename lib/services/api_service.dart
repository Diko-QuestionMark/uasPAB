import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String url = 'http://10.0.2.2/kopi/api.php';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Gagal load produk');
  }

  static Future<void> addProduct({
    required String name,
    required String description,
    required double price,
    required String image,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'price': price,
        'image': image,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal tambah produk');
    }
  }

  static Future<void> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    required String image,
  }) async {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'image': image,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal update produk');
    }
  }

  static Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': id}),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal hapus produk');
    }
  }
}
