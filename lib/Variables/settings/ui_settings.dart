import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';

class TopRowForSettings extends StatefulWidget {
  final TTSInterface synth;
  final Root root;

  const TopRowForSettings({
    super.key, 
    required this.synth,
    required this.root,
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
                  padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
                  child: SizedBox(
                    height: 50,
                    width: 75,
                    child: ButtonStyle1(
                      imagePath: 'assets/interface_icons/interface_icons/iBack.png',
                      onPressed: () {
                          if (Sv4rs.speakInterfaceButtonsOnSelect) {
                          V4rs.speakOnSelect('back', V4rs.selectedLanguage.value, widget.synth);
                          }
                        V4rs.showSettings.value = false;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
                  child: SizedBox(
                    height: 50,
                    width: 60,
                    child: ButtonStyle1(
                      imagePath: 'assets/interface_icons/interface_icons/iEdit.png',
                      onPressed: () {
                          if (Sv4rs.speakInterfaceButtonsOnSelect) {
                          V4rs.speakOnSelect('edit', V4rs.selectedLanguage.value, widget.synth);
                          }
                          Ev4rs.updateJsonHistory(widget.root);
                          
                        V4rs.showSettings.value = false;
                        Ev4rs.showEditor.value = true;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 20),
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

  const OpenWelcomeScreen({
    super.key, 
    required this.synth,
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
                          V4rs.speakOnSelect('open welcome screen', V4rs.selectedLanguage.value, widget.synth);
                        }
                setState(() {
                  V4rs.doOnboarding.value = true;
                  V4rs.setOnboardingCompleteStatus(true);
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

  const VoicePicker({
    super.key, 
    required this.synth,
    required this.totalWidth
    });

  @override
  State<VoicePicker> createState() => _VoicePicker();
}

class _VoicePicker extends State<VoicePicker> with WidgetsBindingObserver {
  double pitchValue = 1.0;
  double rateValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Voice:', 
        style: Sv4rs.settingslabelStyle
       ),
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
      onExpansionChanged: (bool expanded) {  
        if (Sv4rs.speakInterfaceButtonsOnSelect) {
            V4rs.speakOnSelect('voice', V4rs.selectedLanguage.value, widget.synth);
          }},
      children: [
        
        //
        //Note for users
        //
        Row(children: [ 
          Expanded(
            child: Padding( 
              padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
              child: Text(
                'Multilingual users should not rely on default voices- please manually select a voice for each language.', 
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
          final dropdownValue = 'Default';
          Vv4rs.setupSystemVoicePicker(language, dropdownValue);

          return ExpansionTile(
            title: Text(language, style: Sv4rs.settingslabelStyle),
            collapsedBackgroundColor: Cv4rs.themeColor4,
            backgroundColor: Cv4rs.themeColor4,
            childrenPadding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              //saftey
              if (Vv4rs.systemVoices.isEmpty)
                CircularProgressIndicator()
              else

              //Voice List
              ListTile(
                title: Text('Voice', style: Sv4rs.settingslabelStyle),
                trailing: DropdownButton<String>(
                value: dropdownValue,
                onChanged: (value) async {
                  //set the selected voice to the language
                  setState(() {
                    if (value != null) {
                      Sv4rs.languageVoice[language] = value;
                      Sv4rs.setlanguageVoice(language, value);
                    }
                   }
                  );
                  //save selection
                  final prefs = await SharedPreferences.getInstance();
                  if (value != null) {
                    await prefs.setString('tts_voice_$language', value);
                  }
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'default',
                    child: Text('default', style: Sv4rs.settingslabelStyle),
                  ),

                  ...Vv4rs.uniqueSystemVoices.map((voice) {
                    final identifier = voice['identifier']!.toString(); // <-- cast to String
                    return DropdownMenuItem<String>(
                      value: identifier,
                      child: Text(Vv4rs.cleanVoiceLabel(voice), style: Sv4rs.settingslabelStyle),
                    );
                  }),
                ],
               ),
              ),

              //
              //rate
              //
               
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                child: Row(
                  children: [
                    Text('Rate: ${Sv4rs.getLangRate(language)}', style: Sv4rs.settingslabelStyle,),
                    Expanded(child: SizedBox(width: widget.totalWidth * 1,
                    child: Slider(
                      value: Sv4rs.getLangRate(language),
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      activeColor: Cv4rs.themeColor1,
                      inactiveColor: Cv4rs.themeColor3,
                      thumbColor: Cv4rs.themeColor1,
                      label: 'Voice Rate: ${Sv4rs.getLangRate(language)}',
                      onChanged: (value) async {
                        setState(() {
                          rateValue = double.parse(value.toStringAsFixed(10));
                          Sv4rs.languageRates[language] = rateValue;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setDouble('tts_rate_$language', value);
                      },
                    ),
                    ),
                    ),
                  ],
                ),
              ),

              //
              //pitch 
              //

              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                child: Row(
                  children: [
                    Text('Pitch: ${Sv4rs.getLangPitch(language)}', style: Sv4rs.settingslabelStyle,),
                    Expanded(
                    child: Slider(
                      value: Sv4rs.getLangPitch(language),
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      activeColor: Cv4rs.themeColor1,
                      inactiveColor: Cv4rs.themeColor3,
                      thumbColor: Cv4rs.themeColor1,
                      label: 'Voice Pitch: ${Sv4rs.getLangPitch(language)}',
                      onChanged: (value) async {
                        setState(() {
                          pitchValue = double.parse(value.toStringAsFixed(1));
                          Sv4rs.languagePitch[language] = pitchValue;
                        });
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setDouble('tts_pitch_$language', value);
                      },
                    ),
                    ),
                  ],
                ),
              ),

              //
              //testVoice button
              //

              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Test Voice', style: Sv4rs.settingslabelStyle,),
                    SizedBox(height: 40, width: widget.totalWidth * 0.1, child:
                    ButtonStyle1(
                      imagePath: 'assets/interface_icons/interface_icons/iPlay.png',
                      onPressed: () async {
                        final voiceID = Sv4rs.getLangVoice(language);
                        await widget.synth.setVoice({
                          'identifier': voiceID ?? 'default',
                        });
                        await widget.synth.setRate(Sv4rs.getLangRate(language));
                        await widget.synth.setPitch(Sv4rs.getLangPitch(language));
                        await widget.synth.speak(Sv4rs.testPhrases[language] ?? 'This is a test phrase.');
                      },
                    ),
                    ),
                  ],
                )
              ),
            ],
          );
          }
        ),
      
      //
      //Speak on Select Voice
      //

      ExpansionTile(
        title: Text('Voice for Speak on Select:', style: Sv4rs.settingslabelStyle),
        backgroundColor: Cv4rs.themeColor4,
        childrenPadding: EdgeInsets.symmetric(horizontal: 40),
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Text('Use unique voice for Speak on Select', style: Sv4rs.settingslabelStyle),
                Spacer(),
                Switch(value: Sv4rs.useDifferentVoiceforSS, onChanged: (value) {
                  setState(() {
                    Sv4rs.useDifferentVoiceforSS = value;
                    Sv4rs.saveUseDiffVoiceSS(value);
                  });
                }),
              ]
             ),
           ),

          if (Sv4rs.useDifferentVoiceforSS) 
            ...Sv4rs.myLanguages.map((language){

              final dropdownValue = 'Default';
              Vv4rs.setupSystemVoicePicker(language, dropdownValue);

              return ExpansionTile(
                title: Text(language, style: Sv4rs.settingslabelStyle),
                collapsedBackgroundColor: Cv4rs.themeColor4,
                backgroundColor: Cv4rs.themeColor4,
                childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ListTile(
                    title: Text('Voice', style: Sv4rs.settingslabelStyle),
                    trailing: DropdownButton<String>(
                      value: dropdownValue,
                      onChanged: (value) async {
                        setState(() {
                          if (value != null) {
                            Sv4rs.speakSelectLanguageVoice[language] = value;
                            Sv4rs.setSSlanguageVoice(language, value);
                            }
                          });
                        final prefs = await SharedPreferences.getInstance();
                        if (value != null) {
                        await prefs.setString('tts_forSS_voice_$language', value);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'Default', 
                          child: Text('Default', style: Sv4rs.settingslabelStyle,
                           )
                         ),

                        ...Vv4rs.uniqueSystemVoices
                          .where((voice) => voice['identifier'] != null)
                          .map((voice) {
                            final identifier = voice['identifier'];
                            if (identifier == null) {
                              return DropdownMenuItem(value: 'Default', child: Text('Default', style: Sv4rs.settingslabelStyle,),);
                            }
                            return DropdownMenuItem(
                              value: identifier,
                              child: Text(Vv4rs.cleanVoiceLabel(voice), style: Sv4rs.settingslabelStyle,),
                             );
                          })
                       ],
                    ),
                  ),

                  //
                  //Speak on Select Rate 
                  //

                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                    child: Row(
                      children: [
                        Text('Rate: ${Sv4rs.getSSLangRate(language)}', style: Sv4rs.settingslabelStyle,),
                        Expanded(child: SizedBox(width: widget.totalWidth * 1,
                        child: Slider(
                          value: Sv4rs.getSSLangRate(language),
                          min: 0.0,
                          max: 1.0,
                          divisions: 10,
                          activeColor: Cv4rs.themeColor1,
                          inactiveColor: Cv4rs.themeColor3,
                          thumbColor: Cv4rs.themeColor1,
                          label: 'Voice Rate: ${Sv4rs.getSSLangRate(language)}',
                          onChanged: (value) async {
                            setState(() {
                              rateValue = double.parse(value.toStringAsFixed(1));
                              Sv4rs.sslanguageRates[language] = rateValue;
                            });
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setDouble('tts_forSS_rate_$language', value);
                          },
                        ),
                        ),
                        ),
                      ],
                    ),
                  ),

                  //
                  //Speak on Select Pitch 
                  //

                    Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                    child: Row(
                      children: [
                        Text('Pitch: ${Sv4rs.getssLangPitch(language)}', style: Sv4rs.settingslabelStyle,),
                        Expanded(
                        child: Slider(
                          value: Sv4rs.getssLangPitch(language),
                          min: 0.5,
                          max: 2.0,
                          divisions: 15,
                          activeColor: Cv4rs.themeColor1,
                          inactiveColor: Cv4rs.themeColor3,
                          thumbColor: Cv4rs.themeColor1,
                          label: 'Voice Pitch: ${Sv4rs.getssLangPitch(language)}',
                          onChanged: (value) async {
                            setState(() {
                              pitchValue = double.parse(value.toStringAsFixed(1));
                              Sv4rs.sslanguagePitch[language] = pitchValue;
                            });
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setDouble('tts_forSS_pitch_$language', value);
                          },
                        ),
                        ),
                      ],
                    ),
                  ),
                  
                  //
                  //testVoice button
                  //
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Test Voice', style: Sv4rs.settingslabelStyle,),
                        SizedBox(height: 40, width: widget.totalWidth * 0.1, child:
                        ButtonStyle1(
                          imagePath: 'assets/interface_icons/interface_icons/iPlay.png',
                          onPressed: () async {
                            final voiceID = Sv4rs.getSSLangVoice(language);
                            await widget.synth.setVoice({
                              'identifier': voiceID ?? 'default',
                            });
                            await widget.synth.setRate(Sv4rs.getSSLangRate(language));
                            await widget.synth.setPitch(Sv4rs.getssLangPitch(language));
                            await widget.synth.speak(Sv4rs.testPhrases[language] ?? 'This is a test phrase.');

                          },
                        ),
                        ),
                      ],
                    )
                  ),
                ],
                );
            })
        
        ],
      ),
     ]
    );
  }
}

