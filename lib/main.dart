import 'package:flutter/material.dart';
import 'package:icebreaker/enter_code_page.dart';
import 'package:icebreaker/qr_code_page.dart';
import 'package:icebreaker/question_page.dart';
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
      routes: {
        Routes.enterCode: (_) => EnterCodePage(),
        Routes.takePhoto: (_) => TakePhotoPage(),
        Routes.questions: (_) => QuestionPage(),
        Routes.qrCode: (_) => QrCodePage(),
        Routes.thankYou: (_) => ThankYouPage(),
      },
    );
  }
}
