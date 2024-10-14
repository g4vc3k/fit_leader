import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),// Set the background color to green
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            Text(
              "Bilans tygodniowy",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20), // Add spacing between the text
            Text("Poniedziałek"),
            _buildProgressBar(10, 0.2), // Progress bar 1, 2 out of 10
            SizedBox(height: 10),
            Text("Wtorek"),
            _buildProgressBar(10, 0.5), // Progress bar 2, 5 out of 10
            SizedBox(height: 10),
            Text("Środa"),
            _buildProgressBar(10, 0.8), // Progress bar 3, 8 out of 10
            SizedBox(height: 10),
            Text("Czwartek"),
            _buildProgressBar(10, 1.0), // Progress bar 4, fully completed
            SizedBox(height: 10),
            Text("Piątek"),
            _buildProgressBar(10, 0.7), // Progress bar 5, 7 out of 10
            SizedBox(height: 10),
            Text("Sobota"),
            _buildProgressBar(10, 0.3), // Progress bar 6, 3 out of 10
            SizedBox(height: 10),
            Text("Niedziela"),
            _buildProgressBar(10, 0.9), // Progress bar 7, 9 out of 10
          ],
        ),
      ),
    );
  }

  // Helper function to build a progress bar
  Widget _buildProgressBar(int parts, double value) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: value, // Set the progress (value between 0.0 and 1.0)
            backgroundColor: Colors.grey[300], // Inactive parts color
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green), // Active part color
            minHeight: 10, // Height of the progress bar
          ),
        ),
        SizedBox(width: 10),
        Text('${(value * parts).toInt()}/$parts', style: TextStyle(color: Colors.green)),
      ],
    );
  }
}
