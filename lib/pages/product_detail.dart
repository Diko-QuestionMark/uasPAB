import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail({required this.product, Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  bool _isAdded = false;
  bool _isLoading = false;

  void _addToCart() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 50));

    CartService.addToCart(widget.product);

    setState(() {
      _isLoading = false;
      _isAdded = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${widget.product.name} berhasil ditambahkan ke keranjang',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAdded = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: widget.product.id,
              child: Image.network(
                widget.product.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.product.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.product.description,
                style: TextStyle(fontSize: 16, color: Colors.brown[700]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Rp ${widget.product.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[900],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.product.longDescription.isNotEmpty
                    ? widget.product.longDescription
                    : 'Deskripsi belum tersedia.',
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.brown,
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ElevatedButton(
          onPressed: (_isLoading || _isAdded) ? null : _addToCart,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isAdded ? Colors.green : Colors.brown[800],
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isAdded ? Icons.check : Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isAdded ? 'Ditambahkan' : 'Add to Cart',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
