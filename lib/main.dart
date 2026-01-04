import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Screens/home.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_pops.dart';
import 'package:flutterkeysaac/Variables/variables.dart'; 
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_factory.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'dart:async';
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
    print('initSherpaOnnx $sherpaOnnxInitialized');
    if (!sherpaOnnxInitialized) {
    sherpa_onnx.initBindings();

      for (final lang in Sv4rs.myLanguages){
        if (Vv4rs.myEngineForVoiceLang[lang] == 'sherpa-onnx') {
          sherpaOnnxSynth[lang]?.free();
          sherpaOnnxSynth[lang] = await SherpaOnnxV4rs.loadSherpaOnnxEngine(lang);
        }
      }
      openTtsPlayerSherpaOnnx = AudioPlayer();

      setState(() {
        sherpaOnnxInitialized = true;
      });
    }
  }
  
  Future<void> initSpeakSelectSherpaOnnx() async {
    print('initSherpaOnnxSS $speakSelectSherpaOnnxInitialized');
    if (!speakSelectSherpaOnnxInitialized) {
      
      sherpa_onnx.initBindings();

      for (final lang in Sv4rs.myLanguages){
        if (Vv4rs.myEngineForSSVoiceLang[lang] == 'sherpa-onnx') {
          speakSelectSherpaOnnxSynth[lang]?.free();
          speakSelectSherpaOnnxSynth[lang] = await SherpaOnnxV4rs.loadSherpaOnnxSSEngine(lang);
        }
      }
      openTtsPlayerSpeakSelectSherpaOnnx = AudioPlayer();

      setState(() {
        speakSelectSherpaOnnxInitialized = true;
      });

      print('initSherpaOnnxSS $speakSelectSherpaOnnxInitialized');
    }
  }

  Future<void> reloadSherpaOnnx(bool forSS) async {
    sherpa_onnx.initBindings();

    if (forSS){
      speakSelectSherpaOnnxInitialized = false;
      for (final lang in Sv4rs.myLanguages){
        speakSelectSherpaOnnxSynth[lang]?.free();
        speakSelectSherpaOnnxSynth[lang] = await SherpaOnnxV4rs.loadSherpaOnnxSSEngine(lang);
      }
      openTtsPlayerSpeakSelectSherpaOnnx = AudioPlayer();
      speakSelectSherpaOnnxInitialized = true;
    } 

    else {
      sherpaOnnxInitialized = false;
      for (final lang in Sv4rs.myLanguages){
        sherpaOnnxSynth[lang]?.free();
        sherpaOnnxSynth[lang] = await SherpaOnnxV4rs.loadSherpaOnnxEngine(lang);
      }
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
             return GestureDetector( 
                  behavior: HitTestBehavior.translucent,
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
                      showOptionsPopupForSpeakOnSelect(context, optionLabels: [
                        "Interface Buttons", 
                        "Navigation Buttons", 
                        "Grammer Buttons",
                        "Sub-Folder Buttons", 
                        "Buttons", 
                        "Typing Keys", 
                        "Folder Buttons", 
                        "Pocket Folder", 
                        "Audio Tile" 
                      ], 
                      optionValues: [
                        Sv4rs.speakInterfaceButtonsOnSelect, 
                        V4rs.intToBool(Bv4rs.navRowSpeakOnSelect),
                        V4rs.intToBool(Bv4rs.grammerRowSpeakOnSelect),
                        V4rs.intToBool(Bv4rs.subFolderSpeakOnSelect),
                        V4rs.intToBool(Bv4rs.buttonSpeakOnSelect),
                        V4rs.intToBool(Bv4rs.typingKeySpeakOnSelect),
                        V4rs.intToBool(Bv4rs.folderSpeakOnSelect),
                        V4rs.intToBool(Bv4rs.pocketFolderSpeakOnSelect),
                        V4rs.intToBool(Bv4rs.audioTileSpeakOnSelect),
                      ], onDone: (newVal) {
                        setState(() {
                          Sv4rs.speakInterfaceButtonsOnSelect = newVal[0];
                          Sv4rs.saveSpeakInterfaceButtonsOnSelect(newVal[0]);
                          Bv4rs.navRowSpeakOnSelect = V4rs.boolToInt2(newVal[1]);
                          Bv4rs.saveNavRowSpeakOnSelect(V4rs.boolToInt2(newVal[1]));
                          Bv4rs.grammerRowSpeakOnSelect = (V4rs.boolToInt3(newVal[2]));
                          Bv4rs.savegrammerRowSpeakOnSelect(V4rs.boolToInt2(newVal[2]));
                          Bv4rs.subFolderSpeakOnSelect = V4rs.boolToInt2(newVal[3]);
                          Bv4rs.saveSubFolderSpeakOnSelect(V4rs.boolToInt2(newVal[3]));
                          Bv4rs.buttonSpeakOnSelect = V4rs.boolToInt3(newVal[4]);
                          Bv4rs.saveButtonSpeakOnSelect(V4rs.boolToInt3(newVal[4]));
                          Bv4rs.typingKeySpeakOnSelect = V4rs.boolToInt3(newVal[5]);
                          Bv4rs.savetypingKeySpeakOnSelect(V4rs.boolToInt3(newVal[5]));
                          Bv4rs.folderSpeakOnSelect = V4rs.boolToInt2(newVal[6]);
                          Bv4rs.savefolderSpeakOnSelect(V4rs.boolToInt2(newVal[6]));
                          Bv4rs.pocketFolderSpeakOnSelect = V4rs.boolToInt3(newVal[7]);
                          Bv4rs.savepocketFolderSpeakOnSelect(V4rs.boolToInt3(newVal[7]));
                          Bv4rs.audioTileSpeakOnSelect = V4rs.boolToInt2(newVal[8]);
                          Bv4rs.saveaudioTileSpeakOnSelect(V4rs.boolToInt2(newVal[8]));
                        });
                      }
                      );
                    }
                  },
                  child: Home(
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
                  )
                );
            }
          );
        }
      ),
    );
  }
}
      