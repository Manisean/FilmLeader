import 'package:filmhelper/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

class PreferencesManager {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int get selectedFocusGroup1 =>
      _prefs?.getInt('selectedFocusGroup1') ?? -1;

  static int get selectedFocusGroup2 =>
      _prefs?.getInt('selectedFocusGroup2') ?? -1;

  static Future<void> setSelectedFocusGroup1(int value) async {
    await _prefs?.setInt('selectedFocusGroup1', value);
  }

  static Future<void> setSelectedFocusGroup2(int value) async {
    await _prefs?.setInt('selectedFocusGroup2', value);
  }
}

class BeginnerPage extends StatefulWidget {
  @override
  _BeginnerPageState createState() => _BeginnerPageState();
}

class _BeginnerPageState extends State<BeginnerPage> {
  late int _selectedFocusGroup1;
  late int _selectedFocusGroup2;

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
        title: Text('Beginner Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Center(
              child: Padding(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                child: Text(
                  'What do you want your photo to look like?\n',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
            Center(
              child: Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    FocusOption(
                      key: ValueKey<int>(i),
                      index: i,
                      label: ['Little in Focus', 'Some in Focus', 'Lots in Focus'][i],
                      selected: _selectedFocusGroup1 == i,
                      onSelect: () {
                        setState(() {
                          _selectedFocusGroup1 = i;
                        });
                      },
                    ),
                ],
              ),
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
            Center(
              child: Column(
                children: [
                  for (int i = 0; i < 3; i++)
                    FocusOption(
                      key: ValueKey<int>(i + 3),
                      index: i + 3,
                      label: ['Little Blur', 'Some Blur', 'Lots of Blur'][i],
                      selected: _selectedFocusGroup2 == i,
                      onSelect: () {
                        setState(() {
                          _selectedFocusGroup2 = i;
                        });
                      },
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (_selectedFocusGroup1 != -1 && _selectedFocusGroup2 != -1)
                  ? () {
                // Both groups have selections, navigate to Camera Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
              }
                  : null,
              child: Text('Go to Camera Page'),
            ),
          ],
        ),
      ),
    );
  }
}

class FocusOption extends StatelessWidget {
  final Key key;
  final int index;
  final String label;
  final bool selected;
  final VoidCallback onSelect;

  const FocusOption({
    required this.key,
    required this.index,
    required this.label,
    required this.selected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSelect,
      style: ElevatedButton.styleFrom(
        primary: selected ? Theme.of(context).primaryColor : null,
        elevation: selected ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: selected ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}


// class CameraPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Camera Page'),
//       ),
//       body: Center(
//         child: Text('This is the Camera Page'),
//       ),
//     );
//   }
// }