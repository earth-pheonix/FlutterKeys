import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';
import 'package:flutterkeysaac/Variables/settings/bookmark_voice.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutterkeysaac/Models/manifest_model.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'dart:io'; //platform


class TopRowForSettings extends StatefulWidget {
  final TTSInterface synth;
  final Root root;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const TopRowForSettings({
    super.key,
    required this.synth,
    required this.root,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
    });

  @override
  State<TopRowForSettings> createState() => _TopRowForSettings();
}

class _TopRowForSettings extends State<TopRowForSettings> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return //back & edit
      Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              0, 
              V4rs.paddingValue(10), 
              V4rs.paddingValue(10), 
              V4rs.paddingValue(20)),
            child: SizedBox(
              height: 50,
              width: 75,
              child: ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iBack.png',
                onPressed: () {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                    V4rs.speakOnSelect(
                      'back', 
                      V4rs.selectedLanguage.value, 
                      widget.synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                      );
                    }
                  V4rs.showSettings.value = false;
                   },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              V4rs.paddingValue(5), 
              V4rs.paddingValue(10), 
              V4rs.paddingValue(5), 
              V4rs.paddingValue(20)),
            child: SizedBox(
              height: 50,
              width: 60,
              child: ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iEdit.png',
                onPressed: () {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                    V4rs.speakOnSelect(
                      'edit', 
                      V4rs.selectedLanguage.value, 
                      widget.synth, 
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                      );
                    }
                    Ev4rs.updateJsonHistory(widget.root);
                    
                  V4rs.showSettings.value = false;
                  Ev4rs.showEditor.value = true;
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              V4rs.paddingValue(5), 
              V4rs.paddingValue(10), 
              V4rs.paddingValue(5), 
              V4rs.paddingValue(20)
            ),
            child: SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton(onPressed: (){ setState(() {
                  V4rs.deleteLocalCopy();
              });
              }, 
              child: Text('Reset JSON'))
            ),
          ),
        ],
      );
  }
}


class OpenWelcomeScreen extends StatefulWidget {
  final TTSInterface synth;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const OpenWelcomeScreen({
    super.key, 
    required this.synth,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });

  @override
  State<OpenWelcomeScreen> createState() => _OpenWelcomeScreen();
}

class _OpenWelcomeScreen extends State<OpenWelcomeScreen> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            color: Cv4rs.themeColor4,
            child: TextButton(
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft
              ),
              child: Text('Open welcome screen', style: Sv4rs.settingslabelStyle),
              onPressed: ()  {
                  if (Sv4rs.speakInterfaceButtonsOnSelect) {
                    V4rs.speakOnSelect(
                      'open welcome screen', 
                      V4rs.selectedLanguage.value, 
                      widget.synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                  }
                setState(() {
                  V4rs.doOnboarding.value = true;
                  V4rs.setOnboardingCompleteStatus(false);
                });
              }, 
              ),
          ),
        ),
      ]
    );
  }
}

class VoicePicker extends StatefulWidget {
  final TTSInterface synth;
  final double totalWidth;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;
  final Future<void> Function(bool) reloadSherpaOnnx;

  const VoicePicker({
    super.key, 
    required this.synth,
    required this.totalWidth,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
    required this.reloadSherpaOnnx,
    });

  @override
  State<VoicePicker> createState() => _VoicePicker();
}

class _VoicePicker extends State<VoicePicker> with WidgetsBindingObserver {

  double pitchValue = 1.0;
  double rateValue = 0.5;
  double lengthScale = 1.0;
  int deleteValue = 0;
  late AudioPlayer wavSamplePlayer;

  @override
  void initState() {
    super.initState();
    Vv4rs.setupIsDownloadingListener();
    wavSamplePlayer = AudioPlayer();
    for (var language in Sv4rs.myLanguages) {
      Vv4rs.setupSystemVoicePicker(language, 'default');
      Vv4rs.setupSherpaOnnxVoicePicker(language);
    }
  }

  @override
  void dispose() {
    wavSamplePlayer.dispose();
    super.dispose();
  }

  Widget engineDropdown(){
    return ListTile(
      title: Text('TTS Engine:', style: Sv4rs.settingslabelStyle),
      trailing: DropdownButton<String>(
        value: Sv4rs.pickFromEngine,
        onChanged: (value) {
          setState(() {
            if (value != null){
              Sv4rs.pickFromEngine = value;
              Sv4rs.savePickFromEngine(value);
            }
          });
        },
        items: [
          DropdownMenuItem<String>(
            value: 'system',
            child: Text('System', style: Sv4rs.settingslabelStyle),
          ),
          DropdownMenuItem<String>(
            value: 'sherpa-onnx',
            child: Text('sherpa-onnx', style: Sv4rs.settingslabelStyle),
          ),
        ],
      ),
    );
  }

