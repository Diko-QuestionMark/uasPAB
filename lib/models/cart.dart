// models/cart.dart
import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartModel {
  final List<CartItem> items = [];

  void addProduct(Product product) {
    final index = items.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      items[index].quantity++;
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeProduct(Product product) {
    items.removeWhere((e) => e.product.id == product.id);
  }

  double get totalPrice {
    double total = 0;
    for (var item in items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }
}
