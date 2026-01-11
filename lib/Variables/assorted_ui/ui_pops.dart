import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/save_indicator.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/settings/bookmark_voice.dart';
import 'package:flutterkeysaac/Variables/settings/speak_on_select.dart';
import 'package:flutterkeysaac/Variables/export_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'dart:typed_data';
import 'dart:io'; //platform

//speak on select shortcut 
Future<void> showOptionsPopupForSpeakOnSelect(
  Future<void> Function(bool) reloadSherpaOnnx, 
  BuildContext context
) async {
  if ( Vv4rs.perLangSherpaOnnxVoices[V4rs.selectedLanguage.value] == null){
    print('findSherpaVoiceName: is null');
    Vv4rs.setupSherpaOnnxVoicePicker(V4rs.selectedLanguage.value);
  }

  Widget bookmarkSSButton() {
    return Padding(
        padding: EdgeInsetsGeometry.all(V4rs.paddingValue(5)), 
        child: ButtonStyle1(
          glow: true,
          padding: !V4rs.xSmallMode ? 5 : 15,
          imagePath: 'assets/interface_icons/interface_icons/iBookmark.png', 
          onPressed: (){
           BSSv4rs.setBoomarkSS();
          }
        ), 
    );
  }

  Widget bookmarkedSSRow(){
    return ValueListenableBuilder(
      valueListenable: BSSv4rs.bookmarkedSSCount, 
      builder: (context, count, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsetsGeometry.all(5), 
              child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: !V4rs.xSmallMode ? 100 : 60, 
                  height: !V4rs.xSmallMode ? 60 : 50, 
                  child: bookmarkSSButton(),
                ),
                for (int i=0; i <(BSSv4rs.bookmarkedSS.length); i ++)...[
                  SizedBox(width: !V4rs.xSmallModeWidth ? 250 : 150, child: 
                  ButtonStyle2(
                    flex: 3,
                    maxLines: 3,
                    imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                    onPressed: (){
                        Sv4rs.saveSpeakInterfaceButtonsOnSelect(BSSv4rs.bookmarkedSS[i].interface);
                        Bv4rs.navRowSpeakOnSelect = BSSv4rs.bookmarkedSS[i].nav;
                        Bv4rs.saveNavRowSpeakOnSelect(BSSv4rs.bookmarkedSS[i].nav);
                        Bv4rs.grammerRowSpeakOnSelect = BSSv4rs.bookmarkedSS[i].grammer; 
                        Bv4rs.savegrammerRowSpeakOnSelect(BSSv4rs.bookmarkedSS[i].grammer);
                        Bv4rs.subFolderSpeakOnSelect = BSSv4rs.bookmarkedSS[i].subFolder; 
                        Bv4rs.saveSubFolderSpeakOnSelect(BSSv4rs.bookmarkedSS[i].subFolder);
                        Bv4rs.buttonSpeakOnSelect = BSSv4rs.bookmarkedSS[i].button; 
                        Bv4rs.saveButtonSpeakOnSelect(BSSv4rs.bookmarkedSS[i].button);
                        Bv4rs.typingKeySpeakOnSelect = BSSv4rs.bookmarkedSS[i].typingKey; 
                        Bv4rs.savetypingKeySpeakOnSelect(BSSv4rs.bookmarkedSS[i].typingKey);
                        Bv4rs.pocketFolderSpeakOnSelect = BSSv4rs.bookmarkedSS[i].pocketFolder; 
                        Bv4rs.savepocketFolderSpeakOnSelect(BSSv4rs.bookmarkedSS[i].pocketFolder);
                        Bv4rs.folderSpeakOnSelect = BSSv4rs.bookmarkedSS[i].folder; 
                        Bv4rs.savefolderSpeakOnSelect(BSSv4rs.bookmarkedSS[i].folder);
                        Bv4rs.audioTileSpeakOnSelect = BSSv4rs.bookmarkedSS[i].audioTile; 
                        Bv4rs.saveaudioTileSpeakOnSelect(BSSv4rs.bookmarkedSS[i].audioTile);
                    },
                    label: '$i - (${BSSv4rs.bookmarkedSS[i].interface}, ${
                      BSSv4rs.bookmarkedSS[i].nav}, ${
                      BSSv4rs.bookmarkedSS[i].grammer}, ${
                      BSSv4rs.bookmarkedSS[i].subFolder}, ${
                      BSSv4rs.bookmarkedSS[i].button}, ${
                      BSSv4rs.bookmarkedSS[i].typingKey}, ${
                      BSSv4rs.bookmarkedSS[i].pocketFolder}, ${
                      BSSv4rs.bookmarkedSS[i].folder}, ${
                      BSSv4rs.bookmarkedSS[i].audioTile})' 
                  ),
                ),
                ], 
                SizedBox(width: !V4rs.xSmallModeWidth ? 1000 : 500)
              ],
            ),
          ),
        );
      }
    );
  }
 
  Widget bookmarkVoiceButton(String lang, bool forSS) {
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

  Widget bookmarkedVoicesRow(String language, bool forSS, dynamic reloadSherpaOnnx){
    return ValueListenableBuilder(
      valueListenable: BVv4rs.bookmarkedCount, 
      builder: (context, count, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: Padding(padding: EdgeInsetsGeometry.all(5), child: 
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: !V4rs.xSmallMode ? 100 : 60, 
                  height: !V4rs.xSmallMode ? 60 : 50, 
                  child: bookmarkVoiceButton(language, forSS),
                ),
                for (int i=0; i <(BVv4rs.bookmarkedVoices[language]?.length ?? 0); i ++)...[
                  SizedBox(width: !V4rs.xSmallModeWidth ? 250 : 150, child: 
                  ButtonStyle2(
                    flex: 3,
                    maxLines: 3,
                    imagePath: 'assets/interface_icons/interface_icons/iVoice.png', 
                    onPressed: (){
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
                            reloadSherpaOnnx(forSS);
                          }
                        }
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
                SizedBox(width: !V4rs.xSmallModeWidth ? 1000 : 500)
              ],
            ),
          ),
        );
      }
    );
  }

  double rateValue = 0.5;
  Widget systemRateSlider(bool forSS, String language, void Function(void Function()) setState){
   return Padding(
      padding: EdgeInsets.fromLTRB(V4rs.paddingValue(15), 0, 0, V4rs.paddingValue(15)),
      child: Row(
        children: [

          Text(
            (forSS)
              ? 'Rate: ${Vv4rs.getSystemSSValue(language, 'rate')}'
              : 'Rate: ${Vv4rs.getSystemValue(language, 'rate')}',
            style: Sv4rs.settingslabelStyle,
          ),

          Expanded(
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
                rateValue = double.parse(value.toStringAsFixed(2));
                setState((){
                 (forSS)
                  ? Vv4rs.setSSlanguageVoiceSystem(
                      language, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.voice, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.engine, 
                      Vv4rs.speakSelectSystemLanguageVoice[language]?.pitch, 
                      rateValue, 
                    )
                  : Vv4rs.setlanguageVoiceSystem(
                      language, 
                      Vv4rs.systemLanguageVoice[language]?.voice, 
                      Vv4rs.systemLanguageVoice[language]?.engine, 
                      Vv4rs.systemLanguageVoice[language]?.pitch, 
                      rateValue, 
                    );
                });
                
            },
          
          ),
          ),
        ],
      ),
    );
  }

  Widget systemPitchSlider(bool forSS, String language, void Function(void Function()) setState){
   return Padding(
      padding: EdgeInsets.fromLTRB(V4rs.paddingValue(15), 0, 0, V4rs.paddingValue(15)),
      child: Row(
        children: [
          Text(
            (forSS)
              ? 'Pitch: ${Vv4rs.getSystemSSValue(language, 'pitch')}'
              : 'Pitch: ${Vv4rs.getSystemValue(language, 'pitch')}',
            style: Sv4rs.settingslabelStyle,
          ),

          Expanded(child:
            Slider(
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
                double pitchValue = double.parse(value.toStringAsFixed(1));
                setState((){
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
        ],
      ),
    );
  }

  Widget sherpaOnnxRateSlider(bool forSS, String language, void Function(void Function()) setState){
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

          Expanded(
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
                rateValue = double.parse(value.toStringAsFixed(2));
                setState((){
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
        ],
      ),
    );
  }


  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(child: 
          Container(
            height: V4rs.xSmallModeHeight ? 1500 : 500,
            decoration: BoxDecoration(
              color: Cv4rs.themeColor4,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(child: 
            Padding(
            padding: EdgeInsets.all(V4rs.paddingValue(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Done button
                Align(
                  alignment: Alignment.centerRight,
                  child: 
                SizedBox(
                  width: !V4rs.xSmallMode ? 90 : 50, 
                  height: !V4rs.xSmallMode ? 40 : 30, 
                  child:
                ButtonStyle1(
                  padding: !V4rs.xSmallMode ? 5 : 15,
                  imagePath: 'assets/interface_icons/interface_icons/iClose.png',
                  onPressed: () {
                    Navigator.pop(context);
                  }
                ),
                ),
                ),
                  Text(
                    "Voice Shortcut:",
                    style: Sv4rs.settingslabelStyle,
                  ),
                bookmarkedVoicesRow(V4rs.selectedLanguage.value, false, reloadSherpaOnnx),
                if (Vv4rs.myEngineForVoiceLang[V4rs.selectedLanguage.value] == 'sherpa-onnx')
                  sherpaOnnxRateSlider(false, V4rs.selectedLanguage.value, setState),

                if (Vv4rs.myEngineForVoiceLang[V4rs.selectedLanguage.value] == 'system')
                  systemRateSlider(false, V4rs.selectedLanguage.value, setState),
                if (Vv4rs.myEngineForVoiceLang[V4rs.selectedLanguage.value] == 'system')
                  systemPitchSlider(false, V4rs.selectedLanguage.value, setState),
                
                SizedBox(height: 25,),
                
                  Text(
                    "Speak On Select Shortcut:",
                    style: Sv4rs.settingslabelStyle,
                  ),
                bookmarkedSSRow(),

              ],
            ),
          ),
        ),
          ),
      );
      },
      );
    },
  );
}

