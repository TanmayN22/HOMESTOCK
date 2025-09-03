import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotiService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isIntialized = false;

  bool get isIntialized => _isIntialized;

  Future<void> initNotification() async {
    if (_isIntialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation('Asia/Kolkata'),
    ); // Change timezone if needed

    const initSettingAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initSettingIos = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIos,
    );

    await notificationPlugin.initialize(initSettings);
    _isIntialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'expiry_channel_id',
        'Expiry Notifications',
        channelDescription: 'Alerts before items expire',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationPlugin.show(id, title, body, notificationDetails());
    print('🚀 Immediate notification fired: $title - $body');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final now = DateTime.now();
    final diff = scheduledDate.difference(now);

    if (scheduledDate.isBefore(now)) {
      print("⏰ Scheduled date is in the past, skipping: $scheduledDate");
      return;
    }

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    String timeUntilNotification;

    if (diff.inMinutes < 60) {
      timeUntilNotification = "${diff.inMinutes} minute(s)";
    } else if (diff.inHours < 24) {
      timeUntilNotification = "${diff.inHours} hour(s)";
    } else {
      timeUntilNotification = "${diff.inDays} day(s)";
    }

    print(
      '✅ Scheduled notification "$title" will fire in $timeUntilNotification at $scheduledDate',
    );
  }

  Future<void> scheduleExpiryNotifications({
    required int itemId,
    required String itemName,
    required DateTime expiryDate,
  }) async {
    final notifyDays = [14, 7, 3, 1];
    final now = DateTime.now();

    for (int daysBefore in notifyDays) {
      final notifyDate = expiryDate.subtract(Duration(days: daysBefore));

      if (notifyDate.isAfter(now)) {
        await scheduleNotification(
          id: itemId * 10 + daysBefore,
          title: 'Expiry Alert: $itemName',
          body: '$itemName will expire in $daysBefore day(s)!',
          scheduledDate: notifyDate,
        );
      } else if (daysBefore == 1) {
        // If it's already 1 day before, fire immediately
        await showNotification(
          id: itemId * 10 + daysBefore,
          title: 'Expiry Alert: $itemName',
          body: '$itemName will expire in 1 day!',
        );
      } else {
        print('❌ Skipped $daysBefore day reminder for $itemName (too late)');
      }
    }

    await listPendingNotifications();
  }

  Future<void> cancelExpiryNotifications(int itemId) async {
    final notifyDays = [14, 7, 3, 1];

    for (var daysBefore in notifyDays) {
      await cancelNotification(itemId * 10 + daysBefore);
    }
    print('🚫 Cancelled notifications for Item ID: $itemId');
  }

  Future<void> cancelNotification(int id) async {
    await notificationPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
  }

  Future<void> listPendingNotifications() async {
    final pending = await notificationPlugin.pendingNotificationRequests();

    if (pending.isEmpty) {
      print('🔔 No pending notifications');
    } else {
      print('🔔 Pending Notifications (${pending.length}):');
      for (var n in pending) {
        print('➡️ [ID: ${n.id}] Title: ${n.title}, Body: ${n.body}');
      }
    }
  }
}
