import 'package:cloud_firestore/cloud_firestore.dart';

class ValidateEventCodeTask {
  ValidateEventCodeTask(this.firestore);
  final Firestore firestore;

  Future<bool> run(String code) async {
    if (code == null || code.isEmpty) return false;

    final snapshot = await firestore.collection('events').document(code).get();
    return snapshot != null && snapshot.exists;
  }
}
