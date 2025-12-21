import 'package:flutter/material.dart';
import 'package:mysql/services/noti_service.dart';
import 'pages/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init notifications
  await NotiService().initNotification();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCoffee',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.brown[800],
        scaffoldBackgroundColor: Colors.brown[50],
        fontFamily: 'Roboto',
      ),
      home: WelcomePage(), // Halaman awal
    );
  }
}
