import 'dart:math';

import 'package:filmhelper/settings.dart';
import 'package:flutter/material.dart';
import 'list_wheel.dart';

class MeterPage extends StatelessWidget {
  final List<dynamic> metered;
  final int newISO;
  final String selectedFilm;

  const MeterPage(
      {super.key,
      required this.metered,
      required this.newISO,
      required this.selectedFilm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Meter(metered: metered, newISO: newISO, selectedFilm: selectedFilm),
    );
  }
}

class Meter extends StatefulWidget {
  final List<dynamic> metered;
  final int newISO;
  final String selectedFilm;

  const Meter(
      {super.key,
      required this.metered,
      required this.newISO,
      required this.selectedFilm});

  @override
  State<Meter> createState() => _MeterState();
}

class _MeterState extends State<Meter> {
  var fullStopShutter = [
    30,
    15,
    8,
    4,
    2,
    1,
    0.5,
    0.25,
    0.125,
    0.066,
    0.033,
    0.0166,
    0.008,
    0.004,
    0.002,
    0.001,
    0.0005,
    0.00025,
    0.000125
  ];
  var fullStopShutterScreen = [
    '30',
    '15',
    '8',
    '4',
    '2',
    '1',
    '1/2',
    '1/4',
    '1/8',
    '1/15',
    '1/30',
    '1/60',
    '1/125',
    '1/250',
    '1/500',
    '1/1000',
    '1/2000',
    '1/4000',
    '1/8000'
  ];
  var fullStopAperture = [
    1.0,
    1.4,
    2.0,
    2.8,
    4.0,
    5.6,
    8.0,
    11.0,
    16.0,
    22.0,
    32.0
  ];
  var fullStopISO = [25, 50, 100, 200, 400, 800, 1600, 3200];
  bool isScrolling = false;
  static const int aperturePriority = 1;
  late int priority;

  num recFailure(num shutter) {
    if (shutter > 1) {
      return (pow(shutter, 1.3)).round();
    } else {
      return 0;
    }
  }

  int prioritySet(int preference) {
    if (preference >= 0 && preference <= 3) {
      return 0;
    } else {
      return 1;
    }
  }

  num capture(num value, List<num> greater, List<num> lesser) {
    var compG = greater.first - value;
    var compL = lesser.last - value;

    if (compG.abs() < compL.abs()) {
      return greater.first;
    } else if (compL.abs() < compG.abs()) {
      return lesser.last;
    } else if (compG.abs() == 0 && compL.abs() == 0) {
      return greater.first;
    } else {
      return 0;
    }
  }

  void roundCapture(List<dynamic> values) {
    for (int i = 0; i < values.length; i++) {
      List<num> fullStopValues = [];

      if (i == 0) {
        fullStopValues = fullStopShutter.cast<num>();
      } else if (i == 1) {
        fullStopValues = fullStopAperture.cast<num>();
      } else if (i == 2) {
        fullStopValues = fullStopISO.cast<num>();
      }
      // Find the nearest full-stop value for the current value
      values[i] = fullStopValues.reduce(
          (a, b) => (a - values[i]).abs() < (b - values[i]).abs() ? a : b);
    }
  }

  double adjustShutter(List<dynamic> values, int diffIndex, int oldISO) {
    int apertureIndex = 1;
    int adjuster = fullStopShutter.indexOf(values[priority]);

    double modISO = calculateModISO(diffIndex, oldISO.toDouble());
    double priorityValues = values[priority] * sqrt(oldISO / modISO);

    if (priorityValues > fullStopShutter.first) {
      values[apertureIndex] = fullStopAperture[fullStopAperture.indexOf(values[apertureIndex]) - (adjuster + diffIndex)];

    } else if (priorityValues < fullStopShutter.last){
      adjuster = (fullStopShutter.indexOf(fullStopShutter.last) - adjuster) + diffIndex;
      values[apertureIndex] = fullStopAperture[fullStopAperture.indexOf(values[apertureIndex]) - adjuster];
    }
    return priorityValues;
  }

  double adjustAperture(List<dynamic> values, int diffIndex, int newISO, int oldISO) {
    int shutterIndex = 0;
    int adjuster = fullStopAperture.indexOf(values[priority]);

    double modISO = newISO.toDouble();
    double priorityValues = values[priority] * sqrt(modISO / oldISO);

    if (priorityValues < fullStopAperture.first) {
      adjuster = adjuster - diffIndex;
      values[shutterIndex] = fullStopShutter[fullStopShutter.indexOf(values[shutterIndex]) + adjuster];

    } else if (priorityValues > fullStopAperture.last) {
      adjuster = (fullStopAperture.indexOf(fullStopAperture.last) - adjuster) + diffIndex;
      values[shutterIndex] = fullStopShutter[fullStopShutter.indexOf(values[shutterIndex]) - adjuster];
    }
    return priorityValues;
  }

