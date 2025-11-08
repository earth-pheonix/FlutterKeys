import 'package:flutter/foundation.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'dart:async';

class DummyTTS implements TTSInterface {
    @override
  Stream<Map<String, dynamic>> get wordStream => const Stream.empty();

  final StreamController<void> _doneController = StreamController.broadcast();

  @override
  Stream<void> get onDone => _doneController.stream;

  @override
  void notifyDone() {
    isSpeaking.value = false;
    _doneController.add(null);
  }

  @override
  void notifyStart() {
    isSpeaking.value = true;
  }

  @override
  Future<void> speak(String text) async {
    // do nothing
  }

  @override
  Future<void> stop() async {
    // do nothing
  }

  @override
  Future<void> pause() async {
    // do nothing
  }

  @override
  Future<void> resume() async {
    // do nothing
  }

  @override
  Future<void> setPitch(double pitch) async {
    // do nothing
  }

  @override
  Future<void> setRate(double rate) async {
    // do nothing
  }

  @override
  Future<void> setVoice(Map<String, String> voiceID) async {
    // do nothing
  }

  @override
  Future<void> setLanguage(String languageCode) async {
    // do nothing
  }

  @override
  Future<void> configureVoice({
    required String voiceID,
    required double rate,
    required double pitch,
  }) async {
    // do nothing
  }

  @override
  Future<List<dynamic>> getVoices() async {
    return []; // return empty list
  }
  @override
  ValueNotifier<bool> isSpeaking = ValueNotifier(false);
}