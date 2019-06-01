import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:icebreaker/find_a_match_task.dart';
import 'package:icebreaker/listen_for_matches_task.dart';
import 'package:icebreaker/routes.dart';
import 'package:icebreaker/user_match.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatefulWidget {
  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  UserMatch _match;
  QRReaderController _qrController;

  @override
  void initState() {
    super.initState();
    _initializeQrReader();
    _startListeningToMatchEvents();
    _findAMatch();
  }

  Future<void> _initializeQrReader() async {
    final cameras = await availableCameras();
    _qrController = QRReaderController(
      cameras[0],
      ResolutionPreset.medium,
      [CodeFormat.qr],
      _onQrCodeScanned,
    );
    _qrController.initialize().then((_) {
      _qrController.startScanning();
    });
  }

  @override
  void dispose() {
    _qrController.dispose();
    super.dispose();
  }

  Future<void> _startListeningToMatchEvents() async {
    final task =
        ListenForMatchesTask(FirebaseAuth.instance, Firestore.instance);
    final match = await task.run();

    if (!mounted || _match != null) return;

    setState(() {
      _match = match;
    });
  }

  Future<void> _findAMatch() async {
    final task = FindAMatchTask(FirebaseAuth.instance, Firestore.instance);
    final match = await task.run('hack19-helsinki');

    if (!mounted || _match != null) return;

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
          Flexible(
            flex: 1,
            child: Container(
              child: _qrCode(),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Image.network(
                      _match.avatarUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      _match.name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Expanded(
                  child: QRReaderPreview(_qrController),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('QR Code Scanner'),
      ),
      body: _content,
      resizeToAvoidBottomPadding: true,
    );
  }

  void _onQrCodeScanned(String text) async {
    if (text == _match.id) {
      Navigator.pushReplacementNamed(context, Routes.questions);
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Sorry! That\'s not the correct ${_match.name}!'),
        ),
      );

      print('Tried with: $text');
      print('Correct id: ${_match.id}');

      Future.delayed(
        const Duration(seconds: 1),
        _qrController.startScanning,
      );
    }
  }

  _qrCode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: QrImage(
          data: _getUserId().toString(),
          gapless: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
    );
  }

  _getUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.signInAnonymously();
    return user.uid;
  }
}
