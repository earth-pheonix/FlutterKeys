import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Screens/screens.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart'; 
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_factory.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';
import 'dart:async';
import 'package:flutterkeysaac/Screens/editor.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'package:flutterkeysaac/Variables/sherpa_onnx_tts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await V4rs.loadSavedValues();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key}); 

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  TTSInterface? synth;

  bool synthInitialized = false;
  bool speakSelectSherpaOnnxInitialized = false;
  bool sherpaOnnxInitialized = false;

  Map<String, sherpa_onnx.OfflineTts?> sherpaOnnxSynth = {};
  Map<String, sherpa_onnx.OfflineTts?> speakSelectSherpaOnnxSynth = {};

  late AudioPlayer openTtsPlayerSherpaOnnx;
  late AudioPlayer openTtsPlayerSpeakSelectSherpaOnnx;

  int? _highlightStart;
  int? _highlightLength;
  StreamSubscription? _doneSub;

  @override
  void initState() {
    super.initState();
    initSynth();
    initSherpaOnnx();
    initSpeakSelectSherpaOnnx();
  }

  Future<void> initSherpaOnnx() async {
    if (!sherpaOnnxInitialized) {

      for (final lang in Sv4rs.myLanguages) {
        if (Vv4rs.myEngineForVoiceLang[lang] == 'sherpa-onnx') {
          await SherpaOnnxV4rs.loadSherpaOnnxEngine(lang);
        }
      }

      openTtsPlayerSherpaOnnx = AudioPlayer();

      setState(() {
        sherpaOnnxInitialized = true;
      });
    }
  }
  
  Future<void> initSpeakSelectSherpaOnnx() async {
    if (!speakSelectSherpaOnnxInitialized) {

      for (final lang in Sv4rs.myLanguages) {
        if (Vv4rs.myEngineForSSVoiceLang[lang] == 'sherpa-onnx') {
          await SherpaOnnxV4rs.loadSherpaOnnxSSEngine(lang);
        }
      }

      openTtsPlayerSpeakSelectSherpaOnnx = AudioPlayer();

      setState(() {
        speakSelectSherpaOnnxInitialized = true;
      });
    }
  }

  Future<void> reloadSherpaOnnx(bool forSS) async {

  if (forSS) {

    speakSelectSherpaOnnxInitialized = false;

    for (final lang in Sv4rs.myLanguages) {
      if (Vv4rs.myEngineForSSVoiceLang[lang] == 'sherpa-onnx') {
        await SherpaOnnxV4rs.loadSherpaOnnxSSEngine(lang);
      }
    }

    await openTtsPlayerSpeakSelectSherpaOnnx.stop();
    await openTtsPlayerSpeakSelectSherpaOnnx.dispose();
    openTtsPlayerSpeakSelectSherpaOnnx = AudioPlayer();

    speakSelectSherpaOnnxInitialized = true;

  } else {

    sherpaOnnxInitialized = false;

    for (final lang in Sv4rs.myLanguages) {
      if (Vv4rs.myEngineForVoiceLang[lang] == 'sherpa-onnx') {
        await SherpaOnnxV4rs.loadSherpaOnnxEngine(lang);
      }
    }

    await openTtsPlayerSherpaOnnx.stop();
    await openTtsPlayerSherpaOnnx.dispose();
    openTtsPlayerSherpaOnnx = AudioPlayer();

    sherpaOnnxInitialized = true;
  }
}

  Future<void> initSynth() async {
    final s = await TTSFactory.getTTS(languageCode: V4rs.selectedLanguage.value);

    if (!mounted) return;

    setState(() {
      synth = s;
      synthInitialized = true;
      Vv4rs.loadSystemVoices(s);
    });

    // Listen for speech done events
    _doneSub = synth?.onDone.listen((_) {
      if (!mounted) return;
      setState(() {
        _highlightStart = null;
        _highlightLength = null;
      });
    });
  }
  
  @override
  void dispose() {
    _doneSub?.cancel();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FlutterKeysAAC',
      home: Builder(
        builder: (context) {
          if (!synthInitialized 
            || !speakSelectSherpaOnnxInitialized
            || !sherpaOnnxInitialized
          ) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          return AnimatedBuilder(
            animation: Listenable.merge([
              V4rs.showExpandPage,
              V4rs.showSettings,
              Ev4rs.showEditor,
              V4rs.doOnboarding,
            ]), 
            builder: (context, _) {
              if (!Ev4rs.showEditor.value){
             return Screens(
                    synth: synth!,
                    highlightLength: _highlightLength,
                    highlightStart: _highlightStart,
                    sherpaOnnxSynth: sherpaOnnxSynth,
                    openTTSPlayer: openTtsPlayerSherpaOnnx,
                    init: initSherpaOnnx,
                    speakSelectSherpaOnnxSynth: speakSelectSherpaOnnxSynth,
                    initForSS: initSpeakSelectSherpaOnnx,
                    playerForSS: openTtsPlayerSpeakSelectSherpaOnnx,
                    reloadSherpaOnnx: reloadSherpaOnnx,
                  );
              } 
              else {
            return Editor(
              synth: synth!,
              speakSelectSherpaOnnxSynth: speakSelectSherpaOnnxSynth,
              initForSS: initSpeakSelectSherpaOnnx,
              playerForSS: openTtsPlayerSpeakSelectSherpaOnnx,
            );
              }
            }
          );
        }
      ),
    );
  }
}
      