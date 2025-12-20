// models/cart.dart
import 'product.dart';

class CartModel {
  List<Product> products = [];

  // Menambah produk ke dalam keranjang 
  void addProduct(Product product) {
    products.add(product);
  }

  // Menghapus produk dari keranjang
  void removeProduct(Product product) {
    products.remove(product);
  }

  // Menghitung total harga
  double get totalPrice {
    double total = 0;
    for (var product in products) {
      total += product.price;
    }
    return total;
  }
}
