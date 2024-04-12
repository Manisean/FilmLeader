import 'dart:math';

import 'package:filmhelper/meterin_begin.dart';
import 'package:filmhelper/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'list_wheel.dart';
import 'metering.dart';



class ISOBeginPage extends StatelessWidget {
  final List<dynamic> metered;
  final int selectedGroup;
  const ISOBeginPage({super.key, required this.metered, required this.selectedGroup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meter Page'),
      ),
      body: ISO(metered: metered, selectedGroup: selectedGroup),
    );
  }
}

class ISO extends StatefulWidget {
  final List<dynamic> metered;
  final int selectedGroup;
  const ISO({super.key, required this.metered, required this.selectedGroup});

  @override
  State<ISO> createState() => _ISOState();
}


class _ISOState extends State<ISO> {
  var fullStopISO = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400];
  List<dynamic> filmList = ["Kodak Ektar", "Kodak Pro", "Kodak Chrome",
    "Fomapan", "Lomography", "Flic Chrome", "Flic Ektar",
    "Rollei RPX", "Kentmere"];
  late int newISO = 100;

  @override
  void initState() {
    super.initState();
  }

  List<String> getFilmList(int isoValue) {
    switch (isoValue) {
      case 25:
        return ["Rollei RPX", "Rollei Ortho", "Rollei Ortho+", "Kodak Ektar"];
      case 50:
        return ["Ilford Paf F+", "CineStill", "Ferrania Orto", "Fujifulm Fujichrome"];
      case 100:
        return ["Kodak Ektar", "Kodak Pro", "Kodak Chrome",
          "Fomapan", "Lomography", "Flic Chrome", "Flic Ektar",
          "Rollei RPX", "Kentmere"];
      case 200:
        return ["Kodak Gold", "Kodak Color+", "Fujifilm Fujicolor", "Arista Edu Ultra",
          "Harman Phoenix", "Foma Fomapan", "Rollei Superpan"];
      case 400:
        return ["Kodak UltraMax", "Fujifilm Superia X-TRA", "Kodak Tri-X", "LomoChrome Purple",
          "Lomography", "Lomography Berlin", "Revolog Kolor", "Rollei RPX"];
      case 800:
        return ["Kodak Portra", "Kodak Max", "Kodak Max Versa+", "Dubblefilm Cinema",
          "Lomography", "VIBE Max", "Flic Film Aurora", "CineStill"];
      case 1600:
        return ["Fujifilm Superia", "Fujifilm Natura"];
      case 3200:
        return ["Kodak Pro T-Max", "Ilford Delta"];
      case 6400:
        return [""];
      default:
        return [""];
    }
  }

  void setFilmList(List<String> list) {
    setState(() {
      filmList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> values = widget.metered;
    values[2] = values[2].toString();
    values[2] = int.parse(values[2]);

    int findISO = fullStopISO.indexOf(values[2]);

    FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: findISO);
    FixedExtentScrollController scrollController2 = FixedExtentScrollController();

    String filmSelection = "";

    return Scaffold(
      body: Center(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'ISO \n',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
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
                      width: 100,
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
                          setFilmList(getFilmList(newISO));
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
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                          width: 135,
                          height: 600,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 60,
                            perspective: 0.005,
                            useMagnifier: false,
                            diameterRatio: 1.2,
                            physics: const FixedExtentScrollPhysics(),
                            controller: scrollController2..addListener(() {
                              filmSelection = filmList[scrollController.selectedItem];
                            }),
                            childDelegate: ListWheelChildBuilderDelegate(
                                childCount: filmList.length,
                                builder: (context, index) {
                                  return Wheel(
                                    wheel: filmList[index],
                                  );
                                }
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
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
                    Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 110.0),
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
                    ),
              ],
              ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MeterBeginPage(metered: widget.metered, newISO: newISO, selectedFilm: filmSelection, selectedPreference: widget.selectedGroup,)),
                  );
                },
                child: Text('Submit ISO'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
