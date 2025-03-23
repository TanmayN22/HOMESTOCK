import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isIntialized = false;

  bool get isIntialized => _isIntialized;

  // initailize
  Future<void> initNotification() async {
    if (_isIntialized) return; // prevernt re initailization

    // android
    const initSettingAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // ios
    const initSettingIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // init settings
    const initSettings = InitializationSettings(android: initSettingAndroid, iOS: initSettingIos);

    // final
    await notificationPlugin.initialize(initSettings);
  }

  // Notifications detail setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('daily_channel_id', 'Daily Notifications', channelDescription: 'Daily Notification Channel', importance: Importance.max, priority: Priority.high),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Show Notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(),
    );
  }

  // on Notification tap
}
