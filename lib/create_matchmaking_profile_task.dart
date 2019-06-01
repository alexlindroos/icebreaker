import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateMatchMakingProfileTask {
  CreateMatchMakingProfileTask(this.auth, this.firestore);
  final FirebaseAuth auth;
  final Firestore firestore;

  Future<void> run(
    String eventCode,
    String nickname,
    StorageReference profileImageReference,
  ) async {
    final user = await auth.signInAnonymously();

    final eventSnapshot =
        await firestore.collection('events').document(eventCode).get();

    if (eventSnapshot == null) {
      throw Exception('No event found for code $eventCode');
    }

    final avatarUrl = await profileImageReference.getDownloadURL();
    await firestore.collection('users').document(user.uid).setData({
      'name': nickname,
      'profile-image': avatarUrl,
    });

    return eventSnapshot.reference
        .collection('match-making-pool')
        .document(user.uid)
        .setData({'available': true});
  }
}