//print pop up
Future<void> showPrintPop(
  BuildContext context,
  Future<List<Uint8List?>> Function() captureAllForPrint,
) async { 
  await showDialog(
  context: context,
  builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SimpleDialog(
    title: Text("Print Options"),
    children: [
      Row(
        children: [
          Text('Include Message Row:'),
          Spacer(),
          DropdownButton<int>(
            value: ExV4rs.includeMessageRow,
            items: [
              DropdownMenuItem(value: 1, child: Text("Message Row")),
              DropdownMenuItem(value: 2, child: Text("Spacer")),
              DropdownMenuItem(value: 3, child: Text("None")),
            ],
            onChanged: (value) {
              setState(() {
                if (value!= null){
                  ExV4rs.includeMessageRow = value;
                }
              });
            },
          ),
        ]
      ),
      Row(
        children: [
          Text('Include Navigation Row:'),
          Spacer(),
          DropdownButton<int>(
            value: ExV4rs.includeNavRow,
            items: [
              DropdownMenuItem(value: 1, child: Text("Navigation Row")),
              DropdownMenuItem(value: 2, child: Text("Spacer")),
              DropdownMenuItem(value: 3, child: Text("None")),
            ],
            onChanged: (value) {
              setState(() {
                if (value!= null){
                  ExV4rs.includeNavRow = value;
                }
              });
            },
          ),
        ]
      ),
      Row(
        children: [
          Text('Include Grammar Row:'),
          Spacer(),
          DropdownButton<int>(
            value: ExV4rs.includeGrammerRow,
            items: [
              DropdownMenuItem(value: 1, child: Text("Grammar Row")),
              DropdownMenuItem(value: 2, child: Text("Spacer")),
              DropdownMenuItem(value: 3, child: Text("None")),
            ],
            onChanged: (value) {
              setState(() {
                if (value!= null){
                  ExV4rs.includeGrammerRow = value;
                }
              });
            },
          ),
        ]
      ),
      Row(
        children: [
          Text('Include Indicator Row:'),
          Spacer(),
          Switch(
            value: ExV4rs.includeIndicatorRow, 
            onChanged: (value) {
              setState(() {
                ExV4rs.includeIndicatorRow = value;
              });
            }
          ),
        ]
      ),
      if (ExV4rs.includeIndicatorRow)
       Padding(
        padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
        child: Row(
          children: [
            Text('1st Indicator Message:'),
            Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(V4rs.paddingValue(15), 0, V4rs.paddingValue(20), 0), 
              child: TextField(
                onChanged: (value) {
                  ExV4rs.indicator1 = value;
                  ExV4rs.saveIndicator1(value);
                },
                decoration: InputDecoration(
                  hintText: ExV4rs.indicator1,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
      if (ExV4rs.includeIndicatorRow)
      Padding(
        padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
        child: Row(
          children: [
            Text('2nd Indicator Message:'),
            Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(V4rs.paddingValue(15), 0, V4rs.paddingValue(20), 0), 
              child: TextField(
                onChanged: (value) {
                  ExV4rs.indicator2 = value;
                  ExV4rs.saveIndicator2(value);
                },
                decoration: InputDecoration(
                  hintText: ExV4rs.indicator2,
                ),
              ),
            ),
            ),
          ],
        ),
      ),
      if (ExV4rs.includeIndicatorRow)
      Padding(
        padding: EdgeInsets.fromLTRB(V4rs.paddingValue(20), 0, 0, V4rs.paddingValue(15)),
        child: Row(
          children: [
            Text('3rd Indicator Message:'),
            Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(V4rs.paddingValue(15), 0, V4rs.paddingValue(20), 0), 
              child: TextField(
                onChanged: (value) {
                  ExV4rs.indicator3 = value;
                  ExV4rs.saveIndicator3(value);
                },
                decoration: InputDecoration(
                  hintText: ExV4rs.indicator3,
                ),
              ),
              ),
            ),
          ],
        ),
      ),
      // Done button
      Row(children: [
      Expanded(child: 
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Cv4rs.themeColor3,
            elevation: 2, 
            shape: RoundedRectangleBorder( 
              borderRadius: BorderRadius.circular(10), 
            ),
            shadowColor: Cv4rs.themeColor4,
            padding: EdgeInsets.symmetric(
              horizontal: V4rs.paddingValue(5), 
              vertical: V4rs.paddingValue(5)), 
          ),
        onPressed: () async { if (ExV4rs.loadingPrint.value){} else {
            final pages =
                await captureAllForPrint();

            if (pages.isEmpty) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Failed to generate print image")),
              );
              return;
            }

            // Show print dialog
            await Printing.layoutPdf(
              onLayout: (PdfPageFormat format) async {
                final doc = pw.Document();

                for (final pageBytes in pages){
                  if (pageBytes != null) {
                final image = pw.MemoryImage(pageBytes);

                doc.addPage(
                  pw.Page(
                    pageFormat: format,
                    build: (pw.Context ctx) {
                      return pw.Center(
                        child: pw.FittedBox(
                          fit: pw.BoxFit.contain,
                          child: pw.Image(image),
                        ),
                      );
                    },
                  ),
                );
                }
                }
                return doc.save();
              },
            );
            if (!context.mounted) return;
            Navigator.of(context).pop();
          }
          },
        child: Row(children: [
          Text("Done", style: Sv4rs.settingslabelStyle,),
          LoadingIndicator(notifier: ExV4rs.loadingPrint),
        ]),
      ),
      ),
      ]),
    ],
  );
        });}
);
}

