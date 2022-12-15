import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/colors.dart';
import '../../constants/contains.dart';

class BarCodeScreenCheck extends StatefulWidget {
  const BarCodeScreenCheck({Key? key}) : super(key: key);

  @override
  State<BarCodeScreenCheck> createState() => _BarCodeScreenCheckState();
}

class _BarCodeScreenCheckState extends State<BarCodeScreenCheck> {
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

  var map = {};

  Future<void> startBarcodeScanStream() async {
    initPermissions();
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) async => {
              if (barcode != '-1')
                {
                  addSoundWhenDone(),
                  setState(() {
                    map[barcode] = map[barcode] == null ? 1 : map[barcode]! + 1;
                  })
                }
              //add custom sound
            });
  }

  addSoundWhenDone() {
    final player = AudioPlayer();
    player.play(AssetSource('sounds/Scanner-Beep-Sound.wav'));

    //
    // FlutterRingtonePlayer.play(
    //     fromAsset: "assets/sounds/Scanner-Beep-Sound.wav",
    //     volume: 4,
    //     looping: false,
    //     asAlarm: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phiếu kiểm kho')),
      body: ListView.builder(
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
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () => startBarcodeScanStream(),
            //primary color
            backgroundColor: kPrimaryColor,
            tooltip: "Kiểm tra mã vạch",
            child: const Icon(
              Icons.camera_alt,
              color: Vx.white,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }
}
