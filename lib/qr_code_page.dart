import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';


class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() {
    return _QrCodePageState();
  }
}

class _QrCodePageState extends State {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('QR Code Scanner'),
        ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(child: _qrCode(),),
          ),
          Expanded(
            child: Container(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              )
          ),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  _onQRViewCreated(QRViewController controller) {
    final channel = controller.channel;
    controller.init(qrKey);
    channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case "onRecognizeQR":
          dynamic arguments = call.arguments;
          _onQrCodeScanned(arguments.toString());
      }
    });
  }

  _onQrCodeScanned(qrText) {
    // Do something
    // move to questions
    // Navigator.pushReplacementNamed(context, Routes.questions);
  }

  _qrCode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: QrImage(
          data: _getUserId().toString(),
          gapless: false,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  _getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.signInAnonymously();
    return user.uid;
  }
}
