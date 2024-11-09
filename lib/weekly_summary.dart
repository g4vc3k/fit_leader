import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the current theme mode
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? Colors.white10 : Colors.white, // Adjust background color based on theme
      padding: EdgeInsets.all(20),
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
                color: isDarkMode ? Colors.white : Colors.green, // Adjust text color based on theme
              ),
            ),
            SizedBox(height: 20),
            Text("Poniedziałek", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            _buildProgressBar(10, 0.2, isDarkMode), // Progress bar with dynamic color
            SizedBox(height: 10),
            Text("Wtorek", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            _buildProgressBar(10, 0.5, isDarkMode),
            SizedBox(height: 10),
            Text("Środa", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            _buildProgressBar(10, 0.8, isDarkMode),
            SizedBox(height: 10),
            Text("Czwartek", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            _buildProgressBar(10, 1.0, isDarkMode),
            SizedBox(height: 10),
            Text("Piątek", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            _buildProgressBar(10, 0.7, isDarkMode),
            SizedBox(height: 10),
            Text("Sobota", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            _buildProgressBar(10, 0.3, isDarkMode),
            SizedBox(height: 10),
            Text("Niedziela", style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
            _buildProgressBar(10, 0.9, isDarkMode),
          ],
        ),
      ),
    );
  }

  // Helper function to build a progress bar
  Widget _buildProgressBar(int parts, double value, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: isDarkMode ? Colors.grey[600] : Colors.grey[300], // Background color changes in dark mode
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 10,
          ),
        ),
        SizedBox(width: 10),
        Text(
          '${(value * parts).toInt()}/$parts',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.green),
        ),
      ],
    );
  }
}
