import 'dart:math';

import 'package:filmhelper/settings.dart';
import 'package:flutter/material.dart';
import 'list_wheel.dart';


class MeterBeginPage extends StatelessWidget {
  final List<dynamic> metered;
  final int newISO;
  final String selectedFilm;
  final int selectedPreference;
  const MeterBeginPage({super.key, required this.metered, required this.newISO, required this.selectedFilm, required this.selectedPreference, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Page'),
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
      body: Meter(metered: metered, newISO: newISO, selectedFilm: selectedFilm, selectedPreference: selectedPreference, ),
    );
  }
}

class Meter extends StatefulWidget {
  final List<dynamic> metered;
  final int newISO;
  final String selectedFilm;
  final int selectedPreference;
  const Meter({super.key, required this.metered, required this.newISO, required this.selectedFilm, required this.selectedPreference});

  @override
  State<Meter> createState() => _MeterState();
}


class _MeterState extends State<Meter> {
  var fullStopShutter = [30, 15, 8, 4, 2, 1, 0.5, 0.25, 0.125, 0.066, 0.033, 0.0166, 0.008, 0.004, 0.002, 0.001, 0.0005, 0.00025, 0.000125];
  var fullStopShutterScreen = ['30', '15', '8', '4', '2', '1', '1/2', '1/4', '1/8', '1/15', '1/30', '1/60', '1/125', '1/250', '1/500', '1/1000', '1/2000', '1/4000', '1/8000'];
  var fullStopAperture = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11.0, 16.0, 22.0, 32.0];
  var fullStopISO = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400];
  bool isScrolling = false;
  //Which setting is being prioritized
  // 0 = setting iso will preserve aperture value
  // 1 = setting iso will preserve shutter speed value
  late int priority;
  late int preference;

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
      values[i] = fullStopValues.reduce((a, b) =>
      (a - values[i]).abs() < (b - values[i]).abs() ? a : b);
    }
  }


  // Method to calculate new value for shutter speed or aperture based on selected ISO
  double adjustValueFullStop(List<dynamic> values, int oldISO, int newISO) {
    // Calculate new value based on the inverse square law

    int oldISOIndex = fullStopISO.indexOf(oldISO);
    int newISOIndex = fullStopISO.indexOf(newISO);

    print('INDEX OF OLD ISO: $oldISOIndex');
    print('INDEX OF NEW ISO: $newISOIndex');

    int diffIndex = oldISOIndex - newISOIndex;

    print('INDEX DIFFERENCE: $diffIndex');

    if(priority == 0) { //shutter
      int posIndex = diffIndex.abs();
      newISO = oldISO;

      if (diffIndex < 0) {
        for (int i = 0; i < posIndex; i++) {
          newISO *= 4;
          print('CONVERTED ISO GREATER: $newISO');
        }
      } else {
        for (int i = 0; i < posIndex; i++) {
          newISO ~/= 4;
          print('CONVERTED ISO LESSER: $newISO');
        }
      }

      double newValue = values[priority] * sqrt(oldISO / newISO);
      print('NEW VALUE $newValue');
      if (newValue > fullStopShutter.first) {
        int adjuster = fullStopShutter.indexOf(values[priority]) + diffIndex;
        print('INDEX OF OVERFLOW: $adjuster');
        values[1] = fullStopAperture[fullStopAperture.indexOf(values[1]) - adjuster];
      } else if (newValue < fullStopShutter.last){
        int adjuster = (fullStopShutter.indexOf(fullStopShutter.last) - fullStopShutter.indexOf(values[priority])) + diffIndex;
        print('INDEX OF OVERFLOW: $adjuster');
        values[1] = fullStopAperture[fullStopAperture.indexOf(values[1]) - adjuster];
      } else {

      }
      return values[priority] * sqrt(oldISO / newISO);
    } else { //aperture
      double newValue = values[priority] * sqrt(newISO / oldISO);
      if (newValue < fullStopAperture.first) {
        int adjuster = fullStopAperture.indexOf(values[priority]) - diffIndex;
        print('INDEX OF OVERFLOW: $adjuster');
        values[0] = fullStopShutter[fullStopShutter.indexOf(values[0]) + adjuster];
      } else if (newValue > fullStopAperture.last) {
        int adjuster = (fullStopAperture.indexOf(fullStopAperture.last) - fullStopAperture.indexOf(values[priority])) + diffIndex;
        print('INDEX OF OVERFLOW: $adjuster');
        values[0] = fullStopShutter[fullStopShutter.indexOf(values[0]) - adjuster];
      }
      return values[priority] * sqrt(newISO / oldISO);
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

    print('Values array: $values');

    values[0] = values[0].toString().split('/').map((value) => double.parse(value)).reduce((a, b) => a / b);
    values[1] = values[1].toString().split('/').map((value) => double.parse(value)).reduce((a, b) => a / b);

    print('Values array: $values');

    values[0] = values[0].toString();
    values[1] = values[1].toString();
    values[2] = values[2].toString();

    values[0] = double.parse(values[0]);
    values[1] = double.parse(values[1]);
    values[2] = double.parse(values[2]);

    roundCapture(values);
    print('Values array: $values');

    //newISO is the iso speed the user selects (when that page is implemented
    int newISO = widget.newISO;
    print('imported ISO: ' + widget.newISO.toString());

    // TEMP VALUE FOR TESTING
    //values[1] = 32.0;
    preference = widget.selectedPreference;
    priority = prioritySet(preference);
    values[priority] = adjustValueFullStop(values, values[2], newISO);


    roundCapture(values);
    values[2] = newISO;
    print('post iso values array: $values');

    int findShutter = fullStopShutter.indexOf(values[0]);
    int findAp = fullStopAperture.indexOf(values[1]);
    //int findISO = fullStopISO.indexOf(values[2]);

    FixedExtentScrollController scrollController1 = FixedExtentScrollController(initialItem: findShutter);
    FixedExtentScrollController scrollController2 = FixedExtentScrollController(initialItem: findAp);
    //FixedExtentScrollController scrollController3 = FixedExtentScrollController(initialItem: findISO);
    //late FixedExtentScrollController targetController;

    switch (preference) {
      case 1:
        if (findAp > 4) {
          int difference = findAp - 2;
          scrollController2 = FixedExtentScrollController(initialItem: findAp - difference);
          scrollController1 = FixedExtentScrollController(initialItem: findShutter + difference);
        }
        break;
      case 2:
        if (findAp < 5 || findAp > 7) {
          int difference = findAp - 6;
          scrollController2 = FixedExtentScrollController(initialItem: findAp - difference);
          scrollController1 = FixedExtentScrollController(initialItem: findShutter + difference);
        }
        break;
      case 3:
        if (findAp < 8) {
          int difference = findAp - 9;
          scrollController2 = FixedExtentScrollController(initialItem: findAp - difference);
          scrollController1 = FixedExtentScrollController(initialItem: findShutter + difference);
        }
        break;
      case 4:
        if (findShutter < 12) {
          int difference = findShutter - 14;
          scrollController1 = FixedExtentScrollController(initialItem: findShutter - difference);
          scrollController2 = FixedExtentScrollController(initialItem: findAp + difference);
        }
        break;
      case 5:
        if (findShutter < 8 || findShutter > 11) {
          int difference = findShutter - 9;
          scrollController1 = FixedExtentScrollController(initialItem: findShutter - difference);
          scrollController2 = FixedExtentScrollController(initialItem: findAp + difference);
        }
        break;
      case 6:
        if (findShutter > 7) {
          int difference = findShutter - 5;
          scrollController1 = FixedExtentScrollController(initialItem: findShutter - difference);
          scrollController2 = FixedExtentScrollController(initialItem: findAp + difference);
        }
        break;
      default:
        scrollController1 = FixedExtentScrollController(initialItem: findShutter);
        scrollController2 = FixedExtentScrollController(initialItem: findAp);
        break;
    }


    // if(priority == 0) {
    //   targetController = scrollController1;
    // } else if(priority == 1) {
    //   targetController = scrollController2;
    // }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              // Add horizontal padding
              child: Text(
                // Shutter data is x/y = d, do the math for a decimal (d)
                // 1/d = f, the denominator for the fractions (f) of a second
                // display 1/f for traditional shutter speed format
                'S      F/      ISO\n$values\n',
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 125,
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
                  SizedBox(
                    width: 125,
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
            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Close")
                              )
                            ],
                            contentPadding: const EdgeInsets.all(20.0),
                            content: Text("TEMP"),
                          ),
                        );
                      },
                      child: Icon(Icons.info),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Close")
                                )
                              ],
                              contentPadding: const EdgeInsets.all(20.0),
                              content: Text("TEMP"),
                            ),
                          );
                        },
                        child: Icon(Icons.info),
                      ),
                    ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {

                if (recFailure(fullStopShutter[scrollController1.selectedItem]) == 0) {
                  alertMsg = "Reciprocity failure has not set in, please try different settings";
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
                          child: const Text("Close")
                      )
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

