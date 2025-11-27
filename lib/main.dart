import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Screens/editor.dart';
import 'package:flutterkeysaac/Screens/onboarding.dart'; 
import 'package:flutterkeysaac/Screens/home.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/variables.dart'; 
import 'package:flutterkeysaac/Screens/expand_page.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/tts/tts_factory.dart';
import 'package:flutterkeysaac/Variables/settings_variable.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'dart:async';


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

  int? _highlightStart;
  int? _highlightLength;
  StreamSubscription? _wordSub;
  StreamSubscription? _doneSub;

  @override
  void initState() {
    super.initState();
    initSynth();
  }

  Future<void> initSynth() async {
    final s = await TTSFactory.getTTS(languageCode: V4rs.selectedLanguage.value);

    if (!mounted) return;

    setState(() {
      synth = s;
      synthInitialized = true;
    });

    // Listen for word events (highlighting)
    subscribeWordStream();

    // Listen for speech done events
    _doneSub = synth?.onDone.listen((_) {
      if (!mounted) return;
      setState(() {
        _highlightStart = null;
        _highlightLength = null;
      });
    });
  }

  void subscribeWordStream() {
    if (synth?.wordStream == null) return;

    _wordSub = synth!.wordStream.listen((event) {
      if (!mounted) return;

      setState(() {
        _highlightStart = event['start'] as int?;
        _highlightLength = event['length'] as int?;
      });
    });
  }

  @override
  void dispose() {
    _wordSub?.cancel();
    _doneSub?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'FlutterKeysAAC',
      home: Builder(
        builder: (context) {

            if (!synthInitialized) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          
          return AnimatedBuilder(
            animation: Listenable.merge([
              V4rs.doOnboarding,
              V4rs.showExpandPage,
              V4rs.showSettings,
              Ev4rs.showEditor,
            ]), 
            builder: (context, _) {
            //=====: onboarding :====
              if (V4rs.doOnboarding.value) {
                return Onboarding();
            //=====: expand page :====
              } else if (V4rs.showExpandPage.value) {
                return ExpandPage();
            //=====: editor :====
              } else if (Ev4rs.showEditor.value) {
                return Editor(
                  synth: synth!
                );
              }
             //=====: home :====
              else {
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
                  )
                );
              }
            }
          );
        }
      ),
    );
  }
}
      