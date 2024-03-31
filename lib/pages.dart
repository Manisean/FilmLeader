import 'package:filmhelper/camera.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

class BeginnerPage extends StatefulWidget {
  @override
  _BeginnerPageState createState() => _BeginnerPageState();
}

class _BeginnerPageState extends State<BeginnerPage> {
  late int _selectedFocusGroup1 = -1;
  late int _selectedFocusGroup2 = -1;

  @override
  void initState() {
    super.initState();
    _selectedFocusGroup1 = selectedFocusGroup1;
    _selectedFocusGroup2 = selectedFocusGroup2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );

              if (result != null && result is Map<String, int?>) {
                setState(() {
                  _selectedFocusGroup1 = result['selectedFocusGroup1'] ?? -1;
                  _selectedFocusGroup2 = result['selectedFocusGroup2'] ?? -1;
                });
              }
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
                child: Column(
                  children: [
                    Text(
                      'What do you want your photo to look like?\n',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Use the global variables directly in your UI
            for (int i = 0; i < 3; i++)
              FocusOption(
                key: ValueKey<int>(i),
                index: i,
                label: ['Little in Focus', 'Some in Focus', 'Lots in Focus'][i],
                selected: selectedFocusGroup1 == i,
                onSelect: () {
                  setState(() {
                    selectedFocusGroup1 = i;
                  });
                },
              ),
            const SizedBox(height: 20),
            for (int i = 0; i < 3; i++)
              FocusOption(
                key: ValueKey<int>(i + 3),
                index: i + 3,
                label: ['Little Blur', 'Some Blur', 'Lots of Blur'][i],
                selected: selectedFocusGroup2 == i,
                onSelect: () {
                  setState(() {
                    selectedFocusGroup2 = i;
                  });
                },
              ),
            ElevatedButton(
              onPressed: (selectedFocusGroup1 != -1 && selectedFocusGroup2 != -1)
                  ? () {
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