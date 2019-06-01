import 'package:flutter/material.dart';
import 'package:icebreaker/enter_code_page.dart';
import 'package:icebreaker/find_person_page.dart';
import 'package:icebreaker/qr_code_page.dart';
import 'package:icebreaker/routes.dart';
import 'package:icebreaker/take_photo_page.dart';
import 'package:icebreaker/thank_you_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        Routes.enterCode: (_) => EnterCodePage(),
        Routes.takePhoto: (_) => TakePhotoPage(),
        Routes.findPerson: (_) => FindPersonPage(),
        Routes.qrCode: (_) => QrCodePage(),
        Routes.thankYou: (_) => ThankYouPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello'),
      ),
      body: Center(
        child: Text('Hello World!'),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
