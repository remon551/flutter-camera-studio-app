import 'dart:typed_data';
import 'package:camera/camera.dart';

import 'package:camera_studio/cubit/filter_cubit.dart';
import 'package:camera_studio/cubit/filter_states.dart';
import 'package:camera_studio/widgets/edit_image_widget_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class EditImageScreen extends StatefulWidget {
  EditImageScreen({super.key, required this.originalImage});
  XFile originalImage;
  late img.Image editedImage;
  Uint8List bytesList = Uint8List(0);

  @override
  State<EditImageScreen> createState() => _EditImageScreen();
}

class _EditImageScreen extends State<EditImageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FilterCubit(),
      child: 
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 30,
            centerTitle: true,
            title: const Text(
              'Camera Studio',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EditImageWidgetBuilder(
                  imageFile: widget.originalImage,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
