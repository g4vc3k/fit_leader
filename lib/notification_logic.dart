import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationLogic {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationLogic() {
    _initializeNotifications();
    _setLocalTimeZone();
  }

  // Request notification permission
  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.request().isGranted) {
      print("Notifications have been enabled");
    } else {
      print("Notification permission denied.");
    }
  }

  // Initialize notifications
  Future<void> _initializeNotifications() async {
    await _requestNotificationPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminders_channel',
      'Reminders',
      description: 'Channel for reminder notifications',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Set the timezone to the device's local timezone
  Future<void> _setLocalTimeZone() async {
    tz.initializeTimeZones();
    String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    print("Timezone set to: $timeZoneName");
  }

  // Schedule notification with unique ID for each activity and reminder number
  Future<void> scheduleNotification(TimeOfDay time, int activityId, int reminderNumber) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    var scheduleDate = today.isAfter(now) ? today : today.add(const Duration(days: 1));
    final tzScheduleDate = tz.TZDateTime.from(scheduleDate, tz.local);

    print("Scheduling water reminder at: ${scheduleDate.toString()}"); // Debugging print


    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'reminders_channel',
      'Reminders',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Generate unique notification ID using activityId and reminderNumber
    int notificationId = activityId * 10 + reminderNumber;

    String title;
    String body;
    switch (activityId) {
      case 1:
        title = 'Przypomnienie o zdrowym nawyku';
        body = 'Pora napić się wody!';
        break;
      case 2:
        title = '🍎 Czas zjeść coś wartościowego! 🥕';
        body = 'Przypomnienie o zdrowym nawyku';
        break;
      case 3:
        title = 'Przypomnienie o zdrowym nawyku';
        body = 'Time to do some exercise!';
        break;
      default:
        title = 'Reminder';
        body = 'It\'s time!';
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tzScheduleDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}