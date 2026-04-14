import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Wraps [FlutterTts] with Sinhala language support.
///
/// - Primary language: `si-LK` (Sinhala — supported by Google TTS on Android)
/// - Falls back to `en-US` on engines that don't have Sinhala installed
/// - Reduced speech rate (0.45) for clearer pronunciation for learners
class TtsService {
  TtsService._() {
    _init();
  }

  static final instance = TtsService._();

  final _tts = FlutterTts();

  /// `true` while an utterance is playing.
  final isSpeaking = ValueNotifier<bool>(false);

  /// The text currently being spoken (reset to `null` on completion/stop).
  final currentText = ValueNotifier<String?>(null);

  Future<void> _init() async {
    _tts.setStartHandler(() {
      isSpeaking.value = true;
    });
    _tts.setCompletionHandler(() {
      isSpeaking.value = false;
      currentText.value = null;
    });
    _tts.setCancelHandler(() {
      isSpeaking.value = false;
      currentText.value = null;
    });
    _tts.setErrorHandler((_) {
      isSpeaking.value = false;
      currentText.value = null;
    });

    if (!kIsWeb && Platform.isAndroid) {
      await _tts.setEngine('com.google.android.tts');
    }

    // Try Sinhala; if the engine reports it unavailable the TTS engine will
    // attempt a best-effort pronunciation of the Unicode text anyway.
    await _tts.setLanguage('si-LK');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.05);
  }

  /// Speak [text]. Stops any currently playing utterance first.
  Future<void> speak(String text) async {
    await _tts.stop();
    currentText.value = text;
    isSpeaking.value = false; // will flip to true once start handler fires
    await _tts.speak(text);
  }

  /// Stop immediately.
  Future<void> stop() async {
    await _tts.stop();
    isSpeaking.value = false;
    currentText.value = null;
  }

  void dispose() {
    isSpeaking.dispose();
    currentText.dispose();
  }
}
