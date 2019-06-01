import 'package:flutter/material.dart';

class EnterCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: TextField(
                    controller: TextEditingController(),
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
                  onPressed: () => print("Button pressed"),
                  child: Text("Enter"),
                  color: Colors.blue[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ),
          ],
        ),
      ),
    );
  }
}
