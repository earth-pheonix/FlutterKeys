// lib/tts/tts_android.dart
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';
import 'tts_interface.dart';
import 'dart:async';

class TTSAndroid implements TTSInterface {
  FlutterTts _tts = FlutterTts();

  @override
  ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  final StreamController<void> _doneController = StreamController.broadcast();

  @override
  Stream<void> get onDone => _doneController.stream;

  TTSAndroid() {
    _initializeTts();
  }

  void _initializeTts() {
    _tts.awaitSpeakCompletion(true);

    _tts.setStartHandler(() {
      notifyStart();
      print("Android: Speech started");
    });

    _tts.setCompletionHandler(() {
      notifyDone();
      print("Android: Speech completed");
    });

    _tts.setCancelHandler(() {
      notifyDone();
      print("Android: Speech cancelled");
    });

    _tts.setPauseHandler(() {
      isSpeaking.value = false;
      print("Android: Speech paused");
    });

    _tts.setContinueHandler(() {
      isSpeaking.value = true;
      print("Android: Speech resumed");
    });
  }

  @override
  void notifyStart() {
    isSpeaking.value = true;
  }

  @override
  void notifyDone() {
    isSpeaking.value = false;
    if (!_doneController.isClosed) {
      _doneController.add(null);
    }
  }

  @override
  Future<void> speak(String text) async {
    try {
      await _tts.speak(text);
    } catch (e) {
      print("Error speaking on Android: $e");
      notifyDone();
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _tts.stop();
      notifyDone();
    } catch (e) {
      print("Error stopping TTS on Android: $e");
      notifyDone();
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (e) {
      print("Pause not supported on this Android version: $e");
    }
  }

  @override
  Future<void> resume() async {
    // flutter_tts does not support proper resume on Android
    print("Resume not supported on Android; must re-speak text");
  }

  @override
  Future<void> setPitch(double pitch) async =>
      await _tts.setPitch(pitch);

  @override
  Future<void> setRate(double rate) async =>
      await _tts.setSpeechRate(rate);

  @override
  Future<void> setVoice(Map<String, dynamic> voice) async {
    if (voice.containsKey('identifier')) {
      final voices = await _tts.getVoices;
      final match = voices.firstWhere(
        (v) => v['identifier'] == voice['identifier'],
        orElse: () => {},
      );
      if (match.isNotEmpty) {
        await _tts.setVoice(Map<String, String>.from(
          match.map((k, v) => MapEntry(k.toString(), v.toString())),
        ));
      }
    }
  }

  @override
  Future<void> setLanguage(String languageCode) async =>
      await _tts.setLanguage(languageCode);

  @override
  Future<List<dynamic>> getVoices() async =>
      await _tts.getVoices;

  @override
  Future<void> configureVoice({
    required String voiceID,
    required double rate,
    required double pitch,
  }) async {
    await _tts.stop();

    // Reset TTS instance to apply fresh settings
    _tts = FlutterTts();
    _initializeTts();

    // Apply voice/rate/pitch
    final voices = await _tts.getVoices;
    final match = voices.firstWhere(
      (v) => v['identifier'] == voiceID,
      orElse: () => {},
    );
    if (match.isNotEmpty) {
      await _tts.setVoice(Map<String, String>.from(
        match.map((k, v) => MapEntry(k.toString(), v.toString())),
      ));
    }

    await _tts.setSpeechRate(rate);
    await _tts.setPitch(pitch);
  }

  @override
  Stream<Map<String, dynamic>> get wordStream => const Stream.empty();
}