  Widget systemVoiceDropdown(bool forSS, String language, var dropdownValue) {
    return Row(children: [
        Text('Voice', style: Sv4rs.settingslabelStyle),
        Spacer(),
        Expanded(
          flex: V4rs.xSmallModeWidth ? 2 : 1,
          child: DropdownButton<String>(
            isExpanded: true,
            value: dropdownValue,
            onChanged: (value) async {
            //set the selected voice to the language
              setState(() {
                if (value != null) {
                  if (forSS){
                    Vv4rs.setSSlanguageVoiceSystem(
                      language, 
                      value, 
                      "system", 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.pitch, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.rate, 
                    );
                  } else {
                    Vv4rs.setlanguageVoiceSystem(
                      language, 
                      value, 
                      "system", 
                      Vv4rs.systemLanguageVoice[language]?.pitch, 
                      Vv4rs.systemLanguageVoice[language]?.rate, 
                    );
                  }
                }
              }
              );
            },
            items: [
              DropdownMenuItem<String>(
                value: 'default',
                child: Text('default', style: Sv4rs.settingslabelStyle, maxLines: 3,),
              ),

              ...Vv4rs.uniqueSystemVoices[language]!.map((voice) {
                final identifier = voice['identifier']!.toString(); // <-- cast to String
                return DropdownMenuItem<String>(
                  value: identifier,
                  child: Text(Vv4rs.cleanSystemVoiceLabel(voice), style: Sv4rs.settingslabelStyle, maxLines: 3,),
                );
              }),
            ],
        ),
      ),
      ]
    );
  }

