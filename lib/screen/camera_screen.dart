import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
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
        body: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
    );
  }
}