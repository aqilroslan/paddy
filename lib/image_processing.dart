import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Preprocesses a single image for TFLite inference.
/// - Resizes to 128x128 (as your model was trained)
/// - Normalizes pixel values to [0, 1] (divide by 255.0)
/// - Returns a Float32List in RGB order (for TFLite)
Future<Float32List> preprocessImage(File file, {int targetSize = 128}) async {
  // Read the image file as bytes
  final bytes = await file.readAsBytes();

  // Decode the image using the image package
  img.Image? oriImage = img.decodeImage(bytes);
  if (oriImage == null) throw Exception("Cannot decode image");

  // Resize to model input size (128x128)
  img.Image resized = img.copyResize(oriImage, width: targetSize, height: targetSize);

  // Prepare a Float32List for the model input (size: 128*128*3)
  var imageAsList = Float32List(targetSize * targetSize * 3);

  // Fill in the list with normalized pixel values (R,G,B order)
  int i = 0;
  for (var y = 0; y < targetSize; y++) {
    for (var x = 0; x < targetSize; x++) {
      final pixel = resized.getPixel(x, y);
      imageAsList[i++] = pixel.r / 255.0;
      imageAsList[i++] = pixel.g / 255.0;
      imageAsList[i++] = pixel.b / 255.0;
    }
  }
  return imageAsList;
}
