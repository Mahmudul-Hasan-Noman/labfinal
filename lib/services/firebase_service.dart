import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<void> saveQuizResult({
    required String category,
    required int total,
    required int correct,
    required int wrong,
    required int durationSeconds,
  }) async {
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }

      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('quiz_results').add({
        'uid': uid,
        'category': category,
        'total': total,
        'correct': correct,
        'wrong': wrong,
        'scorePercent': total == 0 ? 0 : (correct / total * 100).round(),
        'durationSeconds': durationSeconds,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }
}
