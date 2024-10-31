import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notification_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RemindersPage(),
    );
  }
}

class RemindersPage extends StatefulWidget {
  const RemindersPage({super.key});

  @override
  _RemindersPageState createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  TimeOfDay? _selectedTime1;
  TimeOfDay? _selectedTime2;
  final NotificationLogic _notificationLogic = NotificationLogic();

  @override
  void initState() {
    super.initState();
    _loadReminderTimes();
  }

  // Load saved reminder times from SharedPreferences
  Future<void> _loadReminderTimes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? hour1 = prefs.getInt('reminder_hour_1');
    int? minute1 = prefs.getInt('reminder_minute_1');
    int? hour2 = prefs.getInt('reminder_hour_2');
    int? minute2 = prefs.getInt('reminder_minute_2');
    setState(() {
      if (hour1 != null && minute1 != null) {
        _selectedTime1 = TimeOfDay(hour: hour1, minute: minute1);
      }
      if (hour2 != null && minute2 != null) {
        _selectedTime2 = TimeOfDay(hour: hour2, minute: minute2);
      }
    });
  }

  // Select reminder time for a specific activity
  Future<void> _selectTime(BuildContext context, int activityNumber) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: (activityNumber == 1 ? _selectedTime1 : _selectedTime2) ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (activityNumber == 1) {
          _selectedTime1 = picked;
        } else {
          _selectedTime2 = picked;
        }
      });
      await _notificationLogic.scheduleNotification(picked, activityNumber); // Schedule the notification
      _saveReminderTime(picked, activityNumber);
    }
  }

  // Save selected time for each activity to SharedPreferences
  Future<void> _saveReminderTime(TimeOfDay time, int activityNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (activityNumber == 1) {
      await prefs.setInt('reminder_hour_1', time.hour);
      await prefs.setInt('reminder_minute_1', time.minute);
    } else {
      await prefs.setInt('reminder_hour_2', time.hour);
      await prefs.setInt('reminder_minute_2', time.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _selectedTime1 != null
                    ? 'Przypomnienie 1 ustawione na ${_selectedTime1!.format(context)}'
                    : 'Brak zapisanych powiadomień dla aktywności 1.',
                style: const TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context, 1),
                child: const Text('Ustaw przypomnienie dla aktywności 1'),
              ),
              const SizedBox(height: 20),
              Text(
                _selectedTime2 != null
                    ? 'Przypomnienie 2 ustawione na ${_selectedTime2!.format(context)}'
                    : 'Brak zapisanych powiadomień dla aktywności 2.',
                style: const TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () => _selectTime(context, 2),
                child: const Text('Ustaw przypomnienie dla aktywności 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
