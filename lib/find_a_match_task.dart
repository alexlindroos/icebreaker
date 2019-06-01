import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:icebreaker/user_match.dart';

final _random = new Random();

class FindAMatchTask {
  FindAMatchTask(this.auth, this.firestore);
  final FirebaseAuth auth;
  final Firestore firestore;

  Future<UserMatch> run(String eventCode) async {
    final myUserId = (await auth.signInAnonymously()).uid;
    final otherUserId = await _pickRandomMatch(myUserId, eventCode);
    final otherUserSnapshot =
        await firestore.collection('users').document(otherUserId).get();

    if (otherUserSnapshot == null || !otherUserSnapshot.exists) {
      throw Exception('No user found with the id.');
    }

    final data = otherUserSnapshot.data;
    return UserMatch(
      name: data['name'],
      avatarUrl: data['profile-image'],
    );
  }

  Future<String> _pickRandomMatch(String myUserId, String eventCode) async {
    final completer = Completer<String>();

    StreamSubscription<QuerySnapshot> subscription;
    subscription = firestore
        .collection('events')
        .document(eventCode)
        .collection('match-making-pool')
        .where('available', isEqualTo: true)
        .reference()
        .snapshots()
        .listen((data) async {
      if (completer.isCompleted) return;

      if (data != null && data.documents.isNotEmpty) {
        final potentialMatches = data.documents
            .where((snapshot) => snapshot.documentID != myUserId)
            .toList();

        if (potentialMatches.isNotEmpty) {
          final match =
              potentialMatches[_random.nextInt(potentialMatches.length)];

          if (match != null && match.exists) {
            final matchSnapshot = await match.reference.get();

            if (matchSnapshot.exists) {
              await firestore
                  .collection('events')
                  .document(eventCode)
                  .collection('match-making-pool')
                  .document(myUserId)
                  .updateData({
                'available': false,
                'matchedUserId': match.documentID,
              });

              await match.reference.updateData({
                'available': false,
                'matchedUserId': myUserId,
              });

              completer.complete(match.documentID);
              subscription.cancel();
            }
          }
        }
      }
    });

    return completer.future;
  }
}
