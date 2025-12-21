class HistoryItem {
  final String name;
  final double price;

  HistoryItem({required this.name, required this.price});

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      name: json['product_name'],
      price: double.parse(json['price'].toString()),
    );
  }
}
