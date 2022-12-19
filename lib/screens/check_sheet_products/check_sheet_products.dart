import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app_barcode_scanner_widget.dart';

class CheckSheetProductsScreen extends StatefulWidget {
  const CheckSheetProductsScreen({Key? key}) : super(key: key);

  static const String routeName = '/check-sheet-products';

  @override
  State<CheckSheetProductsScreen> createState() => _CheckSheetProductsScreenState();
}

class _CheckSheetProductsScreenState extends State<CheckSheetProductsScreen> {
  bool _isShowCam = true;

  var map = {};

  @override
  void initState() {
    super.initState();
  }

  initPermissions() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }
  }

  addBarCode(String barcode) {
    soundWhenScan();
    setState(() {
      map[barcode] = map[barcode] == null ? 1 : map[barcode]! + 1;
    });
  }

  soundWhenScan() async {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/Scanner-Beep-Sound.wav'));
  }


  hideShowCamera() {
    setState(() {
      _isShowCam = !_isShowCam;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kiểm tra mã vạch"),
        actions: [
          IconButton(
            onPressed: hideShowCamera,
            icon: Icon(
              _isShowCam ? Icons.close : Icons.camera_alt,
              color: Colors.white,
            ),
            tooltip: _isShowCam ? "Ẩn camera" : "Hiện camera",
          ),
        ],
      ),
      body: Column(
        children: [
          _isShowCam
              ? Expanded(
            flex: 2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              child: AppBarcodeScannerWidget.defaultStyle(
                resultCallback: (String code) {
                  addBarCode(code);
                },
                openManual: true,
              ),
            ),
          )
              : Container(),
          Expanded(
            flex: 6,
            child: ListView.builder(
              itemCount: map.length,
              addAutomaticKeepAlives: true,
              // notification when map is empty
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      map.remove(map.keys.elementAt(index));
                    });
                  },
                  child: Ink(
                    child: ListTile(
                      title: Text(map.keys.elementAt(index)),
                      trailing: Text(map.values.elementAt(index).toString()),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}