  Widget sherpaOnnxVoiceDropdown(bool forSS, String language, var dropdownValue) {
    
    int findSampleSpeakerDropdownCount() {
        if (Vv4rs.sampleSherpaOnnx == null){
          return Vv4rs.sherpaOnnxLanguageVoice[language]?.speakerCount ?? 1;
        } else {
          return Vv4rs.sampleSherpaOnnx?.speakerCount ?? 1;
        }
      }

    int speakerDropdownCount = findSampleSpeakerDropdownCount();

    //select sample voice as voice
    Future<void> selectSampleVoice(bool forSS){
      if(forSS){
        return Vv4rs.setSSlanguageVoiceSherpaOnnx(
          language, 
          Vv4rs.sampleSherpaOnnx?.id, 
          Vv4rs.sampleSherpaOnnx?.engine, 
          Vv4rs.sampleSherpaOnnx?.tokenPath, 
          Vv4rs.sampleSherpaOnnx?.modelPath,
          Vv4rs.sampleSherpaOnnx?.speakerCount,
          Vv4rs.sampleSpeaker,
          Vv4rs.sherpaOnnxSSLanguageVoice[language]?.lengthScale, 
          Vv4rs.sampleSherpaOnnx?.speakers,
          Vv4rs.sampleSherpaOnnx?.lexicon,
          Vv4rs.sampleSherpaOnnx?.ruleFars,
          Vv4rs.sampleSherpaOnnx?.ruleFsts,
          Vv4rs.sampleSherpaOnnx?.voicesBin,
          Vv4rs.sampleSherpaOnnx?.eSpeakPath,
        );
        } else {
        return Vv4rs.setlanguageVoiceSherpaOnnx(
          language, 
          Vv4rs.sampleSherpaOnnx?.id, 
          Vv4rs.sampleSherpaOnnx?.engine, 
          Vv4rs.sampleSherpaOnnx?.tokenPath, 
          Vv4rs.sampleSherpaOnnx?.modelPath,
          Vv4rs.sampleSherpaOnnx?.speakerCount,
          Vv4rs.sampleSpeaker,
          Vv4rs.sherpaOnnxLanguageVoice[language]?.lengthScale, 
          Vv4rs.sampleSherpaOnnx?.speakers,
          Vv4rs.sampleSherpaOnnx?.lexicon,
          Vv4rs.sampleSherpaOnnx?.ruleFars,
          Vv4rs.sampleSherpaOnnx?.ruleFsts,
          Vv4rs.sampleSherpaOnnx?.voicesBin,
          Vv4rs.sampleSherpaOnnx?.eSpeakPath,
        );
      }
    }
    
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(20)), 
      child: Column(children: [
        Row(children: [
          Text('Voice', style: Sv4rs.settingslabelStyle),
          Spacer(),
          //
          //Pick Voice to sample
          //
          Expanded(
            flex: V4rs.xSmallModeWidth ? 2 : 1,
            child: 
            DropdownButton<ManifestModel?>(
              isExpanded: true,
              value: dropdownValue,
              onChanged: (value) async {
                setState(() {
                  if (value != null) {
                    Vv4rs.sampleSpeaker = 0;
                    Vv4rs.sampleSherpaOnnx = value;
                    findSampleSpeakerDropdownCount();
                  }
                }
                );
              },
              items: [
                DropdownMenuItem<ManifestModel?>(
                  value: null,
                  child:Text('none', style: Sv4rs.settingslabelStyle),
                ),

                ...Vv4rs.perLangSherpaOnnxVoices[language]!.map((voice) {
                  return DropdownMenuItem<ManifestModel>(
                    value: voice,
                    child: Text(
                      Vv4rs.cleanSherpaOnnxVoiceLabel(voice), 
                      style: Sv4rs.settingslabelStyle,
                      maxLines: 3,
                    ),
                  );
                }),
              ],
            ),
          ),
        //
        //Pick Speaker (if more than one) to sample
        //
        

          if (speakerDropdownCount > 1)
          Expanded(
            flex: 1,
            child: 
          Padding(padding: EdgeInsetsGeometry.fromLTRB(V4rs.paddingValue(20),0,0,0), child:
            DropdownButton<int>(
              isExpanded: true,
              value: Vv4rs.sampleSpeaker, 
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    Vv4rs.sampleSpeaker = value;
                  });
                }
              },
              items: List.generate(
                speakerDropdownCount,
                (index) {
                  final speaker = (forSS) 
                    ? (Vv4rs.sampleSherpaOnnx != null)
                        ? Vv4rs.sampleSherpaOnnx!.speakers![index]
                        : (Vv4rs.sherpaOnnxLanguageVoice[language]?.speakers?[index] ?? 0)
                    : (Vv4rs.sampleSherpaOnnx != null)
                        ? Vv4rs.sampleSherpaOnnx!.speakers![index]
                        : (Vv4rs.sherpaOnnxSSLanguageVoice[language]?.speakers?[index] ?? 0);

                  return DropdownMenuItem<int>(
                    value: speaker["idSpeaker"], 
                    child: Text(
                      "${speaker["name"]} (${speaker["idSpeaker"]})",
                      style: Sv4rs.settingslabelStyle,
                    ),
                  );
                },
              ),
            ) )
          ),
        ],
        ),
        Row( 
          children: [
          Spacer(),

          //
          //downloading info
          //
          ValueListenableBuilder(
            valueListenable: Vv4rs.downloadMessage, 
            builder: (context, message, _) {
              return Text(
                message, 
                style: Fv4rs.interfacelabelStyle,
              );
            }
          ),

          //
          //Sample
          //
          Padding(padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)), child:
          SizedBox(height: 40, width: widget.totalWidth * 0.1,
            child: ButtonStyle1(
              imagePath: 'assets/interface_icons/interface_icons/iPlay.png',
              onPressed: () async {
                if (Vv4rs.sampleSherpaOnnx != null){
                  if (Vv4rs.sampleSherpaOnnx!.speakerCount != null && Vv4rs.sampleSherpaOnnx!.speakerCount! > 1){
                    //find the speaker
                    final selectedSpeaker = Vv4rs.sampleSherpaOnnx!.speakers!
                      .firstWhere((speaker) => speaker["idSpeaker"] == Vv4rs.sampleSpeaker);

                    final samplePath = selectedSpeaker["sample_path"] as String?;

                    //play sample 
                    if (samplePath != null) {
                      await wavSamplePlayer.play(AssetSource(samplePath));
                    }
                  } else if (Vv4rs.sampleSherpaOnnx!.samplePath != null){
                    //play sample from single speaker voice
                      await wavSamplePlayer.play(AssetSource(Vv4rs.sampleSherpaOnnx!.samplePath ?? ''));
                  }
                }
              },
            ),
          ),
          ),

          //
          //Select
          //
          Padding(padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)), child:
            ValueListenableBuilder(
              valueListenable: Vv4rs.isDownloading, 
              builder: (context, isDownloading, _) {
                return Stack( 
                  children: [
                    (!isDownloading) 
                    ? SizedBox(height: 40, width: widget.totalWidth * 0.1,
                        child: ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png',
                        onPressed: () async {
                          if (Vv4rs.sampleSherpaOnnx != null) {
                            if (!Vv4rs.downloadedSherpaOnnxLanguageVoice.contains(Vv4rs.sampleSherpaOnnx)){
                              await Vv4rs.downloadSherpaOnnxVoice(Vv4rs.sampleSherpaOnnx!);
                            } 
                            selectSampleVoice(forSS); //for ss is built into this func
                            if (forSS){
                              setState(() { 
                                Vv4rs.myEngineForSSVoiceLang[language] = Vv4rs.sherpaOnnxSSLanguageVoice[language]!.engine;
                                Vv4rs.saveMyEngineForSSVoiceLang(language, null, Vv4rs.myEngineForSSVoiceLang[language]);
                              });
                            } else {
                              setState(() { 
                                Vv4rs.myEngineForVoiceLang[language] = Vv4rs.sherpaOnnxLanguageVoice[language]!.engine;
                                Vv4rs.saveMyEngineForVoiceLang(language, true, 'sherpa-onnx');
                              });
                            }
                            widget.reloadSherpaOnnx(forSS);
                            if (forSS == false && Sv4rs.useDifferentVoiceforSS){
                              selectSampleVoice(true);
                              setState(() { 
                                Vv4rs.myEngineForSSVoiceLang[language] = Vv4rs.sherpaOnnxSSLanguageVoice[language]!.engine;
                              });
                              widget.reloadSherpaOnnx(true);
                            }
                          }
                        },
                      )
                      )
                    : Center(child:
                        CircularProgressIndicator(),
                      ),
                  ],
                );
              }
            ),
          ),
         ],
        )
      
      ]
      ),
    );
  }

  Widget systemRateSlider(bool forSS, String language){
   return Padding(
      padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
      child: Row(
        children: [

          Text(
            (forSS)
              ? 'Rate: ${Vv4rs.getSystemSSValue(language, 'rate')}'
              : 'Rate: ${Vv4rs.getSystemValue(language, 'rate')}',
            style: Sv4rs.settingslabelStyle,
          ),

          Expanded(child: SizedBox(width: widget.totalWidth,
            child: Slider(
            value: (forSS)
              ? Vv4rs.getSystemSSValue(language, 'rate')
              : Vv4rs.getSystemValue(language, 'rate'),
            min: 0.0,
            max: (Platform.isIOS) ? 1.0 : 2.0,
            divisions: 20,
            activeColor: Cv4rs.themeColor1,
            inactiveColor: Cv4rs.themeColor3,
            thumbColor: Cv4rs.themeColor1,
            label: (forSS)
              ? 'Voice Rate: ${Vv4rs.getSystemSSValue(language, 'rate')}'
              : 'Voice Rate: ${Vv4rs.getSystemValue(language, 'rate')}',
            onChanged: (value) async {
              setState(() {
                rateValue = double.parse(value.toStringAsFixed(2));

                (forSS)
                  ? Vv4rs.setSSlanguageVoiceSystem(
                      language, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.voice, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.engine, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.pitch, 
                      value, 
                    )
                  : Vv4rs.setlanguageVoiceSystem(
                      language, 
                      Vv4rs.systemLanguageVoice[language]?.voice, 
                      Vv4rs.systemLanguageVoice[language]?.engine, 
                      Vv4rs.systemLanguageVoice[language]?.pitch, 
                      value, 
                    );
              });
            },
          ),
          ),
          ),
        ],
      ),
    );
  }

  Widget systemPitchSlider(bool forSS, String language){
   return Padding(
      padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
      child: Row(
        children: [

          Text(
            (forSS)
              ? 'Pitch: ${Vv4rs.getSystemSSValue(language, 'pitch')}'
              : 'Pitch: ${Vv4rs.getSystemValue(language, 'pitch')}',
            style: Sv4rs.settingslabelStyle,
          ),

          Expanded(child: SizedBox(width: widget.totalWidth,
            child: Slider(
            value: (forSS)
              ? Vv4rs.getSystemSSValue(language, 'pitch')
              : Vv4rs.getSystemValue(language, 'pitch'),
            min: 0.5,
            max: 2.0,
            divisions: 15,
            activeColor: Cv4rs.themeColor1,
            inactiveColor: Cv4rs.themeColor3,
            thumbColor: Cv4rs.themeColor1,
            label: (forSS)
              ? 'Voice Pitch: ${Vv4rs.getSystemSSValue(language, 'pitch')}'
              : 'Voice Pitch: ${Vv4rs.getSystemValue(language, 'pitch')}',
            onChanged: (value) async {
              setState(() {
                pitchValue = double.parse(value.toStringAsFixed(1));

                (forSS)
                  ? Vv4rs.setSSlanguageVoiceSystem(
                      language, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.voice, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.engine, 
                      pitchValue, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.rate,
                    )
                  : Vv4rs.setlanguageVoiceSystem(
                      language, 
                      Vv4rs.systemLanguageVoice[language]?.voice, 
                      Vv4rs.systemLanguageVoice[language]?.engine,
                      pitchValue, 
                      Vv4rs.systemLanguageVoice[language]?.rate,
                    );
              });
            },
          ),
          ),
          ),
        ],
      ),
    );
  }

  Widget sherpaOnnxRateSlider(bool forSS, String language){
   return Padding(
      padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
      child: Row(
        children: [
          Text(
            (forSS)
              ? 'Rate: ${Vv4rs.getSherpaOnnxValue(language, 'lengthScale', true)}'
              : 'Rate: ${Vv4rs.getSherpaOnnxValue(language, 'lengthScale', false)}',
            style: Sv4rs.settingslabelStyle,
          ),

          Expanded(child: SizedBox(width: widget.totalWidth,
            child: Slider(
            value: (forSS)
              ? Vv4rs.getSherpaOnnxValue(language, 'lengthScale', true)
              : Vv4rs.getSherpaOnnxValue(language, 'lengthScale', false),
            min: 0.5,
            max: 3.0,
            divisions: 50,
            activeColor: Cv4rs.themeColor1,
            inactiveColor: Cv4rs.themeColor3,
            thumbColor: Cv4rs.themeColor1,
            label: (forSS)
              ? 'Voice Rate: ${Vv4rs.getSystemSSValue(language, 'lengthScale')}'
              : 'Voice Rate: ${Vv4rs.getSystemValue(language, 'lengthScale')}',
            onChanged: (value) async {
              setState(() {
                rateValue = double.parse(value.toStringAsFixed(2));

                (forSS)
                  ? Vv4rs.setSSlanguageVoiceSherpaOnnx(
                      language, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.id,
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.engine, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.tokenPath, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.modelVoice, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.speakerCount, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.speakerID, 
                      rateValue,
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.speakers, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.lexicon, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.farFiles, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.fstFiles, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.voicesBin,
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.eSpeakPath,
                    )
                  : Vv4rs.setlanguageVoiceSherpaOnnx(
                      language, 
                      Vv4rs.sherpaOnnxLanguageVoice[language]?.id,
                      Vv4rs.sherpaOnnxLanguageVoice[language]?.engine, 
                      Vv4rs.sherpaOnnxLanguageVoice[language]?.tokenPath, 
                      Vv4rs.sherpaOnnxLanguageVoice[language]?.modelVoice, 
                      Vv4rs.sherpaOnnxLanguageVoice[language]?.speakerCount, 
                      Vv4rs.sherpaOnnxLanguageVoice[language]?.speakerID, 
                      rateValue,
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.speakers, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.lexicon, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.farFiles, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.fstFiles, 
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.voicesBin,
                      Vv4rs.sherpaOnnxSSLanguageVoice[language]?.eSpeakPath,
                    );
              });
            },
          ),
          ),
          ),
        ],
      ),
    );
  }

  Widget testVoiceButton(bool forSS, String language){
   return Padding(
      padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Test Voice', style: Sv4rs.settingslabelStyle,),
          SizedBox(height: 40, width: widget.totalWidth * 0.1, child:
          ButtonStyle1(
            imagePath: 'assets/interface_icons/interface_icons/iPlay.png',
            onPressed: () async {

              if (forSS){
                if (Vv4rs.myEngineForSSVoiceLang[language] == 'system') {
                  
                  final voiceID = Vv4rs.getSystemSSValue(language, 'voice');
                  await widget.synth.setVoice({
                    'identifier': voiceID ?? 'default',
                  });

                  await widget.synth.setRate(Vv4rs.getSystemSSValue(language, 'rate'));
                  await widget.synth.setPitch(Vv4rs.getSystemSSValue(language, 'pitch'));
                  await widget.synth.speak(Vv4rs.testPhrases[language] ?? 'This is a test phrase.');
                  
                } else if (Vv4rs.myEngineForSSVoiceLang[language] == 'sherpa-onnx') {
                  
                }
              } else {
                if (Vv4rs.myEngineForVoiceLang[language] == 'system') {
                  
                  final voiceID = Vv4rs.getSystemValue(language, 'voice');
                  await widget.synth.setVoice({
                    'identifier': voiceID ?? 'default',
                  });

                  await widget.synth.setRate(Vv4rs.getSystemValue(language, 'rate'));
                  await widget.synth.setPitch(Vv4rs.getSystemValue(language, 'pitch'));
                  await widget.synth.speak(Vv4rs.testPhrases[language] ?? 'This is a test phrase.');
                  
                } else if (Vv4rs.myEngineForSSVoiceLang[language] == 'sherpa-onnx') {
                  
                }
              }
            },
          ),
          ),
        ],
      )
    );
  }

  Widget bookmarkButton(String lang, bool forSS) {
    return Padding(
        padding: EdgeInsetsGeometry.all(V4rs.paddingValue(5)), 
        child: ButtonStyle1(
          glow: true,
          padding: !V4rs.xSmallMode ? 5 : 15,
          imagePath: 'assets/interface_icons/interface_icons/iBookmark.png', 
          onPressed: (){
            if (forSS){
              if (Vv4rs.myEngineForVoiceLang[lang] == 'system'){
                BVv4rs.setBookmarkedVoiceSystem(
                  lang,
                  Vv4rs.speakSelectSystemLanguageVoice[lang]?.voice,
                  Vv4rs.speakSelectSystemLanguageVoice[lang]?.engine,
                  Vv4rs.speakSelectSystemLanguageVoice[lang]?.pitch,
                  Vv4rs.speakSelectSystemLanguageVoice[lang]?.rate,
                );
              } else 
              if (Vv4rs.myEngineForVoiceLang[lang] == 'sherpa-onnx'){
                BVv4rs.setBookmarkedVoiceSherpaOnnx(
                  lang, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.id, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.engine, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.tokenPath, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.modelVoice, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.speakerCount, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.speakerID, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.lengthScale, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.speakers, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.lexicon, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.farFiles, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.fstFiles, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.voicesBin, 
                  Vv4rs.sherpaOnnxSSLanguageVoice[lang]?.eSpeakPath
                );
              }
            }
            else {
              if (Vv4rs.myEngineForVoiceLang[lang] == 'system'){
                BVv4rs.setBookmarkedVoiceSystem(
                  lang,
                  Vv4rs.systemLanguageVoice[lang]?.voice,
                  Vv4rs.systemLanguageVoice[lang]?.engine,
                  Vv4rs.systemLanguageVoice[lang]?.pitch,
                  Vv4rs.systemLanguageVoice[lang]?.rate,
                );
              } else 
              if (Vv4rs.myEngineForVoiceLang[lang] == 'sherpa-onnx'){
                BVv4rs.setBookmarkedVoiceSherpaOnnx(
                  lang, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.id, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.engine, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.tokenPath, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.modelVoice, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakerCount, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakerID, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.lengthScale, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakers, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.lexicon, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.farFiles, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.fstFiles, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.voicesBin, 
                  Vv4rs.sherpaOnnxLanguageVoice[lang]?.eSpeakPath
                );
              }
            }
          }
        ), 
    );
  }

  Widget deleteButton(String lang) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Cv4rs.themeColor3,
      ),
      child: (BVv4rs.bookmarkedCount.value[lang] != null
        && BVv4rs.bookmarkedCount.value[lang]! >= 0 )
        ? Row(
        children: [ 
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)), 
              child:Column(
              children: [
                SizedBox(width: !V4rs.xSmallMode? 90 : 60, child: 
                Text('Delete:', style: Sv4rs.settingslabelStyle),
                ),
                SizedBox(width: !V4rs.xSmallMode ? 90 : 60, child: 
                DropdownButton<int>(
                  hint: const Text('###'),
                  value: deleteValue,
                  isExpanded: true,
                  items: List.generate(
                    BVv4rs.bookmarkedCount.value[lang] ?? 0,
                    (index) {
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text('$index'),
                      );
                    },
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value != null){
                        deleteValue = value;
                      }
                    });
                  },
                )
                ),
            ],
            ),
            ),
            SizedBox(width: !V4rs.xSmallModeWidth ? 50 : 30, child: 
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(0, V4rs.paddingValue(10), V4rs.paddingValue(10), V4rs.paddingValue(10)), 
              child: ButtonStyle1(
                glow: true,
                padding: 2,
                imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                onPressed: (){
                  BVv4rs.deleteBookmarked(deleteValue, lang);
                  deleteValue = 0;
                }
              ), 
            ),
            )
          ]
      )
        : SizedBox.shrink()
    );
  }

  Widget bookmarkedRow(String language, bool forSS){
    return ValueListenableBuilder(
      valueListenable: BVv4rs.bookmarkedCount, 
      builder: (context, count, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: !V4rs.xSmallMode ? 100 : 60, 
                  height: !V4rs.xSmallMode ? 60 : 50, 
                  child: bookmarkButton(language, forSS),
                ),
                SizedBox(width: !V4rs.xSmallModeWidth ? 160 : 100, child: 
                deleteButton(language),
                ),
                for (int i=0; i <(BVv4rs.bookmarkedVoices[language]?.length ?? 0); i ++)...[
                  SizedBox(width: !V4rs.xSmallModeWidth ? 250 : 150, child: 
                  ButtonStyle2(
                    flex: 3,
                    maxLines: 3,
                    imagePath: 'assets/interface_icons/interface_icons/iVoice.png', 
                    onPressed: (){
                      setState(() {
                        if (forSS) {
                          Vv4rs.myEngineForSSVoiceLang = BVv4rs.bookmarkedVoices[language]?[i].engine;
                          (BVv4rs.bookmarkedVoices[language]?[i].engine == 'system') 
                            ? Vv4rs.setSSlanguageVoiceSystem(
                              language, 
                              BVv4rs.bookmarkedVoices[language]?[i].voice, 
                              "system", 
                              BVv4rs.bookmarkedVoices[language]?[i].pitch, 
                              BVv4rs.bookmarkedVoices[language]?[i].rate, 
                            )
                            : Vv4rs.setSSlanguageVoiceSherpaOnnx(
                              language, 
                              BVv4rs.bookmarkedVoices[language]?[i].id,
                              BVv4rs.bookmarkedVoices[language]?[i].engine, 
                              BVv4rs.bookmarkedVoices[language]?[i].tokenPath, 
                              BVv4rs.bookmarkedVoices[language]?[i].modelVoice,
                              BVv4rs.bookmarkedVoices[language]?[i].speakerCount,
                              BVv4rs.bookmarkedVoices[language]?[i].speakerID,
                              BVv4rs.bookmarkedVoices[language]?[i].lengthScale, 
                              BVv4rs.bookmarkedVoices[language]?[i].speakers,
                              BVv4rs.bookmarkedVoices[language]?[i].lexicon,
                              BVv4rs.bookmarkedVoices[language]?[i].farFiles,
                              BVv4rs.bookmarkedVoices[language]?[i].fstFiles,
                              BVv4rs.bookmarkedVoices[language]?[i].voicesBin,
                              BVv4rs.bookmarkedVoices[language]?[i].eSpeakPath,
                            );
                        } 
                        else {
                          Vv4rs.myEngineForVoiceLang[language] = BVv4rs.bookmarkedVoices[language]?[i].engine;
                          if (BVv4rs.bookmarkedVoices[language]?[i].engine == 'system') {
                              Vv4rs.setlanguageVoiceSystem(
                                language, 
                                BVv4rs.bookmarkedVoices[language]?[i].voice, 
                                "system", 
                                BVv4rs.bookmarkedVoices[language]?[i].pitch, 
                                BVv4rs.bookmarkedVoices[language]?[i].rate, 
                              );
                            } 
                            else {
                            Vv4rs.setlanguageVoiceSherpaOnnx(
                              language, 
                              BVv4rs.bookmarkedVoices[language]?[i].id,
                              BVv4rs.bookmarkedVoices[language]?[i].engine, 
                              BVv4rs.bookmarkedVoices[language]?[i].tokenPath, 
                              BVv4rs.bookmarkedVoices[language]?[i].modelVoice,
                              BVv4rs.bookmarkedVoices[language]?[i].speakerCount,
                              BVv4rs.bookmarkedVoices[language]?[i].speakerID,
                              BVv4rs.bookmarkedVoices[language]?[i].lengthScale ?? 1.0, 
                              BVv4rs.bookmarkedVoices[language]?[i].speakers,
                              BVv4rs.bookmarkedVoices[language]?[i].lexicon,
                              BVv4rs.bookmarkedVoices[language]?[i].farFiles,
                              BVv4rs.bookmarkedVoices[language]?[i].fstFiles,
                              BVv4rs.bookmarkedVoices[language]?[i].voicesBin,
                              BVv4rs.bookmarkedVoices[language]?[i].eSpeakPath,
                            );
                            widget.reloadSherpaOnnx(forSS);
                            print('done'); //done
                          }
                        }
                      });
                    },
                    label: 
                    (BVv4rs.bookmarkedVoices[language]?[i] != null)
                      ? (BVv4rs.bookmarkedVoices[language]?[i].engine == 'system') 
                        ? '$i: ${ //name
                            BVv4rs.findSystemVoiceName(language, BVv4rs.bookmarkedVoices[language]?[i].voice)
                          } - Pitch: ${
                            BVv4rs.bookmarkedVoices[language]?[i].pitch ?? 1.0
                          } - Rate: ${
                            BVv4rs.bookmarkedVoices[language]?[i].rate ?? ((Platform.isIOS) ? 0.5 : 1.0)
                          }'
                        : '$i - ${ //name
                            BVv4rs.findSherpaVoiceName(language, BVv4rs.bookmarkedVoices[language]?[i].id)
                          } - Speaker: ${
                            BVv4rs.bookmarkedVoices[language]?[i].speakerID ?? 0
                          } - Rate: ${
                            BVv4rs.bookmarkedVoices[language]?[i].lengthScale ?? 1.0
                          }'
                      : '$i error' 
                  ),
                ),
                ], 
                SizedBox(width: widget.totalWidth - 160)
              ],
            ),
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Voice:', 
        style: Sv4rs.settingslabelStyle
       ),
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
      onExpansionChanged: (bool expanded) {  
        if (Sv4rs.speakInterfaceButtonsOnSelect) {
            V4rs.speakOnSelect(
              'voice', 
              V4rs.selectedLanguage.value, 
              widget.synth,
              widget.speakSelectSherpaOnnxSynth,
              widget.initForSS,
              widget.playerForSS,
            );
          }},
      children: [

        //
        //Note for users
        //
        Row(children: [ 
          Expanded(
            child: Padding( 
              padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
              child: Text(
                'users should not rely on default voices- please manually select a voice for each language.', 
                style: Sv4rs.settingsSecondaryLabelStyle,
               ),
              ),
            ),
          ]
        ),

        //
        //Voices per Language
        //

        ...Sv4rs.myLanguages.map((language){

          
          if (
            Vv4rs.systemVoices.isEmpty || 
            Vv4rs.uniqueSystemVoices.isEmpty || 
            Vv4rs.perLangSherpaOnnxVoices.isEmpty
          ){
            return CircularProgressIndicator();
          }  else {
          ManifestModel? findDropdownValue() {
            ManifestModel? value;
            if (Vv4rs.sampleSherpaOnnx == null){
              for (final voice in Vv4rs.perLangSherpaOnnxVoices[language]!){
                if (voice.id == Vv4rs.sherpaOnnxLanguageVoice[language]?.id){
                  return value = voice;
                } else {
                  value = null;
                }
              } 
            } else {
              if (Vv4rs.perLangSherpaOnnxVoices[language] != null){
              for (final voice in Vv4rs.perLangSherpaOnnxVoices[language]!){
                if (voice.id == Vv4rs.sampleSherpaOnnx!.id){
                  return value = voice;
                } else {
                  value = null;
                }
              } 
              }
            }
            return value;
          }

          var dropdownValue = (Sv4rs.pickFromEngine == "system") 
            ? Vv4rs.systemLanguageVoice[language]?.voice ?? 'default'
            : findDropdownValue();
    

          return SizedBox(width: widget.totalWidth, child:
            ExpansionTile(
              title: Text(language, style: Sv4rs.settingslabelStyle),
              collapsedBackgroundColor: Cv4rs.themeColor4,
              backgroundColor: Cv4rs.themeColor4,
              childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
              children: [
                
                //bookmarked voices
                bookmarkedRow(language, false),
                
                //engine picker
                engineDropdown(),

                //
                //sherpa-onnx
                //
                  //voice
                    if (Sv4rs.pickFromEngine == 'sherpa-onnx')
                      sherpaOnnxVoiceDropdown(false, language, dropdownValue),
                  
                    //rate
                    if (Sv4rs.pickFromEngine == 'sherpa-onnx')
                      sherpaOnnxRateSlider(false, language),
                    

                //
                //system
                //
                  //voice
                  if (Sv4rs.pickFromEngine == 'system')
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(20)), 
                      child: systemVoiceDropdown(false, language, dropdownValue),
                    ),
                
                  //rate
                  if (Sv4rs.pickFromEngine == 'system')
                    systemRateSlider(false, language),
                  
                  //pitch
                  if (Sv4rs.pickFromEngine == 'system')
                    systemPitchSlider(false, language),

                //
                //testVoice button
                //
                testVoiceButton(false, language),
              ]
            ),
        );
        }
        }
        ),

      
      //
      //Speak on Select Voice
      //

      ExpansionTile(
        title: Text('Voice for Speak on Select:', style: Sv4rs.settingslabelStyle),
        backgroundColor: Cv4rs.themeColor4,
        childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(40)),
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(10)),
            child: Row(
              children: [
                Flexible(child: 
                  Text('Use unique voice for Speak on Select', style: Sv4rs.settingslabelStyle),
                ),
                Spacer(),
                Switch(value: Sv4rs.useDifferentVoiceforSS, onChanged: (value) {
                  setState(() {
                    Sv4rs.useDifferentVoiceforSS = value;
                    Sv4rs.saveUseDiffVoiceSS(value);

                    if (Sv4rs.useDifferentVoiceforSS == false){
                      for (final lang in Sv4rs.myLanguages){
                        if (Vv4rs.myEngineForVoiceLang[lang] == 'sherpa-onnx'){
                          Vv4rs.setSSlanguageVoiceSherpaOnnx(
                            lang, 
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.id, 
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.engine, 
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.tokenPath, 
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.modelVoice,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakerCount,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakerID,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.lengthScale, 
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.speakers,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.lexicon,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.farFiles,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.fstFiles,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.voicesBin,
                            Vv4rs.sherpaOnnxLanguageVoice[lang]?.eSpeakPath,
                          );
                        } else {
                          Vv4rs.setSSlanguageVoiceSystem(
                            lang, 
                            Vv4rs.systemLanguageVoice[lang]?.voice, 
                            Vv4rs.systemLanguageVoice[lang]?.engine, 
                            Vv4rs.systemLanguageVoice[lang]?.pitch, 
                            Vv4rs.systemLanguageVoice[lang]?.rate
                          );
                        }
                      }
                    }
                  });
                }),
              ]
             ),
           ),

          if (Sv4rs.useDifferentVoiceforSS) 
          
        ...Sv4rs.myLanguages.map((language){

          if (
            Vv4rs.systemVoices.isEmpty || 
            Vv4rs.uniqueSystemVoices.isEmpty || 
            Vv4rs.perLangSherpaOnnxVoices.isEmpty
          ){
            return CircularProgressIndicator();
          } else {
          
          ManifestModel? findDropdownValue() {
            ManifestModel? value;
            if (Vv4rs.sampleSherpaOnnx == null){
              for (final voice in Vv4rs.perLangSherpaOnnxVoices[language]!){
                if (voice.id == Vv4rs.sherpaOnnxSSLanguageVoice[language]?.id){
                  return value = voice;
                } else {
                  value = null;
                }
              } 
            } else {
              for (final voice in Vv4rs.perLangSherpaOnnxVoices[language]!){
                if (voice.id == Vv4rs.sampleSherpaOnnx!.id){
                  return value = voice;
                } else {
                  value = null;
                }
              } 
            }
            return value;
          }

          var dropdownValue = (Sv4rs.pickFromEngine == "system") 
            ? Vv4rs.speakSelectSystemLanguageVoice[language]?.voice ?? 'default'
            : findDropdownValue();

          return ExpansionTile(
            title: Text(language, style: Sv4rs.settingslabelStyle),
            collapsedBackgroundColor: Cv4rs.themeColor4,
            backgroundColor: Cv4rs.themeColor4,
            childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
            children: [
              //saftey
              if (Vv4rs.systemVoices.isEmpty)
                CircularProgressIndicator()
              else //offer voices
              
              //bookmarked voices
                bookmarkedRow(language, true),
              
              //engine
                engineDropdown(),

              //
              //sherpa-onnx
              //
              if (Sv4rs.pickFromEngine == 'sherpa-onnx')
              sherpaOnnxVoiceDropdown(true, language, dropdownValue),
              

              //
              // system engine
              //
                
                //voice
                if (Sv4rs.pickFromEngine == 'system')
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(20)),
                    child: systemVoiceDropdown(true, language, dropdownValue),
                  ),
               
                //rate
                if (Sv4rs.pickFromEngine == 'system')
                  systemRateSlider(true, language),
                
                //pitch
                if (Sv4rs.pickFromEngine == 'system')
                  systemPitchSlider(true, language),
              
              //
              //testVoice button
              //

              testVoiceButton(true, language),

            ],
          );
          }
        }
        ),
      
        ],
      ),
  
     ]
    );
  }
}

