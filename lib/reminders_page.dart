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
      theme: ThemeData(primarySwatch: Colors.green),
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
  final NotificationLogic _notificationLogic = NotificationLogic();
  final List<int> _waterIntervals = [1, 2, 3, 4];
  int? _selectedWaterInterval;
  int? _selectedStartHour;
  List<TimeOfDay?> _healthyEatingTimes = [];
  List<TimeOfDay?> _exerciseTimes = [];
  List<bool> _healthyEatingEnabled = [];
  List<bool> _exerciseEnabled = [];

  final int _minStartHour = 6;
  final int _maxStartHour = 10;

  int numOfExerciseReminders = 1;
  int numOfHealthyEatingReminders = 1;


  @override
  void initState() {
    super.initState();
    _loadReminderPreferences();
  }

  Future<void> _loadReminderPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Load water interval and start hour
      _selectedWaterInterval = prefs.getInt('water_interval');
      _selectedStartHour = prefs.getInt('start_hour') ?? _minStartHour;

      numOfHealthyEatingReminders = prefs.getInt('num_of_healthy_eating_reminders') ?? 1;

      // Load healthy eating reminders
      _healthyEatingTimes.clear();
      _healthyEatingEnabled.clear();
      for (int i = 0; i < numOfHealthyEatingReminders; i++) {
        int? hour = prefs.getInt('healthy_eating_hour_$i');
        int? minute = prefs.getInt('healthy_eating_minute_$i');
        bool isEnabled = prefs.getBool('healthy_eating_enabled_$i') ?? true;
        if (hour != null && minute != null) {
          _healthyEatingTimes.add(TimeOfDay(hour: hour, minute: minute));
        } else {
          _healthyEatingTimes.add(null);  // Handle null if no reminder is set
        }
        _healthyEatingEnabled.add(isEnabled);
      }

      numOfExerciseReminders = prefs.getInt('num_of_exercise_reminders') ?? 1;

      // Load exercise reminders
      _exerciseTimes.clear();
      _exerciseEnabled.clear();
      for (int i = 0; i < numOfExerciseReminders; i++) {
        int? hour = prefs.getInt('exercise_hour_$i');
        int? minute = prefs.getInt('exercise_minute_$i');
        bool isEnabled = prefs.getBool('exercise_enabled_$i') ?? true;
        if (hour != null && minute != null) {
          _exerciseTimes.add(TimeOfDay(hour: hour, minute: minute));
        } else {
          _exerciseTimes.add(null);  // Handle null if no reminder is set
        }
        _exerciseEnabled.add(isEnabled);
      }
    });
  }

  Future<void> _saveHealthyEatingReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _healthyEatingTimes.length; i++) {
      if (_healthyEatingTimes[i] != null) {
        await prefs.setInt('healthy_eating_hour_$i', _healthyEatingTimes[i]!.hour);
        await prefs.setInt('healthy_eating_minute_$i', _healthyEatingTimes[i]!.minute);
        await prefs.setBool('healthy_eating_enabled_$i', _healthyEatingEnabled[i]);
      }
    }
  }

  Future<void> _saveExerciseReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _exerciseTimes.length; i++) {
      if (_exerciseTimes[i] != null) {
        await prefs.setInt('exercise_hour_$i', _exerciseTimes[i]!.hour);
        await prefs.setInt('exercise_minute_$i', _exerciseTimes[i]!.minute);
        await prefs.setBool('exercise_enabled_$i', _exerciseEnabled[i]);
      }
    }
  }

  Future<void> _scheduleWaterReminders(int interval) async {
    int startHour = _selectedStartHour ?? _minStartHour;
    const int endHour = 23;
    int notificationIndex = 1;

    // Schedule new water reminders based on the selected start hour and interval
    for (int hour = startHour; hour < endHour; hour += interval) {
      final reminderTime = TimeOfDay(hour: hour, minute: 0);
      await _notificationLogic.scheduleNotification(reminderTime, 1, notificationIndex++);
    }
  }

  Future<void> _saveWaterInterval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('water_interval', _selectedWaterInterval ?? 1);

    // Call this after saving the interval to schedule the reminders
    await _scheduleWaterReminders(_selectedWaterInterval ?? 1);
  }

  Future<void> _saveStartHour() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('start_hour', _selectedStartHour ?? _minStartHour);
  }

  Future<void> _scheduleSpecificReminders(List<TimeOfDay?> times, int activityId, List<bool> enabledStates) async {
    for (int i = 0; i < times.length; i++) {
      if (times[i] != null && enabledStates[i]) {
        await _notificationLogic.scheduleNotification(times[i]!, activityId, i + 1);
      }
    }
  }



  Future<void> _selectSpecificTime(BuildContext context, int activityId, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (activityId == 2) {
          _healthyEatingTimes[index] = picked;
        } else if (activityId == 3) {
          _exerciseTimes[index] = picked;
        }
      });
      if (activityId == 2) {
        await _saveHealthyEatingReminders();
      } else if (activityId == 3) {
        await _saveExerciseReminders();
      }
      await _scheduleSpecificReminders(
          activityId == 2 ? _healthyEatingTimes : _exerciseTimes, activityId, activityId == 2 ? _healthyEatingEnabled : _exerciseEnabled);
    }
  }

  Future<void> _saveNumOfReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('num_of_healthy_eating_reminders', numOfHealthyEatingReminders);
    await prefs.setInt('num_of_exercise_reminders', numOfExerciseReminders);
  }

  void _addNewReminder(int activityId) {
    setState(() {
      if (activityId == 2) {
        if (_healthyEatingTimes.length < 5) {
          _healthyEatingTimes.add(null);
          _healthyEatingEnabled.add(true);

          numOfHealthyEatingReminders++;
          print(numOfHealthyEatingReminders);
        }
      } else if (activityId == 3) {
        if (_exerciseTimes.length < 5) {
          _exerciseTimes.add(null);
          _exerciseEnabled.add(true);

          numOfExerciseReminders++;
          print(numOfExerciseReminders);
        }
      }
    });
    _saveNumOfReminders(); // Save the updated reminder count
  }

  void _deleteReminder(int activityId, int index) {
    setState(() {
      if (activityId == 2) {
        _healthyEatingTimes.removeAt(index);
        _healthyEatingEnabled.removeAt(index);

        numOfHealthyEatingReminders--;
      } else if (activityId == 3) {
        _exerciseTimes.removeAt(index);
        _exerciseEnabled.removeAt(index);

        numOfExerciseReminders--;
      }
    });
    _saveNumOfReminders(); // Save the updated reminder count
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zarządzanie przypomnieniami', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight:FontWeight.w400),),
        backgroundColor: Colors.green,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildWaterReminderTile(),
              const SizedBox(height: 16),
              _buildStartingHourTile(),
              const SizedBox(height: 16),
              _buildActivityReminderTile('Zdrowym posiłku', 2, _healthyEatingTimes, _healthyEatingEnabled, _addNewReminder, _deleteReminder),
              const SizedBox(height: 16),
              _buildActivityReminderTile('Ćwiczeniach', 3, _exerciseTimes, _exerciseEnabled, _addNewReminder, _deleteReminder),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartingHourTile() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Przypominaj o piciu wody od godziny:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.remove, color: Colors.white), onPressed: _decrementStartHour),
                Text('$_selectedStartHour:00', style: const TextStyle(fontSize: 24, color: Colors.white)),
                IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _incrementStartHour),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterReminderTile() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Przypominaj o piciu wody co:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(icon: const Icon(Icons.remove, color: Colors.white), onPressed: _decrementWaterInterval),
                Text('${_selectedWaterInterval ?? _waterIntervals.first}h', style: const TextStyle(fontSize: 24, color: Colors.white)),
                IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: _incrementWaterInterval),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityReminderTile(String activityName, int activityId, List<TimeOfDay?> times, List<bool> enabledStates, Function addNewReminder, Function deleteReminder) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Przypominaj o $activityName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            ...List.generate(times.length, (index) {
              return ListTile(
                title: Text(times[index] != null ? '${times[index]!.format(context)}' : 'Wybierz godzinę', style: const TextStyle(color: Colors.white),),
                trailing: Switch(
                  value: enabledStates[index],
                  onChanged: (value) {
                    setState(() {
                      enabledStates[index] = value;
                    });
                    if (activityId == 2) {
                      _saveHealthyEatingReminders();
                    } else if (activityId == 3) {
                      _saveExerciseReminders();
                    }
                  },
                ),
                onTap: () => _selectSpecificTime(context, activityId, index),
                onLongPress: () => deleteReminder(activityId, index),
              );
            }),
            if (times.length < 5)
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => addNewReminder(activityId),
              ),
            if (times.length > 1)
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () => deleteReminder(activityId, times.length - 1),
              ),
          ],
        ),
      ),
    );
  }

  void _incrementWaterInterval() {
    setState(() {
      final currentIndex = _waterIntervals.indexOf(_selectedWaterInterval ?? _waterIntervals.first);
      _selectedWaterInterval = _waterIntervals[(currentIndex + 1) % _waterIntervals.length];
    });
    _saveWaterInterval();
  }

  void _decrementWaterInterval() {
    setState(() {
      final currentIndex = _waterIntervals.indexOf(_selectedWaterInterval ?? _waterIntervals.first);
      _selectedWaterInterval = _waterIntervals[(currentIndex - 1 + _waterIntervals.length) % _waterIntervals.length];
    });
    _saveWaterInterval();
  }

  void _incrementStartHour() {
    setState(() {
      if (_selectedStartHour! < _maxStartHour) {
        _selectedStartHour = _selectedStartHour! + 1;
      }
    });
    _saveStartHour();
  }

  void _decrementStartHour() {
    setState(() {
      if (_selectedStartHour! > _minStartHour) {
        _selectedStartHour = _selectedStartHour! - 1;
      }
    });
    _saveStartHour();
  }
}