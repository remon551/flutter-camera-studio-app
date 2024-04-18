import 'package:camera/camera.dart';
import 'package:camera_studio/Screens/camera_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  runApp(
    CameraStudioApp(
      cameras: cameras,
    ),
  );
}

class CameraStudioApp extends StatelessWidget {
  const CameraStudioApp({super.key, required this.cameras});
  final List<CameraDescription>? cameras;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: CameraScreen(
        cameras: cameras,
      ),
    );
  }
}
