import 'dart:developer';
import 'dart:io';
import 'package:filmhelper/main.dart';
import 'package:filmhelper/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:exif/exif.dart';
import 'package:permission_handler/permission_handler.dart';


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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // Add horizontal padding
              child: Text(
                'Meter \n',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(
                  fontSize: 24,
                  // Adjust the font size to make it look like a header
                  fontWeight: FontWeight.bold, // Apply bold font weight
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              // Add horizontal padding
              child: Text(
                'f/      S      ISO\n$values\n',
                textAlign: TextAlign.center, // Center align the text
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
