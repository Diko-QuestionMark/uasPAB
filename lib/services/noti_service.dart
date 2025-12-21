import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Service untuk mengatur local notification
class NotiService {
  // Singleton supaya hanya satu instance
  NotiService._internal();
  static final NotiService _instance = NotiService._internal();
  factory NotiService() => _instance;

  // Plugin notification
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Cek apakah sudah di-initialize
  bool _isInitialized = false;

  // Inisialisasi notification (dipanggil di main)
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Android init
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS init + permission
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Gabungkan setting
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    // Initialize plugin
    await notificationsPlugin.initialize(initSettings);

    // Permission Android 13+
    final androidPlugin = notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();

    _isInitialized = true;
  }

  // Detail channel notification
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Menampilkan notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }
}
