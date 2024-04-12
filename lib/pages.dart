import 'package:filmhelper/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'settings.dart';


class BeginnerPage extends StatefulWidget {
  @override
  _BeginnerPageState createState() => _BeginnerPageState();
}

class _BeginnerPageState extends State<BeginnerPage> {
  late int _selectedFocusGroup1 = -1;
  late int _selectedPreferenceCalculation = -1;

  @override
  void initState() {
    super.initState();
    _selectedFocusGroup1 = selectedFocusGroup1;
    _selectedPreferenceCalculation = selectedPreferenceCalculation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner Page'),
        actions: <Widget>[
        Container(
        width: 60,
        child: TargetWidget(),
        ),
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
                  _selectedPreferenceCalculation = _selectedFocusGroup1 + 1;
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
                for (int i = 0; i < 6; i++)
                  FocusOption(
                    key: ValueKey<int>(i),
                    index: i,
                    label: [
                    'Little in Focus', 'Some in Focus', 'Lots in Focus',
                      'Little Blur', 'Some Blur', 'Lots of Blur'][i],
                    selected: _selectedFocusGroup1 == i,
                    onSelect: () {
                      setState(() {
                        _selectedFocusGroup1 = i;
                        _selectedPreferenceCalculation = _selectedFocusGroup1 + 1;
                      });
                    },
                  ),
              ]
          ),
        ),
            ElevatedButton(
              onPressed: (_selectedFocusGroup1 != -1 && _selectedPreferenceCalculation != -1) ? () {
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

class TargetWidget extends StatefulWidget {
  const TargetWidget({Key? key}) : super(key: key);
  @override
  State createState() => _TargetWidgetState();
}

class _TargetWidgetState extends State<TargetWidget> {
  final _controller = SuperTooltipController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      //onWillPop: _willPopCallback,
      child: GestureDetector(
        onTap: () async {
          await _controller.showTooltip();
        },
        child: SuperTooltip(
          showBarrier: true,
          controller: _controller,
          popupDirection: TooltipDirection.down,
          backgroundColor: Colors.black87,
          arrowTipDistance: 15.0,
          arrowBaseWidth: 20.0,
          arrowLength: 20.0,
          borderWidth: 2.0,
          constraints: const BoxConstraints(
            minHeight: 0.0,
            maxHeight: 100,
            minWidth: 0.0,
            maxWidth: 100,
          ),
          showCloseButton: ShowCloseButton.none,
          touchThroughAreaShape: ClipAreaShape.rectangle,
          touchThroughAreaCornerRadius: 30,
          barrierColor: Color.fromARGB(26, 47, 45, 47),
          content: const Text(
            "Little in Focus: Few Items will appear in focus \nSome in Focus: Some Items will appear in focus\nLots in Focus: All items will appear in focus\n"
                "\n"
                "Little Blur: Small amount of Blur \nSome Blur: Some items will be blurry\nLots of Blur: Severe blur effect",
            softWrap: true,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black87,
            ),
            child: Icon(
              Icons.info,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void makeTooltip() {
    _controller.showTooltip();
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
        backgroundColor: selected ? Theme
            .of(context)
            .primaryColor : null,
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
