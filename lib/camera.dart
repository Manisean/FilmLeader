import 'dart:developer';
import 'dart:io';
import 'package:filmhelper/main.dart';
import 'package:filmhelper/preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:exif/exif.dart';
import 'package:permission_handler/permission_handler.dart';


class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
      ),
      body: Camera(),
    );
  }
}

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late CameraController _controller;

  File? _imageFile;
  List<File> allFileList = [];

  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    // TODO: implement initState
    getPermissionStatus();
    super.initState();
  }

  camSetup() {
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.max,

    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("camera does not have access");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      camSetup();
      refreshAlreadyCapturedImages();
    } else {
      log('Camera Permission: DENIED');
    }
  }



  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];

    fileList.forEach((file) {
      if (file.path.contains('.jpg')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: int.parse(name), 1: file.path.split('/').last});
      }
    });

    if (fileNames.isNotEmpty) {
      final recentFile =
      fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      _imageFile = File('${directory.path}/$recentFileName');

      setState(() {});
    }
  }


  Future<XFile?> takePicture() async {
    final CameraController cameraController = _controller;
    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraPermissionGranted
      ? Stack(
        children: [
          Container(
            height: double.infinity,
            child: Stack(
              children: [
                CameraPreview(_controller),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    8.0,
                    16.0,
                    8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              XFile? rawImage = await takePicture();
                              File imageFile = File(rawImage!.path);

                              int currentUnix = DateTime.now().millisecondsSinceEpoch;

                              final directory = await getApplicationDocumentsDirectory();

                              String fileFormat = imageFile.path.split('.').last;

                              //print(fileFormat);

                              await imageFile.copy(
                                '${directory.path}/$currentUnix.$fileFormat',
                              );

                              printPicInfo('${directory.path}/$currentUnix.$fileFormat');

                              refreshAlreadyCapturedImages();
                            },
                          ),
                          InkWell(
                            onTap: _imageFile != null ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PreviewScreen(
                                        imageFile: _imageFile!,
                                        fileList: allFileList,
                                      ),
                                ),
                              );
                            }
                                : null,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                image: _imageFile != null
                                    ? DecorationImage(
                                  image:
                                  FileImage(_imageFile!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      )
                    ]
                  ),
                ),
              ]
            ),
          )
        ]
      )
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(),
          const Text(
            'Permission denied',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              getPermissionStatus();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Give permission',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  printPicInfo(String path) async {
    final fileBytes = File(path).readAsBytesSync();
    final data = await readExifFromBytes(fileBytes);
    print("BITCH");
    if (data.isEmpty) {
      print("No EXIF information found");
      return;
    }

    data.forEach((key, value) {
      if (key == "EXIF ExposureTime") {
        print((key,value));
      } else if (key == "EXIF FNumber") {
        print((key,value));
      } else if (key == "EXIF ISOSpeedRatings") {
        print((key,value));
      }

    });
    print('----------------------------------');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
