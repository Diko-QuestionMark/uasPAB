class History {
  final int id;
  final String date;
  final double total;

  History({
    required this.id,
    required this.date,
    required this.total,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: int.parse(json['id'].toString()),
      date: json['created_at'],
      total: double.parse(json['total'].toString()),
    );
  }
}
