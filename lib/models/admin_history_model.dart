class AdminHistory {
  final int id;
  final String email;
  final String transactionName;
  final double total;
  final String date;

  AdminHistory({
    required this.id,
    required this.email,
    required this.transactionName,
    required this.total,
    required this.date,
  });

  factory AdminHistory.fromJson(Map<String, dynamic> json) {
    return AdminHistory(
      id: int.parse(json['id']),
      email: json['email'],
      transactionName: json['transaction_name'],
      total: double.parse(json['total']),
      date: json['created_at'],
    );
  }
}
