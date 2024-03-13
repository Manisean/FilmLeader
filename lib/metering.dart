import 'package:flutter/material.dart';



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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<dynamic> values = widget.metered;
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
