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
  var fullStopISO = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400];
  //Which setting is being prioritized
  // 0 = setting iso will preserve aperture value
  // 1 = setting iso will preserve shutter speed value
  int priority = 1;
  late int blur;
  late int focus;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    List<dynamic> values = widget.metered;
    values[2] = values[2].toString();
    values[2] = int.parse(values[2]);

    int findISO = fullStopISO.indexOf(values[2]);

    FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: findISO);

    int newISO = fullStopISO[scrollController.initialItem];

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
                    itemExtent: 60,
                    perspective: 0.005,
                    useMagnifier: true,
                    magnification: 1.5,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    controller: scrollController..addListener(() {
                      newISO = fullStopISO[scrollController.selectedItem];
                      print(newISO);
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
                      context,
                      MaterialPageRoute(builder: (context) => MeterPage(metered: widget.metered, newISO: newISO)),
                    );
                  },
                  child: Text('Select'),
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
