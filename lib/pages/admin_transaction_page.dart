import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/admin_history_model.dart';
import '../utils/currency_formatter.dart';
import 'history_detail_page.dart';

class AdminTransactionPage extends StatefulWidget {
  @override
  State<AdminTransactionPage> createState() => _AdminTransactionPageState();
}

class _AdminTransactionPageState extends State<AdminTransactionPage> {
  late Future<List<AdminHistory>> histories;

  @override
  void initState() {
    super.initState();
    histories = fetchAllHistory();
  }

  Future<List<AdminHistory>> fetchAllHistory() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2/kopi/get_all_history.php"),
    );

    final List data = jsonDecode(response.body);
    return data.map((e) => AdminHistory.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Transaksi", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[800],
      ),
      body: FutureBuilder<List<AdminHistory>>(
        future: histories,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada transaksi"));
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final h = snapshot.data![index];

              return ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text(h.transactionName),
                subtitle: Text("${h.email}\n${h.date}"),
                isThreeLine: true,
                trailing: Text(formatRupiah(h.total)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryDetailPage(
                        historyId: h.id,
                        date: h.date,
                        total: h.total,
                        transactionName: h.transactionName,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
