import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';

import 'screen/camera_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(title: "Hello"),
    ),
  );
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
  Uint8List? _processedImage;

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

  Future<void> getGrayImage() async {
    try{
      final Uint8List result = await _channel.invokeMethod("grayimage", {});

      setState(() {
        _processedImage = result;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
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
          children: [
            _processedImage != null 
                ? Image.memory(_processedImage!) 
                : const SizedBox(height: 128, child: CircularProgressIndicator(),),

            ElevatedButton(
              onPressed: () async {
                await getGrayImage();
              },
              child: const Text('Send Image to C++'),
            ),
          ],
        ),
      ),
    );
  }
}
