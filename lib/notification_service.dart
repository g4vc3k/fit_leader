import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Tworzenie instancji FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Funkcja inicjalizująca powiadomienia
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Funkcja do wyświetlania powiadomień
Future<void> showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'reminders_channel', // ID kanału powiadomień
    'Reminders', // Nazwa kanału
    channelDescription: 'This channel is used for reminder notifications.', // Opis kanału
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // ID powiadomienia
    'Przypomnienie', // Tytuł powiadomienia
    'Czas na zdrowy nawyk: wypij wodę!', // Treść powiadomienia
    platformChannelSpecifics,
  );
}
