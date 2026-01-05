import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql/models/detail_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../utils/currency_formatter.dart';

class HistoryDetailPage extends StatelessWidget {
  final int historyId;
  final String date;
  final double total;
  final String transactionName;

  HistoryDetailPage({
    required this.historyId,
    required this.date,
    required this.total,
    required this.transactionName,
  });

  Future<void> _printPdf(BuildContext context, List<HistoryItem> items) async {
    final pdf = pw.Document();
    final formatter = NumberFormat.decimalPattern('id_ID');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Detail Pesanan",
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),

              pw.Text("Kode Transaksi: $transactionName"),
              pw.Text("Tanggal: $date"),
              pw.Text("Total: Rp ${formatter.format(total)}"),
              pw.Divider(),

              pw.Table.fromTextArray(
                headers: ["Produk", "Harga"],
                data: items.map((item) {
                  return [item.name, "Rp ${formatter.format(item.price)}"];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

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
        title: const Text(
          "Detail Pesanan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final items = await fetchItems();
              _printPdf(context, items);
            },
          ),
        ],
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
                title: Text("Kode Transaksi"),
                subtitle: Text(
                  transactionName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(title: Text("Tanggal"), subtitle: Text(date)),
              ListTile(
                title: Text("Total"),
                subtitle: Text(formatRupiah(total)),
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
                      trailing: Text(formatRupiah(item.price)),
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
