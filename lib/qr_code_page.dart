import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icebreaker/find_a_match_task.dart';
import 'package:icebreaker/user_match.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  UserMatch _match;

  @override
  void initState() {
    super.initState();
    _startListeningToMatchEvents();
    _findAMatch();
  }

  Future<void> _startListeningToMatchEvents() async {
    final myUserId = (await FirebaseAuth.instance.signInAnonymously()).uid;

    StreamSubscription<DocumentSnapshot> subscription;
    subscription = Firestore.instance
        .collection('events')
        .document('hack19-helsinki')
        .collection('match-making-pool')
        .document(myUserId)
        .snapshots()
        .listen((data) {
      if (!mounted) return;

      if (data != null && data.exists) {
        final available = data['available'];
        final matchedUserId = data['matchedUserId'];

        if (!available && matchedUserId != null) {
          print('Its a match! Say Hello $matchedUserId');
          subscription.cancel();
        }
      }
    });
  }

  Future<void> _findAMatch() async {
    final task = FindAMatchTask(FirebaseAuth.instance, Firestore.instance);
    final match = await task.run('hack19-helsinki');

    setState(() {
      _match = match;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _content;

    if (_match == null) {
      _content = Center(
        child: Text('Searching for a match for you...'),
      );
    } else {
      _content = Column(
        children: [
          Expanded(
            child: Container(
              child: _qrCode(),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Image.network(_match.avatarUrl),
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
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Code Scanner'),
      ),
      body: _content,
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
