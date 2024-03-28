import 'package:filmhelper/camera.dart';
import 'package:flutter/material.dart';
//import 'package:super_tooltip/super_tooltip.dart';

class BeginnerPage extends StatefulWidget {
  @override
  _BeginnerPageState createState() => _BeginnerPageState();
}

class _BeginnerPageState extends State<BeginnerPage> {
  int _selectedFocusGroup1 = -1;
  int _selectedFocusGroup2 = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Center(
                child: Align(
                  alignment: Alignment.topRight,
                  child: InfoButton(),
                ),
              ),
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
        backgroundColor: selected ? Theme.of(context).primaryColor : null,
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

class InfoButton extends StatefulWidget {
  const InfoButton({super.key});

  @override
  State<InfoButton> createState() =>
      _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            const DisplayText();
          },
        ),
      ],
    );
  }
}

class DisplayText extends StatefulWidget {
  const DisplayText({super.key});

  @override
  State<DisplayText> createState() =>
    _DisplayTextState();
}

class _DisplayTextState extends State<DisplayText> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold (
      body: Center(
        child: Text('HELLLOOO',
        textAlign: TextAlign.right
        )
        )
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