  double calculateModISO(int diffIndex, double modISO) {
    num multiplier = (diffIndex < 0) ? 4 : 0.25;
    for (int i = 0; i < diffIndex.abs(); i++) {
      modISO *= multiplier;
    }
    return modISO;
  }

  // Method to calculate new value for shutter speed or aperture based on selected ISO
  double adjustValueFullStop(List<dynamic> values, int oldISO, int newISO) {
    // Calculate new value based on the inverse square law
    print("imported ISO adjust function: $newISO");
    int oldISOIndex = fullStopISO.indexOf(oldISO);
    int newISOIndex = fullStopISO.indexOf(newISO);
    int diffIndex = oldISOIndex - newISOIndex;

    if (priority == 0) {
      return adjustShutter(values, diffIndex, oldISO);
    } else{
      return adjustAperture(values, diffIndex, newISO, oldISO);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> values = widget.metered;
    String alertMsg = "";

    //print('Values array: $values');

    for (var i = 0; i < 2; i++) {
      values[i] = values[i]
          .toString()
          .split('/')
          .map((value) => double.parse(value))
          .reduce((a, b) => a / b);
    }

    //print('Values array: $values');

    for (var i = 0; i < 3; i++) {
      values[i] = values[i].toString();
      values[i] = double.parse(values[i]);
    }

    roundCapture(values);
    //print('Values array: $values');

    //newISO is the iso speed the user selects (when that page is implemented
    int newISO = widget.newISO;
    //print('imported ISO: ' + widget.newISO.toString());
    priority = aperturePriority;
    values[priority] = adjustValueFullStop(values, values[2], newISO);

    roundCapture(values);
    values[2] = newISO;
    //print('post iso values array: $values');

    int findShutter = fullStopShutter.indexOf(values[0]);
    int findAp = fullStopAperture.indexOf(values[1]);

    FixedExtentScrollController scrollController1 = FixedExtentScrollController(initialItem: findShutter);
    FixedExtentScrollController scrollController2 = FixedExtentScrollController(initialItem: findAp);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Meter \n',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 145,
                    height: 600,
                    child: ListWheelScrollView.useDelegate(
                      //onSelectedItemChanged: (value) => print(value),
                      itemExtent: 60,
                      perspective: 0.005,
                      useMagnifier: true,
                      magnification: 1.5,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      controller: scrollController1..addListener(() {
                        if (!isScrolling) {
                          isScrolling = true;
                          final int indexDifference = scrollController1.initialItem - scrollController1.selectedItem;
                          scrollController2.animateToItem(
                            scrollController2.initialItem + indexDifference,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 100),
                          ).whenComplete(() {
                            isScrolling = false;
                          });
                        }
                      }),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: fullStopShutter.length,
                        builder: (context, index) {
                          return Wheel(
                            wheel: fullStopShutterScreen[index],
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 150,
                    height: 600,
                    child: ListWheelScrollView.useDelegate(
                      //onSelectedItemChanged: (value) => print(value),
                      itemExtent: 60,
                      perspective: 0.005,
                      useMagnifier: true,
                      magnification: 1.5,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      controller: scrollController2..addListener(() {
                        if (!isScrolling) {
                          isScrolling = true;
                          final int indexDifference = scrollController2.initialItem - scrollController2.selectedItem;
                          scrollController1.animateToItem(
                            scrollController1.initialItem + indexDifference,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: 100),
                          ).whenComplete(() {
                            isScrolling = false;
                          });
                        }
                      }),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: fullStopAperture.length,
                        builder: (context, index) {
                          return Wheel(
                            wheel: fullStopAperture[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                if (recFailure(fullStopShutter[scrollController1.selectedItem]) == 0) {
                  alertMsg = "Reciprocity failure has not set in";
                } else if (recFailure(fullStopShutter[scrollController1.selectedItem]) != 0) {
                  alertMsg = "It's recommended to manually adjust the shutter speed on your camera to "
                      "${recFailure(fullStopShutter[scrollController1.selectedItem])} seconds to account for reciprocity failure";
                }

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"))
                    ],
                    contentPadding: const EdgeInsets.all(20.0),
                    content: Text(alertMsg),
                  ),
                );
              },
              child: Text('Submit Selection'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
