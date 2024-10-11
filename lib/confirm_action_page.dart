import 'package:flutter/material.dart';

class ConfirmActionPage extends StatefulWidget {
  const ConfirmActionPage({super.key});

  @override
  _ConfirmActionPageState createState() => _ConfirmActionPageState();
}

class _ConfirmActionPageState extends State<ConfirmActionPage> {
  double _sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Potwierdzenie Akcji'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Potwierdź wykonanie zadania: $_sliderValue%'),
            Slider(
              value: _sliderValue,
              onChanged: (newValue) {
                setState(() {
                  _sliderValue = newValue;
                });
              },
              min: 0,
              max: 100,
              divisions: 100,
            ),
            ElevatedButton(
              onPressed: () {
                // Logika po potwierdzeniu
                Navigator.pop(context); // Powrót do strony głównej
              },
              child: const Text('Potwierdź'),
            ),
          ],
        ),
      ),
    );
  }
}
