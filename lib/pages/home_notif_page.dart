import 'package:flutter/material.dart';
import 'package:mysql/services/noti_service.dart';

class HomeNotifPage extends StatelessWidget {
  const HomeNotifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotiService().showNotification(title: "Title", body: "Body");
          },
          child: const Text("Send Notification"),
        ),
      ),
    );
  }
}
