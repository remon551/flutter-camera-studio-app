import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveImageScreen extends StatefulWidget {
  const SaveImageScreen({super.key, required this.image});
  final XFile image;

  @override
  State<SaveImageScreen> createState() => _SaveImageScreenState();
}

class _SaveImageScreenState extends State<SaveImageScreen> {
  final String path = '/storage/emulated/0/camera studio/';
  Future<void> saveImage(XFile imageFile) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }

    // Directory? externalStorage = await getExternalStorageDirectory();
    Directory dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create();
    }

    final savedImage = File('$path${imageFile.name}');
    // Copy the image file to the new location
    await savedImage.writeAsBytes(await imageFile.readAsBytes());

    log('Image saved to: ${savedImage.path}');
  }

  @override
  void initState() {
    saveImage(widget.image);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 30,
        centerTitle: true,
        title: const Text('Camera Studio'),
        backgroundColor: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.file(File(widget.image.path), fit: BoxFit.cover, width: 250),
          const SizedBox(height: 24),
          Text(widget.image.name)
        ]),
      ),
    );
  }
}
