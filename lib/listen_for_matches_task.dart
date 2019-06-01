import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icebreaker/user_match.dart';

class ListenForMatchesTask {
  ListenForMatchesTask(this.auth, this.firestore);
  final FirebaseAuth auth;
  final Firestore firestore;

  Future<UserMatch> run() async {
    final completer = Completer<UserMatch>();
    final myUserId = (await FirebaseAuth.instance.signInAnonymously()).uid;

    StreamSubscription<DocumentSnapshot> subscription;
    subscription = Firestore.instance
        .collection('events')
        .document('hack19-helsinki')
        .collection('match-making-pool')
        .document(myUserId)
        .snapshots()
        .listen((data) async {
      if (data != null && data.exists) {
        final available = data['available'];
        final matchedUserId = data['matchedUserId'];
        final otherUserSnapshot =
            await firestore.collection('users').document(matchedUserId).get();

        if (!available && matchedUserId != null) {
          if (!completer.isCompleted) {
            completer.complete(
              UserMatch(
                id: otherUserSnapshot.documentID,
                name: otherUserSnapshot['name'],
                avatarUrl: otherUserSnapshot['profile-image'],
              ),
            );

            subscription.cancel();
          }
        }
      }
    });

    return completer.future;
  }
}
