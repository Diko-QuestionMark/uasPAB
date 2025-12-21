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
        title: Text(
          "History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: FutureBuilder<List<History>>(
        future: histories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Belum ada riwayat transaksi"),
            );
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 0.8,
              color: Colors.brown[200],
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final h = snapshot.data![index];

              return ListTile(
                leading: Icon(
                  Icons.receipt_long,
                  color: Colors.brown,
                ),
                title: Text(
                  "Total: Rp ${h.total.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(h.date),
                trailing: Icon(
                  Icons.chevron_right,
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
