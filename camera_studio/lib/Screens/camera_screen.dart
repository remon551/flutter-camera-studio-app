import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:camera_studio/Screens/edit_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.cameras});

  final List<CameraDescription>? cameras;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool flash = false;
  late CameraController _controller;
  bool _isRearCameraSelected = true;

  Future initCamera(CameraDescription cameraDescription) async {
    // create a CameraController
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    // Next, initialize the controller. This returns a Future.
    try {
      await _controller.initialize().then(
        (_) {
          if (!mounted) return;
          setState(() {});
        },
      );
    } on CameraException catch (e) {
      log("camera error $e");
    }
  }

  Future takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }
    if (_controller.value.isTakingPicture) {
      return null;
    }
    try {
      FlashMode flashMode = flash ? FlashMode.always : FlashMode.off;
      await _controller.setFlashMode(flashMode);
      XFile picture = await _controller.takePicture();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return EditImageScreen(originalImage: picture);
          },
        ),
      );
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    // this line hides status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);

    initCamera(widget.cameras![0]);
  }

  @override
  void dispose() {
    // this line return status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values); // to re-show bars

    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   toolbarHeight: 30,
      //   centerTitle: true,
      //   title: const Text(
      //     'Camera Studio',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: Colors.black,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.vertical(
      //       bottom: Radius.circular(30),
      //     ),
      //   ),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized
              ? CameraPreview(_controller)
              : const Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Color.fromARGB(176, 0, 0, 0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(
                          () => _isRearCameraSelected = !_isRearCameraSelected);
                      initCamera(
                          widget.cameras![_isRearCameraSelected ? 0 : 1]);
                    },
                    icon: Icon(_isRearCameraSelected
                        ? Icons.switch_camera
                        : Icons.switch_camera_outlined),
                    color: Colors.white,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: takePicture,
                          customBorder: const CircleBorder(),
                          child: Ink(
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => flash = !flash);
                    },
                    icon: Icon(flash ? Icons.flash_on : Icons.flash_off),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
