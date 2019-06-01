import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _random = new Random();

class MatchUsersTask {
  MatchUsersTask(this.auth, this.firestore);
  final FirebaseAuth auth;
  final Firestore firestore;

  Future<void> run(String eventCode) async {
    final myUserId = (await auth.signInAnonymously()).uid;
    final otherUserId = await _pickRandomMatch(myUserId, eventCode);

    print(otherUserId);
  }

  Future<String> _pickRandomMatch(String myUserId, String eventCode) async {
    final matchMakingPoolSnapshot = await firestore
        .collection('events')
        .document(eventCode)
        .collection('match-making-pool')
        .where('available', isEqualTo: true)
        .reference()
        .getDocuments();

    final potentialMatches = matchMakingPoolSnapshot.documents
        .where((snapshot) => snapshot.documentID != myUserId)
        .toList();

    return potentialMatches[_random.nextInt(potentialMatches.length)]
        .documentID;
  }
}
