import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_preferences.dart';
import '../models/word_document.dart';

/// Thin wrapper around [FirebaseFirestore] for the two collections used by
/// this app:
///
///   • `users/{uid}`  — per-user preferences (language, mode, level)
///   • `words/{id}`   — vocabulary entries (sinhala, english, transliteration, audio)
class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  final _db = FirebaseFirestore.instance;

  // ── User preferences ────────────────────────────────────────────────────────

  /// Reads the `users/{uid}` document. Returns `null` if it does not exist yet.
  Future<Map<String, dynamic>?> fetchUserPrefs(String uid) async {
    final snap = await _db.collection('users').doc(uid).get();
    return snap.data();
  }

  /// Writes language, mode, and level to `users/{uid}` using merge so
  /// unrelated fields in the document are preserved.
  Future<void> saveUserPrefs(String uid, UserPreferences prefs) =>
      _db.collection('users').doc(uid).set(
        {
          'language': prefs.language.name,
          'mode': prefs.mode.name,
          'level': prefs.level.name,
        },
        SetOptions(merge: true),
      );

  // ── Words ────────────────────────────────────────────────────────────────────

  /// Live stream of all documents in the `words` collection.
  Stream<List<WordDocument>> watchWords() => _db
      .collection('words')
      .snapshots()
      .map((snap) => snap.docs.map(WordDocument.fromFirestore).toList());
}
