import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Plays audio files (from URLs or local paths) with disk-based caching.
///
/// Usage:
/// ```dart
/// await AudioService.instance.init(); // call once at app start
/// await AudioService.instance.play('https://example.com/audio.mp3');
/// ```
///
/// Falls back silently (prints a debug message) if playback fails so the UI
/// is never broken by missing/invalid audio assets.
class AudioService {
  AudioService._() {
    _player.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        currentId.value = null;
      }
    });
  }

  static final instance = AudioService._();

  final _player = AudioPlayer();
  final _dio = Dio();

  /// In-memory map of URL → local cached file path.
  final _memoryCache = <String, String>{};

  String? _cacheDir;

  /// `true` while an audio file is playing.
  final isPlaying = ValueNotifier<bool>(false);

  /// Identifier of the item currently playing (see [play]).
  final currentId = ValueNotifier<String?>(null);

  /// Must be called once during app startup (before any [play] calls).
  Future<void> init() async {
    final dir = await getApplicationCacheDirectory();
    _cacheDir = '${dir.path}/sinhalika_audio';
    await Directory(_cacheDir!).create(recursive: true);
  }

  /// Play [audioUrl] (HTTP URL or absolute local path).
  ///
  /// [id] is an optional opaque identifier (e.g., item ID) stored in
  /// [currentId] so the UI can highlight the currently playing card.
  ///
  /// Any currently playing audio is stopped first.
  /// Download errors are caught and logged; the method returns normally.
  Future<void> play(String audioUrl, {String? id}) async {
    await _player.stop();
    currentId.value = id;

    try {
      final localPath = await _resolveLocalPath(audioUrl);
      await _player.play(DeviceFileSource(localPath));
    } catch (e) {
      debugPrint('AudioService.play error for "$audioUrl": $e');
      isPlaying.value = false;
      currentId.value = null;
    }
  }

  /// Stop playback immediately.
  Future<void> stop() async {
    await _player.stop();
    isPlaying.value = false;
    currentId.value = null;
  }

  void dispose() {
    _player.dispose();
    isPlaying.dispose();
    currentId.dispose();
  }

  // ── Private ────────────────────────────────────────────────────────────────

  /// Returns a local file path for [url], downloading and caching if needed.
  Future<String> _resolveLocalPath(String url) async {
    // Already a local / device path — use directly.
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return url;
    }

    // Memory cache hit.
    final cached = _memoryCache[url];
    if (cached != null && await File(cached).exists()) return cached;

    // Disk cache hit.
    final dir = _cacheDir ?? await _initCacheDir();
    final filename = '${url.hashCode.abs()}.mp3';
    final localPath = '$dir/$filename';

    if (await File(localPath).exists()) {
      _memoryCache[url] = localPath;
      return localPath;
    }

    // Download and cache.
    await _dio.download(url, localPath);
    _memoryCache[url] = localPath;
    return localPath;
  }

  Future<String> _initCacheDir() async {
    final dir = await getApplicationCacheDirectory();
    _cacheDir = '${dir.path}/sinhalika_audio';
    await Directory(_cacheDir!).create(recursive: true);
    return _cacheDir!;
  }
}
