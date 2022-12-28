import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:store_management/screens/screens.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:store_management/widgets/widgets.dart';

class ProductDetailScreen extends StatefulWidget {
  //route name with argument
  static const String routeName =
      '${CheckSheetProductsScreen.routeName}/product-detail-screen';
  final String barcode;
  final int quantity;

  const ProductDetailScreen(
      {Key? key, required this.barcode, required this.quantity})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ByteData _img = ByteData(0);
  var color = Colors.black;
  var strokeWidth = 5.0;
  final _sign = GlobalKey<SignatureState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _handleSavePicture() async {
    if (await _generateStoragePermissions()) {
      return;
    }

    final sign = _sign.currentState;
    //retrieve image data, do whatever you want with it (send to server, save locally...)
    final image = await sign?.getData();
    // final imageWhiteBackground = await _changeBackground(image);
    // var data = await image?.toByteData(format: ui.ImageByteFormat.png);
    var data = await _changeBackground(image);
    sign?.clear();
    //save image with white background
    final result = await ImageGallerySaver.saveImage(data!.buffer.asUint8List(),
        quality: 60, name: 'signature');
    setState(() {
      _img = data;
    });
  }

  //image with white background
  Future<ByteData?> _changeBackground(ui.Image? image) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = Colors.white;
    final rect =
        Rect.fromLTWH(0, 0, image!.width.toDouble(), image.height.toDouble());
    canvas.drawRect(rect, paint);
    canvas.drawImage(image, Offset.zero, Paint());
    final picture = recorder.endRecording();
    final img = await picture.toImage(image.width, image.height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data;
  }

  _generateStoragePermissions() async {
    final isStorage = await Permission.storage.status;
    if (!isStorage.isGranted) {
      await Permission.storage.request();
    }
    return isStorage.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Signature(
                  color: color,
                  key: _sign,
                  onSign: () {
                    final sign = _sign.currentState;
                  },
                  backgroundPainter: _WatermarkPaint("2.0", "2.0"),
                  strokeWidth: strokeWidth,
                ),
              ),
            ),
          ),
          _img.buffer.lengthInBytes == 0
              ? Container()
              : LimitedBox(
                  maxHeight: 200.0,
                  child: Image.memory(_img.buffer.asUint8List())),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      color: Colors.green,
                      onPressed: _handleSavePicture,
                      text: 'Save'),
                  CustomButton(
                      color: Colors.grey,
                      onPressed: () {
                        final sign = _sign.currentState;
                        sign?.clear();
                        setState(() {
                          _img = ByteData(0);
                        });
                      },
                      text: "Clear"),
                ],
              ),
/*
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomButton(
                      onPressed: () {
                      },
                    icon: const Icon(Icons.draw_sharp, size: 30,),
                  ),
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          int min = 1;
                          int max = 10;
                          int selection = min + (Random().nextInt(max - min));
                          strokeWidth = selection.roundToDouble();
                        });
                      },
                      child: const Text("Change stroke width")),
                ],
              ),
*/
            ],
          )
        ],
      ),
    );
  }
}

class _WatermarkPaint extends CustomPainter {
  final String price;
  final String watermark;

  _WatermarkPaint(this.price, this.watermark);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(const Offset(0, 0), 10.8, Paint()..color = Colors.blue);
  }

  @override
  bool shouldRepaint(_WatermarkPaint oldDelegate) {
    return oldDelegate != this;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _WatermarkPaint &&
          runtimeType == other.runtimeType &&
          price == other.price &&
          watermark == other.watermark;

  @override
  int get hashCode => price.hashCode ^ watermark.hashCode;
}
