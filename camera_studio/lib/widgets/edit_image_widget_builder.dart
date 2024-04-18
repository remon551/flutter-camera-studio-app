import 'dart:io';
import 'dart:typed_data';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:camera_studio/cubit/filter_cubit.dart';
import 'package:camera_studio/cubit/filter_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:camera_studio/constants/filters_list.dart';
import 'package:permission_handler/permission_handler.dart';

class EditImageWidgetBuilder extends StatefulWidget {
  EditImageWidgetBuilder({super.key, required this.imageFile});
  final XFile imageFile;
  late Future<img.Image> image;
  late img.Image editedImage;
  late Uint8List bytes;
  late Uint8List editedBytes;
  final String path = '/storage/emulated/0/camera studio/';

  @override
  State<EditImageWidgetBuilder> createState() => _EditImageWidgetBuilderState();
}

class _EditImageWidgetBuilderState extends State<EditImageWidgetBuilder> {
  @override
  void initState() {
    super.initState();
    widget.image = getImageBytes(widget.imageFile);
  }

  void setBytesList() {
    widget.editedBytes = Uint8List.fromList(
      img.encodePng(widget.editedImage),
    );
  }

  Future<img.Image> getImageBytes(XFile picture) async {
    final path = picture.path;
    widget.bytes = await File(path).readAsBytes();
    img.Image image = img.decodeImage(widget.bytes)!;
    image = img.copyRotate(image, 90);
    widget.editedImage = img.Image.from(image);

    widget.editedBytes = Uint8List.fromList(widget.bytes);

    return image;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.image,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              BlocBuilder<FilterCubit, FilterState>(
                builder: (context, state) {
                  if (state is NoFilterState) {
                    widget.editedBytes = Uint8List.fromList(widget.bytes);
                  } else if (state is ApplayFilterState) {
                    state.filter.applyFilter(widget.editedImage);
                    setBytesList();
                    widget.editedImage = img.Image.from(snapshot.requireData);
                  }
                  return SizedBox(
                    height: 400,
                    width: 400,
                    child: Image.memory(widget.editedBytes),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(widget.imageFile.name),
              const SizedBox(height: 20),
              SizedBox(
                height: 130,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  scrollDirection: Axis.horizontal,
                  children: filters,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.black)),
                onPressed: () async {
                  var status = await Permission.storage.status;
                  if (status.isGranted) {
                    // If not we will ask for permission first
                    await Permission.storage.request();
                  }

                  // Directory? externalStorage = await getExternalStorageDirectory();
                  Directory dir = Directory(widget.path);
                  if (!await dir.exists()) {
                    await dir.create();
                  }

                  final savedImage =
                      File('${widget.path}${widget.imageFile.name}');
                  // Copy the image file to the new location
                  await savedImage.writeAsBytes(widget.editedImage.data);

                  log('Image saved to: ${savedImage.path}');
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Text('Bruh There Was An Error!!!');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
