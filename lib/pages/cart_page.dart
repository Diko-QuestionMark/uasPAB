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
        title: Text(
          'Keranjang',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [
                // ================= TABEL =================
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 16,
                        headingRowHeight: 45,
                        dataRowMinHeight: 70,
                        dataRowMaxHeight: 80,
                        headingRowColor: MaterialStateProperty.all(
                          Colors.brown[100],
                        ),
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('Gambar')),
                          DataColumn(label: Text('Produk')),
                          DataColumn(label: Text('Harga')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: List.generate(cartItems.length, (index) {
                          final product = cartItems[index];
                          return DataRow(
                            cells: [
                              DataCell(Text('${index + 1}')),
                              DataCell(
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    product.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.brown[200],
                                      child: Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 140,
                                  child: Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text('Rp ${product.price.toStringAsFixed(0)}'),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      CartService.removeFromCart(product);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),

                // ================= TOTAL & CHECKOUT =================
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total: Rp ${CartService.totalPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Checkout belum diimplementasikan'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[800],
                          minimumSize: Size(double.infinity, 45),
                        ),
                        child: Text('Checkout', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
