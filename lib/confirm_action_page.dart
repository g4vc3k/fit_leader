import 'package:flutter/material.dart';

class ConfirmActionPage extends StatefulWidget {
  const ConfirmActionPage({super.key});

  @override
  _ConfirmActionPageState createState() => _ConfirmActionPageState();
}

class _ConfirmActionPageState extends State<ConfirmActionPage> with SingleTickerProviderStateMixin {
  double _sliderValue = 0;
  bool _isTaskCompleted = false; // Stan informujący o zakończeniu zadania
  bool _showPointsMessage = false; // Stan informujący o wyświetleniu wiadomości o punktach
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();

    // Inicjalizuj AnimationController i Animation
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animacja zmiany koloru tła
    _backgroundColorAnimation = ColorTween(begin: Colors.white, end: Colors.green).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _completeTask() {
    setState(() {
      _isTaskCompleted = true; // Ustaw flagę zakończenia zadania
    });

    _controller.forward(); // Rozpocznij animację powiększania

    // Opóźnienie 5 sekund przed powrotem do strony głównej
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context); // Powrót do strony głównej
    });

    // Opóźnienie 1 sekundy przed wyświetleniem wiadomości o punktach
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showPointsMessage = true; // Ustaw flagę do wyświetlenia wiadomości o punktach
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Zwolnij kontroler animacji
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            color: _backgroundColorAnimation.value, // Ustaw płynnie tło
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Wyświetl suwak tylko, gdy zadanie nie jest zakończone
                  if (!_isTaskCompleted) ...[
                    const SizedBox(height: 200),
                    Text(
                      'Przesuń suwak do góry, aby potwierdzić',
                      style: const TextStyle(fontSize: 16), // Ustaw kolor tekstu na biały
                    ),
                    const SizedBox(height: 120), // Przesunięcie do dołu, aby suwak był widoczny
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0), // Dodaj padding do boków
                      child: RotatedBox(
                        quarterTurns: 3, // Obróć suwak o 270 stopni
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 60.0, // Grubość ścieżki
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 40.0), // Utrzymano wąski uchwyt
                          ),
                          child: Slider(
                            value: _sliderValue,
                            onChanged: (newValue) {
                              setState(() {
                                _sliderValue = newValue;
                                // Automatyczne potwierdzenie po przesunięciu do 100%
                                if (_sliderValue >= 100) { // Można zmienić na >= 100, aby w łatwy sposób potwierdzić
                                  _completeTask(); // Zakończ zadanie
                                }
                              });
                            },
                            min: 0,
                            max: 100,
                            divisions: 100,
                            activeColor: Colors.green,
                            inactiveColor: Colors.lightGreen[200],
                          ),
                        ),
                      ),
                    )
                  ] else ...[
                    // Animacja wyświetlania komunikatu "Zadanie zaliczone!"
                    Transform.scale(
                      scale: _animation.value,
                      child: Opacity(
                        opacity: 1.0,
                        child: const Text(
                          'Zadanie zaliczone!',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white), // Ustaw kolor tekstu na biały
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Wyświetl wiadomość o punktach, jeśli zadanie jest zakończone
                    if (_showPointsMessage)
                      const Text(
                        'Otrzymujesz 10 punktów',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Ustaw kolor tekstu na biały
                      ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}//