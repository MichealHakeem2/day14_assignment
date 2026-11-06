import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      try {
        final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
      } catch (e) {
        debugPrint('Could not set local timezone: $e');
      }

      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      );

      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked: ${response.payload}');
        },
      );

      if (!kIsWeb && Platform.isAndroid) {
        final androidImpl = _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
        await androidImpl?.requestNotificationsPermission();
        await androidImpl?.requestExactAlarmsPermission();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    }
  }

  NotificationDetails _buildDetails() {
    const androidDetails = AndroidNotificationDetails(
      'ecommerce_channel_id',
      'E-Commerce Notifications',
      channelDescription: 'Notifications for store deals, updates, and reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );
  }

  Future<void> showNotification({
    String title = 'HI FROM FLUTTER',
    String body = 'THIS IS THE BODY OF THE NOTIFICATION',
    int id = 0,
  }) async {
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _buildDetails(),
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> showNow({
    required String title,
    required String body,
    int id = 0,
    String? payload,
  }) async {
    await showNotification(title: title, body: body, id: id);
  }

  Future<void> scheduleNotification({
    String title = 'HI FROM FLUTTER',
    String body = 'THIS IS THE BODY OF THE NOTIFICATION',
    int seconds = 5,
    int id = 1,
  }) async {
    try {
      final scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds));

      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: _buildDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> schedule({
    required String title,
    required String body,
    required int seconds,
    int id = 1,
    String? payload,
  }) async {
    await scheduleNotification(title: title, body: body, seconds: seconds, id: id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
