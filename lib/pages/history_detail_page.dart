import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql/models/detail_model.dart';

class HistoryDetailPage extends StatelessWidget {
  final int historyId;
  final String date;
  final double total;

  HistoryDetailPage({
    required this.historyId,
    required this.date,
    required this.total,
  });

  Future<List<HistoryItem>> fetchItems() async {
    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2/kopi/get_history_detail.php?history_id=$historyId",
      ),
    );

    final List data = jsonDecode(response.body);
    return data.map((e) => HistoryItem.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Pesanan", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.brown[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<HistoryItem>>(
        future: fetchItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              ListTile(
                title: Text("Tanggal"),
                subtitle: Text(date),
              ),
              ListTile(
                title: Text("Total"),
                subtitle: Text("Rp ${total.toStringAsFixed(0)}"),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return ListTile(
                      leading: Icon(Icons.local_cafe),
                      title: Text(item.name),
                      trailing:
                          Text("Rp ${item.price.toStringAsFixed(0)}"),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
