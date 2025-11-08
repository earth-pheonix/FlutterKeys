import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'tts_interface.dart';

class TTSiOS implements TTSInterface {
  static const MethodChannel _methodChannel =
      MethodChannel('tts_highlighter_plugin');

  final _highlighter = TtsHighlighter();

  double _currentPitch = 1.0;
  double _currentRate = 0.5;
  String? _currentVoiceIdentifier;

  @override
  ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  final StreamController<void> _doneController = StreamController<void>.broadcast();

  @override
  Stream<void> get onDone => _doneController.stream;

  TTSiOS() {
    _setupHandlers();
  }

  void _setupHandlers() {
    _methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onStart':
          notifyStart();
          print("iOS: Speech started");
          break;
        case 'onComplete':
          notifyDone();
          print("iOS: Speech completed");
          break;
        case 'onCancel':
          notifyDone();
          print("iOS: Speech cancelled");
          break;
        case 'onPause':
          isSpeaking.value = false;
          print("iOS: Speech paused");
          break;
        case 'onResume':
          isSpeaking.value = true;
          print("iOS: Speech resumed");
          break;
      }
    });
  }

  @override
  void notifyDone() {
    if (!_doneController.isClosed) {
      _doneController.add(null);
    }
    isSpeaking.value = false;
  }

  @override
  void notifyStart() {
    isSpeaking.value = true;
  }

  @override
  Future<void> speak(String text) async {
    notifyStart(); // optimistic start; native will also send onStart

    final normalizedText = _normalizeText(text);

    try {
      await _methodChannel.invokeMethod('speak', {
        'text': normalizedText,
        'pitch': _currentPitch,
        'rate': _currentRate,
        'voice': _currentVoiceIdentifier,
      });
      // Do NOT call notifyDone() here. Wait for native `onComplete`/`onCancel`.
    } catch (e) {
      notifyDone(); // fail-safe
    }
  }

  String _normalizeText(String text) {
  text = text.trim();
  // Fix standalone "I" (or lowercase if needed)
  if (text == 'I ') {
    return 'eye '; // Adding space often fixes TTS mispronunciation
  }

  // Add more special cases here if needed
  // e.g., if (text == 'A') return 'A ';

  return text;
  }

  @override
  Future<void> stop() async {
    try {
      await _methodChannel.invokeMethod('stop');
      // Native will send didCancel; we also mark done as fail-safe:
      notifyDone();
    } catch (e) {
      print("Error stopping TTS: $e");
      notifyDone();
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _methodChannel.invokeMethod('pause');
      // Native delegate will send onPause -> isSpeaking=false
    } catch (e) {
      print("Error pausing TTS: $e");
    }
  }

  @override
  Future<void> resume() async {
    try {
      await _methodChannel.invokeMethod('resume');
      // Native delegate will send onResume -> isSpeaking=true
    } catch (e) {
      print("Error resuming TTS: $e");
    }
  }

  @override
  Future<void> setPitch(double pitch) async {
    _currentPitch = pitch;
  }

  @override
  Future<void> setRate(double rate) async {
    _currentRate = rate;
  }

  @override
  Future<List<dynamic>> getVoices() async {
    final voices = await _methodChannel.invokeMethod<List>('getVoices');
    return voices ?? [];
  }

  @override
  Future<void> setVoice(Map<String, String> voice) async {
    if (voice.containsKey('identifier')) {
      _currentVoiceIdentifier = voice['identifier'];
    }
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    await _methodChannel.invokeMethod('setLanguage', {'language': languageCode});
  }

  @override
  Future<void> configureVoice({
    required String voiceID,
    required double rate,
    required double pitch,
  }) async {
    _currentVoiceIdentifier = voiceID;
    _currentRate = rate;
    _currentPitch = pitch;
  }

  @override
  Stream<Map<String, dynamic>> get wordStream => _highlighter.wordStream;
}

class TtsHighlighter {
  static const EventChannel _eventChannel =
      EventChannel("tts_highlighter_events");

  Stream<Map<String, dynamic>> get wordStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      print('TTS Highlighter event received');
      return Map<String, dynamic>.from(event);
    });
  }
}