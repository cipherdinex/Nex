import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddressScanner extends StatefulWidget {
  const AddressScanner({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddressScannerState();
}

class _AddressScannerState extends State<AddressScanner> {
  Barcode? result;
  String? qrText;
  var flashState = FLASHON;
  var cameraState = FRONTCAMERA;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TrnsText(title: 'Scan Address'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                if (controller != null) {
                  controller!.toggleFlash();
                  if (_isFlashOn(flashState)) {
                    setState(() {
                      flashState = FLASHOFF;
                    });
                  } else {
                    setState(() {
                      flashState = FLASHON;
                    });
                  }
                }
              },
              child: flashState == FLASHON
                  ? Icon(Ionicons.ios_flash, size: 20)
                  : Icon(Ionicons.ios_flash_off, size: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
                onTap: () {
                  if (controller != null) {
                    controller!.flipCamera();
                    if (_isBackCamera(cameraState)) {
                      setState(() {
                        cameraState = FRONTCAMERA;
                      });
                    } else {
                      setState(() {
                        cameraState = BACKCAMERA;
                      });
                    }
                  }
                },
                child: Icon(Icons.flip_camera_ios_outlined, size: 20)),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Theme.of(context).colorScheme.secondary,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return FLASHON == current;
  }

  bool _isBackCamera(String current) {
    return BACKCAMERA == current;
  }

  void _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (this.result != null) {
        return;
      }
      this.controller?.pauseCamera();
      setState(() {
        result = scanData;
      });
      Navigator.pop(context, result!.code);

      return;
    });
  }

  qrTextFxn(e) {
    print(e);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}
