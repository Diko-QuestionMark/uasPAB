import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    // 🔔 Android 13+ permission (RESMI, TANPA permission_handler)
    final androidImpl =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.requestNotificationsPermission();

    // 🔔 Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'welcome_channel',
      'Welcome Notifications',
      description: 'Notifikasi saat masuk aplikasi',
      importance: Importance.high,
    );

    await androidImpl?.createNotificationChannel(channel);
  }

  static Future<void> showWelcomeNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'welcome_channel',
      'Welcome Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Selamat Datang ☕',
      'Terima kasih sudah membuka Coffee Shop',
      details,
    );
  }
}
