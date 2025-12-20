import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.brown[300],
            ),
            SizedBox(height: 16),
            Text(
              'Belum ada riwayat transaksi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.brown[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
