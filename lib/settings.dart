import 'package:filmhelper/pages.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  int _selectedFocusGroup1 = -1;
  int _selectedFocusGroup2 = -1;

  String _selectedFocusGroup1Text = '';
  String _selectedFocusGroup2Text = '';

  @override
  void initState() {
    super.initState();
    _selectedFocusGroup1 = PreferencesManager.selectedFocusGroup1;
    _selectedFocusGroup2 = PreferencesManager.selectedFocusGroup2;
  }

  void _updatePreferences() {
    PreferencesManager.setSelectedFocusGroup1(_selectedFocusGroup1);
    PreferencesManager.setSelectedFocusGroup2(_selectedFocusGroup2);
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
                children: [
                  const Center(
                    child: Text(
                      'FOCUS',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton<int>(
                    value: 0,
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
                    value: 0,
                    hint: Text(_selectedFocusGroup2Text.isNotEmpty ? _selectedFocusGroup2Text : 'Select Blur'),
                    onChanged: (int? value) {
                      if (value != null) {
                      setState(() {
                        _selectedFocusGroup2Text = ['Little Blur', 'Some Blur', 'Lots of Blur'][value];
                      });
                      }
                    },
                    items: [
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}