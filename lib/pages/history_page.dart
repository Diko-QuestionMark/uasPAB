import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql/models/history_model.dart';
import 'package:mysql/pages/history_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<History>> histories;

  @override
  void initState() {
    super.initState();
    histories = fetchHistory();
  }

  Future<List<History>> fetchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    final response = await http.get(
      Uri.parse("http://10.0.2.2/kopi/get_history.php?user_id=$userId"),
    );

    final List data = jsonDecode(response.body);
    return data.map((e) => History.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[800],
      ),
      body: FutureBuilder(
        future: histories,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return Center(child: Text("Belum ada riwayat transaksi"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final h = snapshot.data![index];
              return ListTile(
                leading: Icon(Icons.receipt, color: Colors.brown),
                title: Text("Total: Rp ${h.total.toStringAsFixed(0)}"),
                subtitle: Text(h.date),
                trailing: Icon(
                  Icons.chevron_right, // segitiga / panah
                  color: Colors.brown[400],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryDetailPage(
                        historyId: h.id,
                        date: h.date,
                        total: h.total,
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
