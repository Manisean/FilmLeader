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
  var fullStopShutter = [30, 15, 8, 4, 2, 1, 0.5, 0.25, 0.125, 0.066, 0.033, 0.016, 0.008, 0.004, 0.002, 0.001, 0.0005, 0.00025, 0.000125];
  var fullStopAperature = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11.0, 16.0, 22.0, 32.0];
  var fullStopISO = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400];
  int currentSetting = 0;
  bool isScrolling = false;

  FixedExtentScrollController scrollController1 = FixedExtentScrollController(initialItem: 3);
  FixedExtentScrollController scrollController2 = FixedExtentScrollController(initialItem: 15);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> values = widget.metered;

    print('Values array: $values');

    values[0] = values[0].toString().split('/').map((value) => double.parse(value)).reduce((a, b) => a / b);
    values[1] = values[1].toString().split('/').map((value) => double.parse(value)).reduce((a, b) => a / b);

    print('Values array: $values');

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
                      childCount: fullStopAperature.length,
                      builder: (context, index) {
                        return Wheel(
                          wheel: fullStopAperature[index],
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
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
