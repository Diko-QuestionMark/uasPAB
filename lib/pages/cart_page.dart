import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../services/cart_service.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;

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

      // ================= BODY =================
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              children: [
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
              ],
            ),

      // ================= BOTTOM CHECKOUT =================
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                      onPressed: isLoading ? null : _showConfirmDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[800],
                        minimumSize: Size(double.infinity, 45),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text('Checkout', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= DIALOG KONFIRMASI =================
  void _showConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.receipt_long, color: Colors.brown[800]),
            SizedBox(width: 8),
            Text(
              "Konfirmasi Pesanan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Pesanan akan diproses dan dicatat sebagai transaksi.\n\n"
          "Total pembayaran:\n"
          "Rp ${CartService.totalPrice.toStringAsFixed(0)}\n",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: TextStyle(color: Colors.grey[700])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[800]),
            onPressed: () {
              Navigator.pop(context);
              _checkout();
            },
            child: Text("Proses Checkout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ================= CHECKOUT FUNCTION =================
  Future<void> _checkout() async {
    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    if (userId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/kopi/checkout.php"),
        body: {
          "user_id": userId,
          "total": CartService.totalPrice.toString(),
          "items": jsonEncode(
            CartService.cartItems.map((e) {
              return {"name": e.name, "price": e.price};
            }).toList(),
          ),
        },
      );

      final data = jsonDecode(response.body);

      if (data["status"] == "success") {
        CartService.cartItems.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Checkout berhasil"),
            behavior: SnackBarBehavior.floating,
          ),
        );

        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Checkout gagal"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    setState(() => isLoading = false);
  }
}
