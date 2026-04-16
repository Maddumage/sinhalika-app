import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a Firestore document at `words/{id}`.
///
/// Schema:
/// ```
/// words/{id}:
///   sinhala        — Sinhala script, e.g. 'අම්මා'
///   english        — English translation, e.g. 'Mother'
///   transliteration — Romanised pronunciation, e.g. 'Ammaa'
///   audio          — Optional URL to a pre-recorded audio file
/// ```
class WordDocument {
  const WordDocument({
    required this.id,
    required this.sinhala,
    required this.english,
    required this.transliteration,
    this.audioUrl,
  });

  final String id;
  final String sinhala;
  final String english;
  final String transliteration;

  /// Optional URL to a pre-recorded audio asset in Firebase Storage.
  final String? audioUrl;

  factory WordDocument.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final d = snap.data()!;
    return WordDocument(
      id: snap.id,
      sinhala: d['sinhala'] as String? ?? '',
      english: d['english'] as String? ?? '',
      transliteration: d['transliteration'] as String? ?? '',
      audioUrl: d['audio'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'sinhala': sinhala,
    'english': english,
    'transliteration': transliteration,
    if (audioUrl != null) 'audio': audioUrl,
  };
}
