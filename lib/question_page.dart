import 'dart:math';

import 'package:flutter/material.dart';
import 'package:icebreaker/routes.dart';

class QuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Lets talk!",
              style: TextStyle(fontSize: 32.0),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Ask Alex a question:",
                  style: TextStyle(fontSize: 24.0),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _getRandomQuestion(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(
                  width: 250.0,
                  height: 100.0,
                  child: RaisedButton(
                      onPressed: () =>  Navigator.pushReplacementNamed(context, Routes.thankYou),
                      child: Text("We are ready with our conversation!"),
                      color: Colors.blue[300],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRandomQuestion() {
    List<String> questions = [
      "What is your favourite programming language and why?",
      "What are the best things in Flutter?",
      "What is your preference for state management and why?",
      "What you want to learn in Flutter?",
      "What feature are you waiting to be in Dart?",
      "Can you tell me about your developer background?",
      "Can you tell me about your intrests in programming?",
      "What is the reason you wanted to attend here today?",
    ];
    int randomNumber = Random.secure().nextInt(questions.length);
    String question = questions.elementAt(randomNumber);
    return question;
  }
}
