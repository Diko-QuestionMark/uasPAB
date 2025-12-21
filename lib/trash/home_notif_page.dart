import 'package:flutter/material.dart';
import '../services/noti_service.dart';

class HomeNotifPage extends StatelessWidget {
  const HomeNotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Notification")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await NotiService().showNotification(
              title: "Halo Fedriko 👋",
              body: "Notifikasi Flutter berhasil!",
            );
          },
          child: const Text("Send Notification"),
        ),
      ),
    );
  }
}
