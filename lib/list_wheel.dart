import 'package:flutter/material.dart';

class Wheel extends StatelessWidget {
  var wheel;

  Wheel({required this.wheel});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onBackground;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: Center(
          child: Text(
            wheel.toString(),
            style: TextStyle(
              fontSize: 30,
              color: textColor, // Use textColor instead of Colors.black
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}