import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    List<Product> cartItems = CartService.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Colors.brown[800],
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Keranjang masih kosong'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      return ListTile(
                        leading: Image.network(product.image, width: 50),
                        title: Text(product.name),
                        subtitle:
                            Text('Rp ${product.price.toStringAsFixed(0)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              CartService.removeFromCart(product);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Total: Rp ${CartService.totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[800],
                          minimumSize: Size(double.infinity, 45),
                        ),
                        child: Text('Checkout'),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
