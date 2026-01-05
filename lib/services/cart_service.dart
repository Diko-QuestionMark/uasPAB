import '../models/cart.dart';
import '../models/product.dart';

class CartService {
  // Global cart instance
  static final CartModel cart = CartModel();

  // Tambah produk ke cart
  static void addToCart(Product product) {
    cart.addProduct(product);
  }

  // Hapus produk dari cart (hapus item unik)
  static void removeFromCart(Product product) {
    cart.removeProduct(product);
  }

  // Optional helper (tidak wajib, tapi rapi)
  static bool get isEmpty => cart.items.isEmpty;
}
