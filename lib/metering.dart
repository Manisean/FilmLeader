import 'package:flutter/material.dart';

import 'list_wheel.dart';



class MeterPage extends StatelessWidget {
  final List<dynamic> metered;
  const MeterPage({super.key, required this.metered});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Page'),
      ),
      body: Meter(metered: metered),
    );
  }
}

class Meter extends StatefulWidget {
  final List<dynamic> metered;
  const Meter({super.key, required this.metered});

  @override
  State<Meter> createState() => _MeterState();
}

class _MeterState extends State<Meter> {
  var fullStopShutter = [30, 15, 8, 4, 2, 1, 0.5, 0.25, 0.125, 0.066, 0.033, 0.0166, 0.008, 0.004, 0.002, 0.001, 0.0005, 0.00025, 0.000125];
  var fullStopAperture = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11.0, 16.0, 22.0, 32.0];
  var fullStopISO = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400];
  int currentSetting = 0;
  bool isScrolling = false;




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
    List<num> greater;
    List<num> lesser;

    for (var i = 0; i < values.length; i++) {
      if (i == 0) {
        greater = fullStopShutter.where((val) => val >= values[i]).toList()..sort();
        lesser = fullStopShutter.where((e) => e <= values[i]).toList()..sort();
        values[i] = capture(values[i], greater, lesser);

      } else if (i == 1) {
        greater = fullStopAperture.where((val) => val >= values[i]).toList()..sort();
        lesser = fullStopAperture.where((e) => e <= values[i]).toList()..sort();
        values[i] = capture(values[i], greater, lesser);

      } else if (i == 2) {
        greater = fullStopISO.where((val) => val >= values[i]).toList()..sort();
        lesser = fullStopISO.where((e) => e <= values[i]).toList()..sort();
        values[i] = capture(values[i], greater, lesser);
      }
    }
  }

  FixedExtentScrollController scrollController1 = FixedExtentScrollController(initialItem: 3);
  FixedExtentScrollController scrollController2 = FixedExtentScrollController(initialItem: 15);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> values = widget.metered;
    //List<dynamic> values = [0.004001802, 1.85, 46];

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

    int findShutter = fullStopShutter.indexOf(values[0]);
    int findAp = fullStopAperture.indexOf(values[1]);

    scrollController2 = FixedExtentScrollController(initialItem: findShutter);
    scrollController1 = FixedExtentScrollController(initialItem: findAp);

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
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // Add horizontal padding
              child: Text(
                // Shutter data is x/y = d, do the math for a decimal (d)
                // 1/d = f, the denominator for the fractions (f) of a second
                // display 1/f for traditional shutter speed format
                'S      F/      ISO\n$values\n',
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 200,
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
                        print(indexDifference);
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
                      childCount: fullStopShutter.length,
                      builder: (context, index) {
                        return Wheel(
                          wheel: fullStopShutter[index],
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: 200,
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
