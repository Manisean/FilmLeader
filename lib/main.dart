import 'package:filmhelper/camera.dart';
import 'package:flutter/material.dart';
import 'pages.dart'; // Import the pages file
//import 'package:manual_camera_pro/camera.dart';
import 'package:camera/camera.dart';
import 'settings.dart';
import 'package:provider/provider.dart';


late List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(), // Create a provider for managing theme state
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.getTheme(), // Set the theme based on ThemeNotifier
          darkTheme: ThemeData.dark(), // Use built-in dark theme
          home: MyHomePage(title: 'Welcome to Light Meter!'),
          debugShowCheckedModeBanner: false,
          routes: {
            '/settings': (context) => SettingsPage(),
          },
        );
      },
    );
  }
}

// Dark Mode Settings
class ThemeNotifier extends ChangeNotifier {
  ThemeData _lightThemeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
    useMaterial3: true,
  );

  ThemeData _themeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
    useMaterial3: true,
  ); // Default theme is light

  ThemeData getTheme() => _themeData; // Getter for current theme

  void setDarkMode(bool isDarkMode) {
    _themeData = isDarkMode ? ThemeData.dark() : _lightThemeData;
    notifyListeners(); // Notify listeners that theme has changed
  }
}


//testing changes

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
              child: Text(
                'Welcome to the Light Meter App. \n',
                textAlign: TextAlign.center, // Center align the text
                style: TextStyle(
                  fontSize: 24, // Adjust the font size to make it look like a header
                  fontWeight: FontWeight.bold, // Apply bold font weight
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0), // Add horizontal padding
              child: Text(
                'Here you will select whether you are a beginner photographer and may need help figuring out what light settings you want, or you may be an expert looking for a little helping hand. \n'
                    'If you are a beginner, you will be provided with questions to help figure out the best settings for you. If you are an expert, you will be taken directly to the camera portion of this app.\n'
                    'This can be changed at any time by returning to this menu.\n',
                textAlign: TextAlign.center, // Center align the text
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BeginnerPage()),
                    );
                  },
                  child: Text('Beginner'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraPage()),
                    );
                  },
                  child: Text('Expert'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
