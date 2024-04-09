import 'dart:math';

import 'package:flutter/material.dart';

import 'list_wheel.dart';
import 'metering.dart';



class ISOPage extends StatelessWidget {
  final List<dynamic> metered;
  const ISOPage({super.key, required this.metered});

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
  bool isScrolling = false;
  //Which setting is being prioritized
  // 0 = setting iso will preserve aperture value
  // 1 = setting iso will preserve shutter speed value
  int priority = 1;
  late int blur;
  late int focus;


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
      print('bitch $newISO');
      int posIndex = diffIndex.abs();
      newISO = oldISO;

      if (diffIndex < 0) {
        for (int i = 0; i < posIndex; i++) {
          newISO *= 4;
          print('CONVERTED ISO GREATER: $newISO'); // Output: 400, 1600, 6400
        }
      } else {
        for (int i = 0; i < posIndex; i++) {
          newISO ~/= 4;
          print('CONVERTED ISO LESSER: $newISO'); // Output: 400, 1600, 6400
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

    //newISO is the iso speed the user selects (when that page is implemented
    int newISO = 200;

    // TEMP VALUE FOR TESTING
    //values[1] = 32.0;

    values[priority] = adjustValueFullStop(values, values[2], newISO);

    roundCapture(values);
    values[2] = newISO;
    print('post iso values array: $values');

    int findISO = fullStopISO.indexOf(values[2]);

    FixedExtentScrollController scrollController3 = FixedExtentScrollController(initialItem: findISO);
    late FixedExtentScrollController targetController;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'ISO \n',
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
            Row(
              children: <Widget>[

                SizedBox(
                  width: 135,
                  height: 600,
                  child: ListWheelScrollView.useDelegate(
                    //onSelectedItemChanged: (value) => print(value),
                    itemExtent: 60,
                    perspective: 0.005,
                    useMagnifier: true,
                    magnification: 1.5,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    controller: scrollController3..addListener(() {
                      isScrolling = true;
                      final int indexDifference = scrollController3.initialItem - scrollController3.selectedItem;
                    }),
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: fullStopISO.length,
                      builder: (context, index) {
                        return Wheel(
                          wheel: fullStopISO[index],
                        );
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, //.
                      MaterialPageRoute(builder: (context) => MeterPage(metered: widget.metered)),
                    );
                  },
                  child: Text('Expert'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
