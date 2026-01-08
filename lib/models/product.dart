class Product {
  final int id;
  final String name;
  final String description;
  final String longDescription;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.longDescription,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      name: json['name'],
      description: json['description'],
      longDescription: json['long_description'],
      price: double.parse(json['price'].toString()),
      image: json['image'],
    );
  }
}
