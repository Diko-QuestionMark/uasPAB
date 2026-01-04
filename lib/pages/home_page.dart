import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/weather_service.dart';
import 'product_detail.dart';
import 'cart_page.dart';
import 'manage_product_page.dart';
import '../utils/currency_formatter.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> futureProducts;

  String weatherText = '';
  String drinkRecommendation = '';
  bool _weatherExpanded = false;

  @override
  void initState() {
    super.initState();
    futureProducts = ApiService.getProducts();
    _fetchWeather();
  }

  void _fetchWeather() async {
    try {
      final data = await WeatherService.getWeather('Sungailiat');
      setState(() {
        weatherText = 'Cuaca: ${data['weather']}, ${data['temp']}°C';
        drinkRecommendation = WeatherService.recommendDrink(data['weather']);
      });
    } catch (e) {
      setState(() {
        weatherText = 'Gagal mengambil data cuaca';
        drinkRecommendation = 'Nikmati kopi favoritmu hari ini!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyCoffee',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CartPage()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown[800],
        child: Icon(Icons.edit, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ManageProductPage()),
          );

          if (result == true) {
            setState(() {
              futureProducts = ApiService.getProducts();
            });
          }
        },
      ),

      body: Column(
        children: [
          // ===== WEATHER COMPACT / EXPAND =====
          GestureDetector(
            onTap: () {
              setState(() {
                _weatherExpanded = !_weatherExpanded;
              });
            },
            child: AnimatedCrossFade(
              duration: Duration(milliseconds: 300),
              crossFadeState: _weatherExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,

              // 🔹 COMPACT
              firstChild: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                width: double.infinity,
                color: Colors.brown[100],
                child: Row(
                  children: [
                    Icon(Icons.cloud, color: Colors.brown[700]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        weatherText.isEmpty ? 'Memuat cuaca...' : weatherText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.brown[700]),
                  ],
                ),
              ),

              // 🔸 EXPANDED
              secondChild: Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                color: Colors.brown[100],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.brown[700]),
                        SizedBox(width: 8),
                        Text(
                          weatherText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.keyboard_arrow_up, color: Colors.brown[700]),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      drinkRecommendation,
                      style: TextStyle(fontSize: 14, color: Colors.brown[800]),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== PRODUCT GRID =====
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.brown[800]),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(color: Colors.brown[700]),
                    ),
                  );
                }

                final products = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ===== PRODUCT CARD =====
class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetail(product: product)),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.id,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  product.image,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                product.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.brown[700]),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                formatRupiah(product.price),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
