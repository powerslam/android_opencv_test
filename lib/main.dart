import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: CameraStreamScreen(
        camera: firstCamera,
      ),
    ),
  );
}

class CameraStreamScreen extends StatefulWidget {
  const CameraStreamScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  CameraStreamScreenState createState() => CameraStreamScreenState();
}

class CameraStreamScreenState extends State<CameraStreamScreen> {
  bool _isStreaming = false;
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    try {
      await _controller.initialize();
    } catch(e) {
      print('Error initializing camera: $e');
    }

    setState(() {});
  }

  void _startImageStream() {
    if(_controller.value.isInitialized && !_isStreaming) {
      _controller.startImageStream((CameraImage image) {
        // TODO: 여기에 이미지 처리 로직 추가
        print('Image Stream frame received: ${image.format.group}');
      });

      setState(() {
        _isStreaming = true;
      });
    }
  }

  void _stopImageStream() {
    if(_isStreaming) {
      _controller.stopImageStream();
      setState(() {
        _isStreaming = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Stream Example')),
      body: Column(
        children: [
          AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: _startImageStream,
                  child: const Text('Start Stream'),
              ),

              const SizedBox(width: 16),

              ElevatedButton(
                  onPressed: _stopImageStream,
                  child: const Text('Stop Stream')
              )
            ],
          )
        ],
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const MethodChannel _channel = MethodChannel('com.example.android_opencv_test');

  String _platformVersion = 'Unknown';

  int a = 0, b = 0;
  int additionResult = 0, subtractionResult = 0;

  Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<int> addition(int a, int b) async {
    return await _channel.invokeMethod("addition", <String, dynamic> {
      "a": a, "b": b
    });
  }

  Future<int> subtraction(int a, int b) async {
    return await _channel.invokeMethod("subtraction", <String, dynamic> {
      "a": a, "b": b
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Get Platform Version"),
              onPressed: () async {
                String result = await getPlatformVersion();
                setState(() {
                  _platformVersion = result;
                });
              },
            ),
            Text(_platformVersion),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("a = "),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          a = int.parse(value);
                        });
                      },
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text("b = "),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          b = int.parse(value);
                        });
                      },
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  child: Text("invoke addition"),
                  onPressed: () async {
                    int result = await addition(a, b);
                    setState(() {
                      additionResult = result;
                    });
                  },
                ),
                Text(" = $additionResult")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  child: Text("invoke subtraction"),
                  onPressed: () async {
                    int result = await subtraction(a, b);
                    setState(() {
                      subtractionResult = result;
                    });
                  },
                ),
                Text(" = $subtractionResult")
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
