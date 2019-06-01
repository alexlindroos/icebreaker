import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:icebreaker/routes.dart';
import 'package:icebreaker/validate_event_code_task.dart';

class EnterCodePage extends StatelessWidget {
  static final _controller = TextEditingController();
  static final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.6, 0.7],
            colors: [
              Colors.blue[500],
              Colors.blue[200],
              Colors.blue[100],
              Colors.blue[100],
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "ICE BREAKER",
              style: TextStyle(
                fontSize: 42.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    "Enter the code",
                    style: TextStyle(fontSize: 22.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    style: TextStyle(fontSize: 30.0),
                    autocorrect: false,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 150.0,
              height: 50.0,
              child: RaisedButton(
                onPressed: () async {
                  final task = ValidateEventCodeTask(Firestore.instance);
                  final isValidCode = await task.run(_controller.text);

                  if (isValidCode) {
                    Navigator.pushReplacementNamed(context, Routes.takePhoto);
                  } else {
                    _controller.clear();
                    _scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: Text('Invalid code. Please try again.'),
                      ),
                    );
                  }
                },
                child: Text("Enter"),
                color: Colors.blue[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
