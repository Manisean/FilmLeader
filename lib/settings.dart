import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light, // Default theme is light
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Dark theme
      ),
      home: MyHomePage(title: 'Home Page'),
      routes: {
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModeState();
  }

  // Load dark mode state from shared preferences
  void _loadDarkModeState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  // Save dark mode state to shared preferences
  void _saveDarkModeState(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
        Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  const Text(
                    'Dark Mode  ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value; // Update local state
                        _saveDarkModeState(value); // Save state to shared preferences
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setDarkMode(value); // Notify ThemeNotifier
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ButtonSlider extends StatefulWidget {
  @override
  _ButtonSliderState createState() => _ButtonSliderState();
}

class _ButtonSliderState extends State<ButtonSlider> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Dark Mode  ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Switch(
          value: isDarkMode,
          onChanged: (value) {
            setState(() {
              isDarkMode = value;
            });
          },
        ),
      ],
    );
  }
}