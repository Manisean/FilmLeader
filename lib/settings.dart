// import 'package:filmhelper/pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

int selectedFocusGroup1 = -1;
int selectedFocusGroup2 = -1;



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
  /*int _selectedFocusGroup1 = -1;
  int _selectedFocusGroup2 = -1;

  String _selectedFocusGroup1Text = '';
  String _selectedFocusGroup2Text = '';*/
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    //_selectedFocusGroup1 = selectedFocusGroup1;
    //_selectedFocusGroup2 = selectedFocusGroup2;
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
                  Text(
                    'Dark Mode  ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: _isDarkMode ?? false,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value; // Update local state
                        _saveDarkModeState(value); // Save state to shared preferences
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setDarkMode(value); // Notify ThemeNotifier
                      });
                    },
                  ),
                  /*
                  DropdownButton<int>(
                    value: _selectedFocusGroup1,
                    hint: Text(_selectedFocusGroup1Text.isNotEmpty ? _selectedFocusGroup1Text : 'Select Focus'),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _selectedFocusGroup1 = value;
                          _selectedFocusGroup1Text = ['Little in Focus', 'Some in Focus', 'Lots in Focus'][value];
                        });
                      }
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: -1,
                        child: Text('Select Option'),
                      ),
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text('Little in Focus'),
                      ),
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Some in Focus'),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text('Lots in Focus'),
                      ),
                    ],
                  ),
                  const Center(
                    child: Text(
                      'MOVEMENT BLUR',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton<int>(
                    value: _selectedFocusGroup2,
                    hint: Text(_selectedFocusGroup2Text.isNotEmpty ? _selectedFocusGroup2Text : 'Select Blur'),
                    onChanged: (int? value) {
                      if (value != null) {
                      setState(() {
                        _selectedFocusGroup2 = value;
                        _selectedFocusGroup2Text = ['Little Blur', 'Some Blur', 'Lots of Blur'][value];
                      });
                      }
                    },
                    items: [
                      DropdownMenuItem<int>(
                        value: -1,
                        child: Text('Select Option'),
                      ),
                      DropdownMenuItem<int>(
                        value: 0,
                        child: Text('Little Blur'),
                      ),
                      DropdownMenuItem<int>(
                        value: 1,
                        child: Text('Some Blur'),
                      ),
                      DropdownMenuItem<int>(
                        value: 2,
                        child: Text('Lots of Blur'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      selectedFocusGroup1 = _selectedFocusGroup1;
                      selectedFocusGroup2 = _selectedFocusGroup2;
                    },
                    child: Text('Save Preferences'),
                  ),*/
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