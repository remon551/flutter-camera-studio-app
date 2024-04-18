import 'package:camera_studio/cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;

abstract class Filter extends StatelessWidget {
  const Filter(
      {super.key, required this.filterName, required this.filterImagePath});
  final String filterName;
  final String filterImagePath;

  void applyFilter(img.Image image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final provider = BlocProvider.of<FilterCubit>(context);
        provider.applyFilter(this);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          height: 70,
          width: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                height: 70,
                width: 70,
                filterImagePath,
                fit: BoxFit.cover,
              ),
              Align(alignment: Alignment.center, child: Text(filterName))
            ],
          ),
        ),
      ),
    );
  }
}

class NoFilter extends Filter {
  const NoFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/none.png',
          filterName: 'None',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);
        image.setPixel(x, y, img.getColor(red, green, blue));
      }
    }
  }
}

class RedFilter extends Filter {
  const RedFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/red.png',
          filterName: 'Red',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = img.getRed(pixel);
        image.setPixel(x, y, img.getColor(red, 0, 0));
      }
    }
  }
}

class GreenFilter extends Filter {
  const GreenFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/green.png',
          filterName: 'Green',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int green = img.getGreen(pixel);
        image.setPixel(x, y, img.getColor(0, green, 0));
      }
    }
  }
}

class BlueFilter extends Filter {
  const BlueFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/blue.png',
          filterName: 'Blue',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int blue = img.getBlue(pixel);
        image.setPixel(x, y, img.getColor(0, 0, blue));
      }
    }
  }
}

class NeonFilter extends Filter {
  const NeonFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/sunny.jpg',
          filterName: 'Cursed Sunny',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = img.getRed(pixel);
        int green = img.getGreen(pixel);
        int blue = img.getBlue(pixel);

        // Increase intensity of bright colors
        red = (red * 1.5).clamp(0, 255).toInt();
        green = (green * 1.5).clamp(0, 255).toInt();
        blue = (blue * 1.5).clamp(0, 255).toInt();

        // Apply glow effect (simple averaging)
        int averageRed = 0, averageGreen = 0, averageBlue = 0;
        int count = 0;

        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            int nx = x + dx;
            int ny = y + dy;

            if (nx >= 0 && nx < image.width && ny >= 0 && ny < image.height) {
              int neighborPixel = image.getPixel(nx, ny);
              averageRed += img.getRed(neighborPixel);
              averageGreen += img.getGreen(neighborPixel);
              averageBlue += img.getBlue(neighborPixel);
              count++;
            }
          }
        }

        averageRed ~/= count;
        averageGreen ~/= count;
        averageBlue ~/= count;

        red = (red + averageRed) ~/ 2;
        green = (green + averageGreen) ~/ 2;
        blue = (blue + averageBlue) ~/ 2;

        // Increase contrast
        red = (red + 30).clamp(0, 255).toInt();
        green = (green + 30).clamp(0, 255).toInt();
        blue = (blue + 30).clamp(0, 255).toInt();

        // Apply thresholding
        int threshold = 128;
        red = red > threshold ? 255 : 0;
        green = green > threshold ? 255 : 0;
        blue = blue > threshold ? 255 : 0;

        // Update pixel value
        image.setPixel(x, y, img.getColor(red, green, blue));
      }
    }
  }
}

class SepiaFilter extends Filter {
  const SepiaFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/sepia.jpg',
          filterName: 'Sepia',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = (pixel >> 16) & 0xFF;
        int green = (pixel >> 8) & 0xFF;
        int blue = pixel & 0xFF;

        int newRed = (red * 0.393 + green * 0.769 + blue * 0.189).toInt();
        int newGreen = (red * 0.349 + green * 0.686 + blue * 0.168).toInt();
        int newBlue = (red * 0.272 + green * 0.534 + blue * 0.131).toInt();

        red = newRed.clamp(0, 255);
        green = newGreen.clamp(0, 255);
        blue = newBlue.clamp(0, 255);

        image.setPixel(x, y, img.getColor(red, green, blue));
      }
    }
  }
}

class GrayscaleFilter extends Filter {
  const GrayscaleFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/grayscale.jpg',
          filterName: 'Grayscale',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int luminance = ((pixel >> 16) &
                (0xFF * 0.299).ceil() + (pixel >> 8) &
                (0xFF * 0.587).ceil() + ((pixel & 0xFF) * 0.114).ceil())
            .toInt();
        image.setPixel(x, y, img.getColor(luminance, luminance, luminance));
      }
    }
  }
}

class InvertFilter extends Filter {
  const InvertFilter({super.key})
      : super(
          filterImagePath: 'assets/filters/invert.jpg',
          filterName: 'Invert',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = 255 - ((pixel >> 16) & 0xFF);
        int green = 255 - ((pixel >> 8) & 0xFF);
        int blue = 255 - (pixel & 0xFF);
        image.setPixel(x, y, img.getColor(red, green, blue));
      }
    }
  }
}

class VintageFilter extends Filter {
  const VintageFilter({Key? key})
      : super(
          key: key,
          filterImagePath: 'assets/filters/vintage.jpg',
          filterName: 'Vintage',
        );

  @override
  void applyFilter(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixel = image.getPixel(x, y);
        int red = (pixel >> 16) & 0xFF;
        int green = (pixel >> 8) & 0xFF;
        int blue = pixel & 0xFF;

        int newRed = (0.5 * red + 0.5 * green).toInt().clamp(0, 255);
        int newGreen =
            (0.4 * red + 0.6 * green + 0.2 * blue).toInt().clamp(0, 255);
        int newBlue =
            (0.2 * red + 0.5 * green + 0.7 * blue).toInt().clamp(0, 255);

        image.setPixel(x, y, img.getColor(newRed, newGreen, newBlue));
      }
    }
  }
}
