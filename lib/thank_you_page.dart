import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:icebreaker/routes.dart';

class ThankYouPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
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
            SizedBox(
              height: 250.0,
              width: 250.0,
              child: FlareActor(
                "assets/Success Check.flr",
                animation: "Untitled",
              ),
            ),
            Text("Thank you!",style: TextStyle(fontSize: 24.0),),
            SizedBox(
              width: 150.0,
              height: 50.0,
              child: RaisedButton(
                  onPressed: () => _findNewOne(context),
                  child: Text("Find a new one"),
                  color: Colors.blue[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ),
            SizedBox(
              width: 150.0,
              height: 50.0,
              child: RaisedButton(
                  onPressed: () => _haveBreak(context),
                  child: Text("Have a break"),
                  color: Colors.blue[300],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ),
          ],
        ),
      ),
    );
  }

  void _findNewOne(BuildContext context) {
    //Go back to FindPersonPage
    Navigator.pushReplacementNamed(context, Routes.findPerson);
  }

  void _haveBreak(BuildContext context) {
    //Go back to TakePhotoPage
    Navigator.pushReplacementNamed(context, Routes.takePhoto);
  }

}
