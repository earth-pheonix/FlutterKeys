import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/settings/ui_settings.dart';
import 'package:flutterkeysaac/Variables/settings/voice_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/export_variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterkeysaac/Variables/editing/save_indicator.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_pops.dart';
import 'package:flutterkeysaac/Variables/fonts/font_pickers.dart';
import 'package:flutterkeysaac/Variables/colors/color_pickers.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:share_plus/share_plus.dart'; 
import 'dart:io';


class Settings extends StatefulWidget {
  final TTSInterface synth;
  final Future<List<Uint8List?>> Function() captureAllForPrint;

  const Settings({
    super.key, 
    required this.synth,
    required this.captureAllForPrint,
    });

  @override
  State<Settings> createState() => _Settings();
  
}

class _Settings extends State<Settings> with WidgetsBindingObserver {
  late Future<Root> rootFuture;
  Root? _root;

  int alertCountValue = 3;

  String? selectedVoice;

  @override
  void initState() {
    super.initState();
    Vv4rs.loadVoices(widget.synth);
    rootFuture = V4rs.loadRootData();
  }

 
 @override
  Widget build(BuildContext context) {
    return FutureBuilder<Root>(
      future: rootFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        }

        _root = snapshot.data!;

        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset position = box.localToGlobal(Offset.zero);
        final Size size = box.size;

    return LayoutBuilder(
       builder: (context, constraints) {
              var totalWidth = constraints.maxWidth;
    return Scaffold(
      backgroundColor: Cv4rs.themeColor3,
      body: SafeArea(
        bottom: false, // Ignore keyboard
        child: Padding (
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
          child: Column(
          children: [
            if (_root != null)
            TopRowForSettings(synth: widget.synth, root: _root!),
            
          //
          //SETTINGS 
          //  

          Expanded(
            child: ListView(
              children: [

                //
                //language selection
                //
                 
                ExpansionTile(
                  title: Text('Language:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                  onExpansionChanged: (bool expanded) {  
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        V4rs.speakOnSelect('language', V4rs.selectedLanguage.value, widget.synth);
                      }},
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0), 
                      child: Row(
                        children: [
                          Text('Interface language', style: Sv4rs.settingslabelStyle),
                          Spacer(),
                          DropdownButton<String>(
                            value: V4rs.interfaceLanguage, 
                            dropdownColor: Cv4rs.themeColor4,
                            hint: const Text('interface language'),
                            items: V4rs.allInterfaceLanguages.map((language) {
                              return DropdownMenuItem<String>(
                                value: language,
                                child: Text(language, style: Sv4rs.settingslabelStyle),
                                );
                              }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  V4rs.interfaceLanguage = value;
                                  V4rs.saveInterfaceLang(value);
                                  });
                                }
                              },
                            ),
                          ]
                        ),
                    ),
                  ...Sv4rs.allLanguages.map((language) {
                    final isSelected = Sv4rs.myLanguages.contains(language);
                    return Column(
                      children: [
                        Divider(
                          indent: 20,
                          endIndent: 20,
                        ),
                        CheckboxListTile (
                          title: Text(language, style: Sv4rs.settingslabelStyle),
                          value: isSelected,
                          onChanged: (selected){
                            setState(() {
                              if (selected == true) {
                                  Sv4rs.myLanguages.add(language);
                                  Vv4rs.loadVoices(widget.synth);
                                  Sv4rs.setMyLanguages(Sv4rs.myLanguages);
                              } else {
                                if (Sv4rs.myLanguages.length > 1) {
                                Sv4rs.myLanguages.remove(language);
                                Vv4rs.loadVoices(widget.synth);
                                Sv4rs.setMyLanguages(Sv4rs.myLanguages);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('At least one language must be selected'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            });
                          },
                        ),
                      ]
                    );
                  })
                  ]
                ),
                
                //
                //voice settings
                //

                VoicePicker(synth: widget.synth, totalWidth: totalWidth), //I live in the ui_settings file

                //
                //interfece settings
                //

                ExpansionTile(
                  title: Text('Interface Settings:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                  onExpansionChanged: (bool expanded) {  
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        V4rs.speakOnSelect('Interface Settings', V4rs.selectedLanguage.value, widget.synth);
                      }},
                  children: [
                    
                    ExpansionTile(
                      title: Text('Theme Colors:', style: Sv4rs.settingslabelStyle),
                      collapsedBackgroundColor: Cv4rs.themeColor4,
                      backgroundColor: Cv4rs.themeColor4,
                      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        //theme color 1
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Theme Color 1:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.themeColor1, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.themeColor1.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.themeColor1 = color;
                                      Cv4rs.savethemecolorone(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.themeColor1, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.themeColor1 = color;
                                      Cv4rs.savethemecolorone(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //theme color 2
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Theme Color 2:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.themeColor2, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.themeColor2.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.themeColor2 = color;
                                      Cv4rs.savethemecolortwo(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.themeColor2, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.themeColor2 = color;
                                      Cv4rs.savethemecolortwo(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //theme color 3
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Theme Color 3:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.themeColor3, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 6,
                                  ),
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 6,
                                  ),
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 6,
                                  ),
                                ],
                                ),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.themeColor3.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.themeColor3 = color;
                                      Cv4rs.savethemecolorthree(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.themeColor3, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.themeColor3 = color;
                                      Cv4rs.savethemecolorthree(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //theme color 4
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Theme Color 4:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.themeColor4, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.themeColor4.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.themeColor4 = color;
                                      Cv4rs.savethemecolorfour(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.themeColor4, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.themeColor4 = color;
                                      Cv4rs.savethemecolorfour(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //interface icon color
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Interface Icon Color:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.uiIconColor, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.uiIconColor.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.uiIconColor = color;
                                      Cv4rs.saveUIIconColor(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.uiIconColor, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.uiIconColor = color;
                                      Cv4rs.saveUIIconColor(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        ]),                                 
                    //Interface font settings
                FontPicker1(
                  useUnderline: false,
                  onUnderlineChanged: (value) async {},
                  size: Fv4rs.interfaceFontSize, 
                  weight: Fv4rs.interfaceFontWeight, 
                  italics: Fv4rs.interfaceFontItalics, 
                  font: Fv4rs.interfaceFont, 
                  label: 'Interface Font Settings:', 
                  color: Fv4rs.interfaceFontColor,
                  onColorChanged: (value) async {
                                setState(() {
                                   Fv4rs.interfaceFontColor = value.toColor() ?? Fv4rs.interfaceFontColor;
                                   Fv4rs.saveInterfaceFontColor(value.toColor() ?? Fv4rs.interfaceFontColor);
                                });
                              }, 
                  onSizeChanged: (value) async {
                                setState(() {
                                   Fv4rs.interfaceFontSize = value;
                                   Fv4rs.saveInterfaceFontSize(value);
                                });
                              }, 
                  onWeightChanged: (value) async {
                                setState(() {
                                   Fv4rs.interfaceFontWeight = value;
                                   Fv4rs.saveInterfaceFontWeight(value);
                                });
                              },
                  onItalicsChanged: (value) async {
                                setState(() {
                                   Fv4rs.interfaceFontItalics= value;
                                   Fv4rs.saveInterfaceFontItalics(value);
                                });
                              },
                  onFontChanged: (value) async {
                                setState(() {
                                   Fv4rs.interfaceFont = value;
                                   Fv4rs.saveInterfaceFont(value);
                                });
                              },
                  tts: widget.synth,
                ),
                //font picker
              FontFamilyPicker(
                font: Fv4rs.fallbackFont1, 
                onFontChanged: (value) async {
                    setState(() {
                        Fv4rs.fallbackFont1 = value;
                        Fv4rs.savefallbackFont1(value);
                    });
                  },
                tts: widget.synth, 
                label: 'First Fallback Font: ${Fontsy.familyToFont[Fv4rs.fallbackFont2]}'
               ),
               FontFamilyPicker(
                font: Fv4rs.fallbackFont1, 
                onFontChanged: (value) async {
                    setState(() {
                        Fv4rs.fallbackFont1 = value;
                        Fv4rs.savefallbackFont1(value);
                    });
                  },
                tts: widget.synth, 
                label: 'Second Fallback Font: ${Fontsy.familyToFont[Fv4rs.fallbackFont2]}'
               ),

                //speak on select: interface icons
                Row(children: [
                Expanded(
                    child: Container(
                      color: Cv4rs.themeColor4,
                      child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15), child:
                      Row(
                        children: [
                          Text('Speak on select: Interface Buttons', style: Sv4rs.settingslabelStyle),
                          Spacer(),
                          Switch(
                            value: Sv4rs.speakInterfaceButtonsOnSelect, 
                            onChanged: (value) {
                              setState(() {
                                Sv4rs.speakInterfaceButtonsOnSelect = value;
                                Sv4rs.saveSpeakInterfaceButtonsOnSelect(value);
                              });
                              if (Sv4rs.speakInterfaceButtonsOnSelect) {
                                      V4rs.speakOnSelect('Interface speak on select $value', V4rs.selectedLanguage.value, widget.synth);
                                    }
                           })
                        ]
                      ),
                      ),
                    ),
                  ),
                ]),

                    ]),

                //   
                //alerts settings
                //

                ExpansionTile(
                  title: Text('Alerts:', style: Sv4rs.settingslabelStyle),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                  onExpansionChanged: (bool expanded) {  
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        V4rs.speakOnSelect('alerts', V4rs.selectedLanguage.value, widget.synth);
                      }},
                  children: [
                    //alert count 
                    Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                        child: Row(
                          children: [
                            Text('Alert Count: ${Sv4rs.alertCount}', style: Sv4rs.settingslabelStyle,),
                            Expanded(
                            child: Slider(
                              value: Sv4rs.alertCount.toDouble(),
                              min: 0.0,
                              max: 3.0,
                              divisions: 3,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Alert count: ${Sv4rs.alertCount}',
                              onChanged: (value) async {
                                setState(() {
                                  alertCountValue = value.round();
                                  Sv4rs.alertCount = alertCountValue;
                                  Sv4rs.saveAlertCount(Sv4rs.alertCount);
                                });
                              },
                            ),
                            ),
                          ],
                        ),
                      ),
                      //first alert message
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                        child: Row(
                          children: [
                            Text('1st Alert Message:', style: Sv4rs.settingslabelStyle,),
                            Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 20, 0), 
                              child: TextField(
                                onChanged: (value) {
                                  Sv4rs.firstAlert = value;
                                  Sv4rs.saveFirstAlert(value);
                                },
                                decoration: InputDecoration(
                                  hintText: Sv4rs.firstAlert,
                                  hintStyle: TextStyle(color: Cv4rs.themeColor3),
                                ),
                              ),
                            ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                        child: Row(
                          children: [
                            Text('2nd Alert Message:', style: Sv4rs.settingslabelStyle,),
                            Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 20, 0), 
                              child: TextField(
                                onChanged: (value) {
                                  Sv4rs.secondAlert = value;
                                  Sv4rs.saveSecondAlert(value);
                                },
                                decoration: InputDecoration(
                                  hintText: Sv4rs.secondAlert,
                                  hintStyle: TextStyle(color: Cv4rs.themeColor3),
                                ),
                              ),
                            ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 15),
                        child: Row(
                          children: [
                            Text('3rd Alert Message:', style: Sv4rs.settingslabelStyle,),
                            Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
                              child: TextField(
                                onChanged: (value) {
                                  Sv4rs.thirdAlert = value;
                                  Sv4rs.saveThirdAlert(value);
                                },
                                decoration: InputDecoration(
                                  hintText: Sv4rs.thirdAlert,
                                  hintStyle: TextStyle(color: Cv4rs.themeColor3),
                                ),
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),


                  ],
                ),
                
                //
                //expand page settings
                //

                ExpansionTile(
                  title: Text('Expand Page:', style: Sv4rs.settingslabelStyle,),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                  onExpansionChanged: (bool expanded) {  
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        V4rs.speakOnSelect('Expand page settings', V4rs.selectedLanguage.value, widget.synth);
                      }},
                  children: [
                    ExpansionTile(
                      title: Text('Page Colors:', style: Sv4rs.settingslabelStyle),
                      collapsedBackgroundColor: Cv4rs.themeColor4,
                      backgroundColor: Cv4rs.themeColor4,
                      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        //theme color 1
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Color 1:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.expandColor1, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.expandColor1.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.expandColor1 = color;
                                      Cv4rs.saveexpandcolorone(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.expandColor1, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs. expandColor1 = color;
                                      Cv4rs.saveexpandcolorone(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //theme color 2
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Color 2:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.expandColor2, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.expandColor2.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.expandColor2 = color;
                                      Cv4rs.saveexpandcolortwo(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.expandColor2, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.expandColor2 = color;
                                      Cv4rs.saveexpandcolortwo(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //theme color 3
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Color 3:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.expandColor3, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 6,
                                  ),
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 6,
                                  ),
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 6,
                                  ),
                                ],
                                ),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.expandColor3.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.expandColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.expandColor3 = color;
                                      Cv4rs.saveexpandcolorthree(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.expandColor3, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.expandColor3 = color;
                                      Cv4rs.saveexpandcolorthree(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //theme color 4
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Color 4:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.expandColor4, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.themeColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.expandColor4.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.expandColor4 = color;
                                      Cv4rs.saveexpandcolorfour(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.expandColor4, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.expandColor4 = color;
                                      Cv4rs.saveexpandcolorfour(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        //interface icon color
                        ExpansionTile(
                          title: Row(
                            children: [
                              Text('Icon Color:', style: Sv4rs.settingslabelStyle,),
                              const Spacer(),
                              CircleAvatar(
                                backgroundColor: Cv4rs.themeColor3,
                                radius: 20,
                                child: Icon(Icons.circle, color: Cv4rs.expandIconColor, size: 40, shadows: [
                                  Shadow(
                                    color: Cv4rs.expandColor4,
                                    blurRadius: 4,
                                  ),
                                ],),
                              ),
                            ]
                          ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Cv4rs.expandIconColor.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Cv4rs.expandIconColor = color;
                                      Cv4rs.saveexpandiconcolor(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Cv4rs.expandIconColor, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Cv4rs.expandIconColor = color;
                                      Cv4rs.saveexpandiconcolor(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                        ]),
                    FontPicker1(
                      useUnderline: false,
                      onUnderlineChanged: (value) async {},
                      size: Fv4rs.expandedFontSize, 
                      weight: Fv4rs.expandedFontWeight, 
                      italics: Fv4rs.expandedFontItalics, 
                      font: Fv4rs.expandedFont, 
                      label: 'Font Settings:', 
                      color: Fv4rs.expandedFontColor,
                      sizeMin: 10,
                      sizeMax: 300, 
                      onSizeChanged: (value) async {
                                setState(() {
                                   Fv4rs.expandedFontSize = value;
                                   Fv4rs.saveExpandedFontSize(value);
                                });
                              }, 
                      onWeightChanged: (value) async {
                                setState(() {
                                   Fv4rs.expandedFontWeight = value;
                                   Fv4rs.saveExpandedFontWeight(value);
                                });
                              }, 
                      onItalicsChanged: (value) async {
                                setState(() {
                                   Fv4rs.expandedFontItalics = value;
                                   Fv4rs.saveExpandedFontItalics(value);
                                });
                              }, 
                      onFontChanged: (value) async {
                                setState(() {
                                   Fv4rs.expandedFont = value;
                                   Fv4rs.saveExpandedFont(value);
                                });
                              }, 
                      onColorChanged: (value) async {
                                setState(() {
                                   Fv4rs.expandedFontColor = value.toColor() ?? Fv4rs.expandedFontColor;
                                   Fv4rs.saveExpandedFontColor(value.toColor() ?? Fv4rs.expandedFontColor);
                                });
                              }, 
                      tts: widget.synth
                      )
                  ],
                    ),

                //
                //message window settings
                //

                ExpansionTile(
                  title: Text('Message Window:', style: Sv4rs.settingslabelStyle,),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                  onExpansionChanged: (bool expanded) {  
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        V4rs.speakOnSelect('Message Window Settings', V4rs.selectedLanguage.value, widget.synth);
                      }},
                  children: [
                    Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15), child: 
                    Row(
                      children: [
                        Text('Clear text after spoken:', style: Sv4rs.settingslabelStyle),
                        Spacer(),
                        Switch(value: V4rs.clearAfterSpeak, onChanged: (value) {
                          setState(() {
                            V4rs.clearAfterSpeak = value;
                            V4rs.saveClearAfterSpeak(value);
                          });
                        }),
                      ]
                    ),
                    ),
                    
                    if (!kIsWeb && Platform.isIOS) 
                      ExpansionTile(
                        title: Row (children: [
                          Text.rich( 
                          TextSpan (
                            children: [ 
                              TextSpan(
                                text: 'Highlight Text as Spoken', 
                                style: Sv4rs.settingslabelStyle
                                ), 
                                TextSpan(
                                  text: ' (iOS only)',
                                  style: Sv4rs.settingslabelStyle.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ), 
                                TextSpan(
                                  text: ':',
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                ])
                                ), 
                                Spacer(),
                                 Switch(
                                  value: V4rs.highlightAsSpoken,
                                  onChanged: (val) { setState(() {
                                      V4rs.highlightAsSpoken = val;
                                      V4rs.saveHighlightAsSpoken(val);
                                  });
                                  },
                                ),
                                ]),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          //underline
                           Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                                children: [
                                  Expanded(flex: 3, child: 
                                    Text('Underline Highlighted Text:', style: Sv4rs.settingslabelStyle),
                                  ),
                                    Spacer(),
                                    Switch(
                                      value: Fv4rs.highlightFontUnderline,
                                      onChanged: (val) {
                                        setState(() {
                                          Fv4rs.highlightFontUnderline = val;
                                          Fv4rs.savehighlightFontUnderline(val);
                                        });
                                      },
                                    ), 
                                  SizedBox(width: 40,)
                                  ],
                                ),
                              
                          ),
                         
                          //italics
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                                children: [
                                  Expanded(flex: 3, child: 
                                    Text('Override Font Italics:', style: Sv4rs.settingslabelStyle),
                                  ),
                                  Expanded(flex: 1, child:
                                    Switch(
                                      value: Fv4rs.uniquehighlightFontItalics,
                                      onChanged: (val) {
                                        setState(() {
                                          Fv4rs.uniquehighlightFontItalics = val;
                                          Fv4rs.saveuniquehighlightFontItalics(val);
                                        });
                                      },
                                    ),
                                  ),
                                  Spacer(flex: 1),
                                  Expanded(flex: 2, child:
                                    Text('Highlight Text Italics:', style: Sv4rs.settingslabelStyle),
                                  ),
                                  Expanded(flex: 2, child: Row(children: [
                                    Spacer(),
                                    Switch(
                                      value: Fv4rs.highlightFontItalics,
                                      onChanged: (val) {
                                        setState(() {
                                          Fv4rs.highlightFontItalics = val;
                                          Fv4rs.savehighlightFontItalics(val);
                                        });
                                      },
                                    ),  
                                ])
                                  ),
                                  SizedBox(width: 40,)
                                  ],
                                ),
                              
                          ),
                          //weight
                          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15), child:
                            Row(
                              children: [
                                Expanded(flex: 3, child:
                                  Text('Override Font Weight:', style: Sv4rs.settingslabelStyle),
                                ),
                                Expanded(flex: 1, child:
                                  Switch(
                                    value: Fv4rs.uniquehighlightFontWeight,
                                    onChanged: (val) {
                                      setState(() {
                                        Fv4rs.uniquehighlightFontWeight = val;
                                        Fv4rs.saveuniquehighlightFontWeight(val);
                                      });
                                    },
                                  ),
                                ),
                                Spacer(flex: 1),
                                Expanded(flex: 2, child: 
                                  Text('Highlight Text Weight:', style: Sv4rs.settingslabelStyle),
                                ),
                                Expanded(flex: 2, child: 
                                  Slider(
                                    value: Fv4rs.highlightFontWeight.toDouble(),
                                    min: 100,
                                    max: 900,
                                    divisions: 8,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    onChanged: (val) {
                                      setState(() {
                                        Fv4rs.highlightFontWeight = val.toInt();
                                        Fv4rs.savehighlightFontWeight(val.toInt());
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: 40),
                              ],
                            ),
                          ),
                          //highlight
                          ExpansionTile(
                            title: Row(
                              children: [
                                Expanded(flex: 3, child: 
                                  Text('Highlight Highlighted Text:', style: Sv4rs.settingslabelStyle, ),
                                ),
                                Expanded(flex: 1, child:
                                  Switch(
                                    value: Fv4rs.uniquehighlightFontBColor,
                                    onChanged: (val) { setState(() {
                                        Fv4rs.uniquehighlightFontBColor = val;
                                        Fv4rs.saveuniquehighlightFontBColor(val);
                                    });
                                    },
                                  ),
                                  ),
                                  Spacer(flex: 1),
                                  Expanded(flex: 2, child: 
                                    Text('Highlight Color:', style: Sv4rs.settingslabelStyle, ),
                                  ),
                                  Expanded(flex: 2, child: 
                                    Row(children: [
                                      Spacer(),
                                      CircleAvatar(
                                        backgroundColor: Cv4rs.themeColor3,
                                        radius: 20,
                                        child: Icon(Icons.circle, color: Fv4rs.highlightBackgroundFontColor, size: 40, shadows: [
                                          Shadow(
                                            color: Cv4rs.themeColor4,
                                            blurRadius: 4,
                                          ),
                                        ],),
                                      ),
                                      ]
                                    ),
                                  ),
                              ]
                            ),
                          children: [
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                              child: HexCodeInput(
                                startValue: Fv4rs.highlightBackgroundFontColor.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) {
                                  setState(() {
                                      Fv4rs.highlightBackgroundFontColor = color;
                                      Fv4rs.savehighlightBackgroundFontColor(color);
                                  });
                                },
                              ),
                            ),
                            //color picker
                            Padding(
                              padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                              child: ColorPicker(
                                pickerColor: Fv4rs.highlightBackgroundFontColor, 
                                enableAlpha: false,
                                displayThumbColor: false,
                                labelTypes: ColorLabelType.values,
                                onColorChanged:  (Color color) {
                                    setState(() {
                                      Fv4rs.highlightBackgroundFontColor = color;
                                      Fv4rs.savehighlightBackgroundFontColor(color);
                                  });
                                },
                              ),
                          ),
                          ],
                        ),
                          //highlighted text color
                          ExpansionTile(
                            title: Row(
                              children: [
                                Expanded(flex: 3, child: 
                                  Text('Override Font Color:', style: Sv4rs.settingslabelStyle, ),
                                ),
                                Expanded(flex: 1, child: 
                                  Switch(
                                    value: Fv4rs.uniquehighlightFontColor,
                                    onChanged: (val) { setState(() {
                                        Fv4rs.uniquehighlightFontColor = val;
                                        Fv4rs.saveuniquehighlightFontColor(val);
                                    });
                                    },
                                  ),
                                ),
                                Spacer(flex: 1),
                                Expanded( flex: 2, child:
                                  Text('Highlighted Text Color', style: Sv4rs.settingslabelStyle),
                                ),
                                Expanded(flex: 2, child: 
                                   Row(children: [
                                    const Spacer(),
                                    CircleAvatar(
                                      backgroundColor: Cv4rs.themeColor3,
                                      radius: 20,
                                      child: Icon(Icons.circle, color: Fv4rs.highlightFontColor, size: 40, shadows: [
                                        Shadow(
                                          color: Cv4rs.themeColor4,
                                          blurRadius: 4,
                                        ),
                                      ],),
                                      )
                                  ])
                                ),
                              ]
                            ),
                            children: [
                              //hexcode input
                              Padding(
                                padding: EdgeInsetsGeometry.symmetric(horizontal: 40, vertical: 20),
                                child: HexCodeInput(
                                  startValue: Fv4rs.highlightFontColor.toHexString(),
                                  textStyle: Sv4rs.settingslabelStyle,
                                  hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                  onColorChanged: (color) {
                                    setState(() {
                                        Fv4rs.highlightFontColor = color;
                                        Fv4rs.savehighlightFontColor(color);
                                    });
                                  },
                                ),
                              ),
                              //color picker
                              Padding(
                                padding: EdgeInsets.fromLTRB(40, 0, 10, 10),
                                child: ColorPicker(
                                  pickerColor: Fv4rs.highlightFontColor, 
                                  enableAlpha: false,
                                  displayThumbColor: false,
                                  labelTypes: ColorLabelType.values,
                                  onColorChanged:  (Color color) {
                                      setState(() {
                                        Fv4rs.highlightFontColor = color;
                                        Fv4rs.savehighlightFontColor(color);
                                    });
                                  },
                                ),
                            ),
                            ],
                          ),
                        ],
                      ),
                    
                    Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15), child: 
                    Row(
                      children: [
                        Text('Show Scroll Buttons:', style: Sv4rs.settingslabelStyle),
                        Spacer(),
                        Switch(value: V4rs.showScrollButtons, onChanged: (value) {
                          setState(() {
                            V4rs.showScrollButtons = value;
                            V4rs.saveshowScrollButtons(value);
                          });
                        }),
                      ]
                    ),
                    ),

                    Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15), child: 
                    Row(
                      children: [
                        Text('Show Language Selector Slider:', style: Sv4rs.settingslabelStyle),
                        Spacer(),
                        Switch(value: V4rs.showLanguageSelectorSlider, onChanged: (value) {
                          setState(() {
                            V4rs.showLanguageSelectorSlider = value;
                            V4rs.saveshowLanguageSelectorSlider(value);
                          });
                        }),
                      ]
                    ),
                    ),

                    //mw Font Settings
                    FontPicker1(
                      useUnderline: false,
                      onUnderlineChanged: (value) async {},
                      size: Fv4rs.mwFontSize, 
                      weight: Fv4rs.mwFontWeight, 
                      italics: Fv4rs.mwFontItalics, 
                      font: Fv4rs.mwFont, 
                      label: 'Font Settings:', 
                      color: Fv4rs.mwFontColor, 
                      onSizeChanged: (value) async {
                                setState(() {
                                   Fv4rs.mwFontSize = value;
                                   Fv4rs.savemwFontSize(value);
                                });
                              }, 
                      onWeightChanged: (value) async {
                                setState(() {
                                   Fv4rs.mwFontWeight = value;
                                   Fv4rs.savemwFontWeight(value);
                                });
                              }, 
                      onItalicsChanged: (value) async {
                                setState(() {
                                   Fv4rs.mwFontItalics = value;
                                   Fv4rs.savemwFontItalics(value);
                                });
                              }, 
                      onFontChanged: (value) async {
                                setState(() {
                                   Fv4rs.mwFont = value;
                                   Fv4rs.savemwFont(value);
                                });
                              }, 
                      onColorChanged: (value) async {
                                setState(() {
                                   Fv4rs.mwFontColor = value.toColor() ?? Fv4rs.mwFontColor;
                                   Fv4rs.savemwFontColor(value.toColor() ?? Fv4rs.mwFontColor);
                                });
                              }, 
                      tts: widget.synth
                      )
                  
                  ],
                    ),

                
                //
                //boardset settings
                //

                ExpansionTile(
                  title: Text('Boardset:', style: Sv4rs.settingslabelStyle,),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                  onExpansionChanged: (bool expanded) {  
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        V4rs.speakOnSelect('Boardset Settings', V4rs.selectedLanguage.value, widget.synth);
                      }},
                  children: [
                    //share boardset
                    ExpansionTile(
                      title: Text('Export Boardset:', style: Sv4rs.settingslabelStyle),
                      collapsedBackgroundColor: Cv4rs.themeColor4,
                      backgroundColor: Cv4rs.themeColor4,
                      childrenPadding: EdgeInsets.symmetric(horizontal: 40),
                      children: [ 
                        Row(
                        children: [
                          Text('Boardset: ', style: Sv4rs.settingslabelStyle),
                          Spacer(),
                          if (ExV4rs.fileToExport != null)
                          DropdownButton<String>(
                            value: ExV4rs.fileToExport!.path, 
                            dropdownColor: Cv4rs.themeColor4,
                            hint: Text(ExV4rs.getFileName(ExV4rs.fileToExport!)),
                            items: V4rs.myBoardsets.map((file) {
                              return DropdownMenuItem<String>(
                                value: file.path,
                                child: Text(ExV4rs.getFileName(file), style: Sv4rs.settingslabelStyle),
                                );
                              }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  ExV4rs.fileToExport = File(value);
                                  });
                                }
                              },
                            ),
                          ]
                        ),
                        Row (children: [
                          Spacer(),
                          Expanded(child: 
                            TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.center,
                                backgroundColor: Cv4rs.themeColor2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10), 
                                    child: Text('Export File', style: Fv4rs.mwLabelStyle.copyWith(
                                      color: Cv4rs.themeColor4,
                                    )),
                                  ),
                                LoadingIndicator(notifier: ExV4rs.loading),
                                ]),
                              onPressed: () async {
                                final zipFile = await ExV4rs.createBoardsetZip();
                                  await Share.shareXFiles(
                                    [XFile(zipFile.path, mimeType: 'application/zip')],
                                    sharePositionOrigin: Rect.fromLTWH(position.dx, position.dy, size.width, size.height),
                                  );
                              }, 
                            ),
                          ),
                          Spacer(),
                          Expanded(child:
                            TextButton(
                              style: TextButton.styleFrom(
                                alignment: Alignment.center,
                                backgroundColor: Cv4rs.themeColor2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.symmetric(horizontal: 10), 
                                    child: Text('Print', style: Fv4rs.mwLabelStyle.copyWith(
                                      color: Cv4rs.themeColor4,
                                    )),
                                  ),
                                ]),
                              onPressed: () {
                                setState(() {
                                  showPrintPop(context, widget.captureAllForPrint);
                                });
                              }, 
                            ),
                          ),
                          Spacer(),
                        ]
                        ),
                      ]),


                    //new boardset

                    //POS colors
                    ExpansionTile(
                      title: Text('Part of Speech Colors:', style: Sv4rs.settingslabelStyle),
                      collapsedBackgroundColor: Cv4rs.themeColor4,
                      backgroundColor: Cv4rs.themeColor4,
                      childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        ExpansionTile(
                          title: Text('Background Colors:', style: Sv4rs.settingslabelStyle),
                          collapsedBackgroundColor: Cv4rs.themeColor4,
                          backgroundColor: Cv4rs.themeColor4,
                          childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            ColorPickerWithHex(
                              label: 'Determiner Color:', 
                              color: Cv4rs.determiner, 
                              onColorChanged: (value) {setState(() {
                                Cv4rs.determiner = value;
                                Cv4rs.saveDeterminerColor(value);
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Preposition Color:', 
                              color: Cv4rs.preposition, 
                              onColorChanged: (value) {setState(() {
                                Cv4rs.preposition = value;
                                Cv4rs.savePrepositionColor(value);
                              });
                              }
                              ),
                            ColorPickerWithHex(
                              label: 'Conjunction Color:', 
                              color: Cv4rs.conjunction, 
                              onColorChanged: (value) {setState(() {
                                Cv4rs.conjunction = value;
                                Cv4rs.saveConjunctionColor(value);
                              });}
                              ),

                            ColorPickerWithHex(
                              label: 'Pronoun Color:', 
                              color: Cv4rs.pronoun, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.pronoun = value;
                                Cv4rs.savePronounColor(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Social Words Color:', 
                              color: Cv4rs.social, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.social = value;
                                Cv4rs.saveSocialColor(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Interjection Color:', 
                              color: Cv4rs.interjection, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.interjection = value;
                                Cv4rs.saveInterjectionColor(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Adjective Color:', 
                              color: Cv4rs.adjective, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.adjective = value;
                                Cv4rs.saveAdjectiveColor(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Verb Color:', 
                              color: Cv4rs.verb, 
                              onColorChanged:(value) {setState(() { 
                                 Cv4rs.verb = value;
                                Cv4rs.saveVerbColor(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Noun Color:', 
                              color: Cv4rs.noun, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.noun = value;
                                Cv4rs.saveNounColor(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Adverb Color:', 
                              color: Cv4rs.adverb,
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.adverb = value;
                                Cv4rs.saveAdverbColor(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Question Words Color:', 
                              color: Cv4rs.question, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.question = value;
                                Cv4rs.saveQuestionColor(value); 
                                });}
                              ),

                            ColorPickerWithHex(
                              label: 'Extra Color 1:', 
                              color: Cv4rs.extra1, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.extra1 = value;
                                Cv4rs.saveExtra1Color(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Extra Color 2:', 
                              color: Cv4rs.extra2, 
                              onColorChanged: (value) {setState(() { 
                                Cv4rs.extra2 = value;
                                Cv4rs.saveExtra2Color(value); 
                                });}
                              ),
                            ColorPickerWithHex(
                              label: 'Folder Color:', 
                              color: Cv4rs.folder, 
                              onColorChanged:  (value) {setState(() { 
                                Cv4rs.folder = value;
                                Cv4rs.saveFolderColor(value); 
                                });}
                              ),
                            ]
                            ),
                            
                        ExpansionTile(
                          title: Text('Border Colors:', style: Sv4rs.settingslabelStyle),
                          collapsedBackgroundColor: Cv4rs.themeColor4,
                          backgroundColor: Cv4rs.themeColor4,
                          childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            ColorPickerWithHex(
                              label: 'Determiner Border Color:',
                              color: Cv4rs.determinerBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.determinerBorder = value;
                                  Cv4rs.saveDeterminerBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Preposition Border Color:',
                              color: Cv4rs.prepositionBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.prepositionBorder = value;
                                  Cv4rs.savePrepositionBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Conjunction Border Color:',
                              color: Cv4rs.conjunctionBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.conjunctionBorder = value;
                                  Cv4rs.saveConjunctionBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Pronoun Border Color:',
                              color: Cv4rs.pronounBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.pronounBorder = value;
                                  Cv4rs.savePronounBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Social Words Border Color:',
                              color: Cv4rs.socialBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.socialBorder = value;
                                  Cv4rs.saveSocialBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Interjection Border Color:',
                              color: Cv4rs.interjectionBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.interjectionBorder = value;
                                  Cv4rs.saveInterjectionBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Adjective Border Color:',
                              color: Cv4rs.adjectiveBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.adjectiveBorder = value;
                                  Cv4rs.saveAdjectiveBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Verb Border Color:',
                              color: Cv4rs.verbBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.verbBorder = value;
                                  Cv4rs.saveVerbBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Noun Border Color:',
                              color: Cv4rs.nounBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.nounBorder = value;
                                  Cv4rs.saveNounBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Adverb Border Color:',
                              color: Cv4rs.adverbBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.adverbBorder = value;
                                  Cv4rs.saveAdverbBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Question Words Border Color:',
                              color: Cv4rs.questionBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.questionBorder = value;
                                  Cv4rs.saveQuestionBorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Extra Border Color 1:',
                              color: Cv4rs.extra1Border,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.extra1Border = value;
                                  Cv4rs.saveExtra1BorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Extra Border Color 2:',
                              color: Cv4rs.extra2Border,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.extra2Border = value;
                                  Cv4rs.saveExtra2BorderColor(value);
                                });
                              },
                            ),
                            ColorPickerWithHex(
                              label: 'Folder Border Color:',
                              color: Cv4rs.folderBorder,
                              onColorChanged: (value) {
                                setState(() {
                                  Cv4rs.folderBorder = value;
                                  Cv4rs.saveFolderBorderColor(value);
                                });
                              },
                            ),
                          ],
                            ),
                        ]
                        ),
                   
                    //Nav Row settings
                    ExpansionTile(
                    title: Text('Navigation Row:', style: Sv4rs.settingslabelStyle),
                    collapsedBackgroundColor: Cv4rs.themeColor4,
                    backgroundColor: Cv4rs.themeColor4,
                    childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                      children: [

                      //show nav row
                      ExpansionTile(
                        title: Text('Visibility:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                            Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.showNavRow.toDouble(),
                                    min: 1.0,
                                    max: 3.0,
                                    divisions: 2,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Show Nav Row: ${Bv4rs.showNavRow}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.showNavRow = value.toInt();
                                        Bv4rs.saveShowNavRow(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Show Nav Row', style: Sv4rs.settingslabelStyle),
                                      Text('Hide in Place', style: Sv4rs.settingslabelStyle),
                                      Text('Hide', style: Sv4rs.settingslabelStyle),
                                    ],
                              ),
                            ]
                            ),
                          )
                        ]
                        ),
                      
                      //center buttons
                      ExpansionTile(
                        title: Text('Center Buttons:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.showCenterButtons.toDouble(),
                                    min: 1.0,
                                    max: 3.0,
                                    divisions: 2,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Show Center Buttons: ${Bv4rs.showNavRow}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.showCenterButtons = value.toInt();
                                        Bv4rs.saveShowCenterButtons(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Show', style: Sv4rs.settingslabelStyle),
                                      Text('Hide in Place', style: Sv4rs.settingslabelStyle),
                                      Text('Hide', style: Sv4rs.settingslabelStyle),
                                    ],
                              ),
                            ]
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.centerButtonFormat.toDouble(),
                                    min: 1.0,
                                    max: 4.0,
                                    divisions: 3,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Center Button Format: ${Bv4rs.centerButtonFormat}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.centerButtonFormat = value.toInt();
                                        Bv4rs.saveCenterButtonFormat(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Text Below', style: Sv4rs.settingslabelStyle),
                                      Text('Text Above', style: Sv4rs.settingslabelStyle),
                                      Text('Image Only', style: Sv4rs.settingslabelStyle),
                                      Text('Text Only', style: Sv4rs.settingslabelStyle),
                              ],
                              ),
                            ]
                            ),
                          )
                        
                        ]
                        ),
                      
                      //button format
                      ExpansionTile(
                        title: Text('Button Format:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                      Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: 
                                  Row(
                                children: [
                                  Text('Border Weight', style: Sv4rs.settingslabelStyle),
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.navRowBorderWeight,
                                    min: 0.0,
                                    max: 10.0,
                                    divisions: 20,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Border Weight: ${Bv4rs.navRowBorderWeight}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.navRowBorderWeight = value;
                                        Bv4rs.saveNavRowBorderWeight(value);
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                          ),
                      
                      Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.navButtonFormat.toDouble(),
                                    min: 1.0,
                                    max: 4.0,
                                    divisions: 3,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Button Format: ${Bv4rs.navButtonFormat}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.navButtonFormat = value.toInt();
                                        Bv4rs.saveNavButtonFormat(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Text Below', style: Sv4rs.settingslabelStyle),
                                      Text('Text Above', style: Sv4rs.settingslabelStyle),
                                      Text('Image Only', style: Sv4rs.settingslabelStyle),
                                      Text('Text Only', style: Sv4rs.settingslabelStyle),
                              ],
                              ),
                            ]
                            ),
                          ),
                      
                        ]
                      ),
                      //speak on select
                      ExpansionTile(
                        title: Text('Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                        Column(
                          children: [
                            Row(
                          children: [
                            Expanded(
                            child: Slider(
                              value: Bv4rs.navRowSpeakOnSelect.toDouble(),
                              min: 1.0,
                              max: 3.0,
                              divisions: 2,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Speak on Select: ${Bv4rs.navRowSpeakOnSelect}',
                              onChanged: (value) async {
                                setState(() {
                                  Bv4rs.navRowSpeakOnSelect = value.toInt();
                                  Bv4rs.saveNavRowSpeakOnSelect(value.toInt());
                                });
                              },
                            ),
                            ),
                          ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child:
                                Text('Off', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Alternate Label', style: Sv4rs.settingslabelStyle),),
                              ],
                            )
                          ]),
                        )
                        ]
                        ),
                      //symbol colors
                      SymbolColorCustomizer(
                        invert: Bv4rs.navRowSymbolInvert,
                        overlay: Bv4rs.navRowSymbolColorOverlay,
                        saturation: 1.0,
                        contrast: 1.0,
                        onInvertChanged: (val) { setState(() {
                          Bv4rs.navRowSymbolInvert = val;
                          Bv4rs.saveNavRowSymbolInvert(val);
                          });
                        },
                        onOverlayChanged: (val) { setState(() {
                          Bv4rs.navRowSymbolColorOverlay = val;
                          Bv4rs.saveNavRowSymbolColorOverlay(val);
                          });
                        },
                        onSaturationChanged: (val) { setState(() {
                          Bv4rs.navRowSymbolSaturation = val;
                          Bv4rs.saveNavRowSymbolSaturation(val);
                          });
                        },
                        onContrastChanged: (val) { setState(() {
                          Bv4rs.navRowSymbolContrast = val;
                          Bv4rs.saveNavRowSymbolContrast(val);
                          });
                        },
                        tts: widget.synth
                      ),
                      
                      //font picker
                      FontPicker1(
                        useUnderline: true,
                        underline: Fv4rs.navRowFontUnderline,
                        onUnderlineChanged: Fv4rs.savenavRowFontUnderline,
                        size: Fv4rs.navRowFontSize, 
                        weight: Fv4rs.navRowFontWeight, 
                        italics: Fv4rs.navRowFontItalics, 
                        font: Fv4rs.navRowFont, 
                        label: 'Font Settings:', 
                        color: Fv4rs.navRowFontColor, 
                        onSizeChanged: (value) {
                          setState(() {
                            Fv4rs.navRowFontSize = value;
                            Fv4rs.savenavRowFontSize(value);
                          });
                        },
                        onWeightChanged:(value) {
                          setState(() {
                            Fv4rs.navRowFontWeight = value;
                            Fv4rs.savenavRowFontWeight(value);
                          });
                        },
                        onItalicsChanged: (value) {
                          setState(() {
                            Fv4rs.navRowFontItalics = value;
                            Fv4rs.savenavRowFontItalics(value);
                          });
                        },
                        onFontChanged: (value) {
                          setState(() {
                            Fv4rs.navRowFont = value;
                            Fv4rs.savenavRowFont(value);
                          });
                        },
                        onColorChanged: (value) async {
                              setState(() {
                                  Fv4rs.navRowFontColor = value.toColor() ?? Fv4rs.navRowFontColor;
                                  Fv4rs.savenavRowFontColor(value.toColor() ?? Fv4rs.navRowFontColor);
                              });
                            }, 
                        tts: widget.synth
                        ),



                      ]
                      ),  
                    
                    //grammer Row settings
                    ExpansionTile(
                    title: Text('Grammer Row:', style: Sv4rs.settingslabelStyle),
                    collapsedBackgroundColor: Cv4rs.themeColor4,
                    backgroundColor: Cv4rs.themeColor4,
                    childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                      children: [

                      //show grammer row
                      ExpansionTile(
                        title: Text('Visibility:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 40),
                        children: [
                            Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.showGrammerRow.toDouble(),
                                    min: 1.0,
                                    max: 3.0,
                                    divisions: 2,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Show Grammer Row: ${Bv4rs.showGrammerRow}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.showGrammerRow = value.toInt();
                                        Bv4rs.saveShowGrammerRow(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Show', style: Sv4rs.settingslabelStyle),
                                      Text('Hide in Place', style: Sv4rs.settingslabelStyle),
                                      Text('Hide', style: Sv4rs.settingslabelStyle),
                                    ],
                              ),
                            ]
                            ),
                        ]
                        ),
                      //format
                      ExpansionTile(
                        title: Text('Format:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 40),
                        children: [
                          Column(
                        children: [
                          Row(
                        children: [
                          Expanded(
                          child: Slider(
                            value: Bv4rs.grammerRowFormat.toDouble(),
                            min: 1.0,
                            max: 4.0,
                            divisions: 3,
                            activeColor: Cv4rs.themeColor1,
                            inactiveColor: Cv4rs.themeColor3,
                            thumbColor: Cv4rs.themeColor1,
                            label: 'Button Format: ${Bv4rs.grammerRowFormat}',
                            onChanged: (value) async {
                              setState(() {
                                Bv4rs.grammerRowFormat = value.toInt();
                                Bv4rs.savegrammerRowFormat(value.toInt());
                              });
                            },
                          ),
                          ),
                        ]
                        ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Text Right', style: Sv4rs.settingslabelStyle),
                              Text('Text Left', style: Sv4rs.settingslabelStyle),
                              Text('Image Only', style: Sv4rs.settingslabelStyle),
                              Text('Text Only', style: Sv4rs.settingslabelStyle),
                      ],
                      ),
                    ]
                      ),
                        ]),
                      //speak OS
                       ExpansionTile(
                        title: Text('Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                        Column(
                          children: [
                            Row(
                          children: [
                            Expanded(
                            child: Slider(
                              value: Bv4rs.grammerRowSpeakOnSelect.toDouble(),
                              min: 1.0,
                              max: 3.0,
                              divisions: 2,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Speak on Select: ${Bv4rs.grammerRowSpeakOnSelect}',
                              onChanged: (value) async {
                                setState(() {
                                  Bv4rs.grammerRowSpeakOnSelect = value.toInt();
                                  Bv4rs.savegrammerRowSpeakOnSelect(value.toInt());
                                });
                              },
                            ),
                            ),
                          ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child:
                                Text('Off', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Change', style: Sv4rs.settingslabelStyle),),
                              ],
                            )
                          ]),
                        )
                        ]
                        ),
                      //symbol COlors
                        SymbolColorCustomizer(
                          invert: Bv4rs.grammerRowSymbolInvert, 
                          overlay: Bv4rs.grammerRowSymbolColorOverlay, 
                          saturation: Bv4rs.grammerRowSymbolSaturation, 
                          contrast: Bv4rs.grammerRowSymbolContrast, 
                          onContrastChanged: (val) { setState(() {
                            Bv4rs.grammerRowSymbolContrast = val;
                            Bv4rs.savegrammerRowSymbolContrast(val);
                            });
                          },
                          onInvertChanged: (val) { setState(() {
                          Bv4rs.grammerRowSymbolInvert = val;
                          Bv4rs.savegrammerRowSymbolInvert(val);
                            });
                          }, 
                          onOverlayChanged: (value) { setState(() {
                            Bv4rs.grammerRowSymbolColorOverlay = value;
                            Bv4rs.savegrammerRowSymbolColorOverlay(value);
                            });
                          }, 
                          onSaturationChanged: (val) { setState(() {
                            Bv4rs.grammerRowSymbolSaturation = val;
                            Bv4rs.savegrammerRowSymbolSaturation(val);
                            });
                          }, 
                          tts: widget.synth),
                      //font
                        FontPicker1(
                          size: Fv4rs.grammerFontSize, 
                          useUnderline: true,
                          weight: Fv4rs.grammerFontWeight, 
                          italics: Fv4rs.grammerFontItalics, 
                          font: Fv4rs.grammerFont, 
                          label: 'Grammer Row Font Picker', 
                          color: Fv4rs.grammerFontColor, 
                          onSizeChanged: (value) {
                            setState(() {
                              Fv4rs.grammerFontSize = value;
                              Fv4rs.savegrammerFontSize(value);
                            });
                          },
                          onWeightChanged: (value) {
                            setState(() {
                              Fv4rs.grammerFontWeight = value;
                              Fv4rs.savegrammerFontWeight(value);
                            });
                          },
                          onItalicsChanged: (value) {
                            setState(() {
                              Fv4rs.grammerFontItalics = value;
                              Fv4rs.savegrammerFontItalics(value);
                            });
                          }, 
                          onFontChanged: (value) {
                            setState(() {
                              Fv4rs.grammerFont = value;
                              Fv4rs.savegrammerFont(value);
                            });
                          },
                          onColorChanged: (value) {
                            setState(() {
                              Fv4rs.grammerFontColor= value.toColor() ?? Fv4rs.grammerFontColor;
                              Fv4rs.savegrammerFontColor(value.toColor() ?? Fv4rs.grammerFontColor);
                            });
                          }, 
                          onUnderlineChanged: (value) {
                            setState(() {
                              Fv4rs.grammerFontUnderline = value;
                              Fv4rs.savegrammerFontUnderline(value);
                            });
                          }, 
                          tts: widget.synth)

                      ]
                      ),

                    //sub folder Row settings
                    ExpansionTile(
                    title: Text('Sub Folder Settings:', style: Sv4rs.settingslabelStyle),
                    collapsedBackgroundColor: Cv4rs.themeColor4,
                    backgroundColor: Cv4rs.themeColor4,
                    childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      //use sub folders
                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15), child:
                      Row(
                      children: [
                        Text('Use Sub-Folders:', style: Sv4rs.settingslabelStyle, ),
                        Spacer(),
                          Switch(
                            value: V4rs.primaryUseSubFolders,
                            onChanged: (val) { setState(() {
                                V4rs.primaryUseSubFolders = val;
                                V4rs.saveUseSubFolders(val);
                            });
                            },
                          ),
                        ]
                      ),
                      ),
                      //format
                       ExpansionTile(
                        title: Text('Button Format:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: 
                            Row( children: [
                              Text('Border Weight', style: Sv4rs.settingslabelStyle),
                                Expanded(
                                  child: Slider(
                                    value: Bv4rs.subFolderBorderWeight,
                                    min: 0.0,
                                    max: 10.0,
                                    divisions: 20,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Border Weight: ${Bv4rs.subFolderBorderWeight}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.subFolderBorderWeight = value;
                                        Bv4rs.saveSubFolderBorderWeight(value);
                                      });
                                    },
                                  ),
                                ),
                               ]),
                          ),
                      
                      Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.subFolderFormat.toDouble(),
                                    min: 1.0,
                                    max: 4.0,
                                    divisions: 3,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Button Format: ${Bv4rs.subFolderFormat}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.subFolderFormat = value.toInt();
                                        Bv4rs.saveSubFolderFormat(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Text Right', style: Sv4rs.settingslabelStyle),
                                      Text('Text Left', style: Sv4rs.settingslabelStyle),
                                      Text('Image Only', style: Sv4rs.settingslabelStyle),
                                      Text('Text Only', style: Sv4rs.settingslabelStyle),
                              ],
                              ),
                            ]
                            ),
                          ),
                      
                        ]
                      ),
                      //speakOS
                       ExpansionTile(
                        title: Text('Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                        Column(
                          children: [
                            Row(
                          children: [
                            Expanded(
                            child: Slider(
                              value: Bv4rs.subFolderSpeakOnSelect.toDouble(),
                              min: 1.0,
                              max: 3.0,
                              divisions: 2,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Speak on Select: ${Bv4rs.subFolderSpeakOnSelect}',
                              onChanged: (value) async {
                                setState(() {
                                  Bv4rs.subFolderSpeakOnSelect = value.toInt();
                                  Bv4rs.saveSubFolderSpeakOnSelect(value.toInt());
                                });
                              },
                            ),
                            ),
                          ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child:
                                Text('Off', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Alternate Label', style: Sv4rs.settingslabelStyle),),
                              ],
                            )
                          ]),
                        )
                        ]
                        ),
                       //symbol colors
                       SymbolColorCustomizer(
                        invert: Bv4rs.subFolderSymbolInvert, 
                        overlay: Bv4rs.subFolderSymbolColorOverlay, 
                        saturation: Bv4rs.subFolderSymbolSaturation, 
                        contrast: Bv4rs.subFolderSymbolContrast, 
                        onContrastChanged: (val) { setState(() {
                          Bv4rs.subFolderSymbolContrast = val;
                          Bv4rs.savesubFolderSymbolContrast(val);
                          });
                        }, 
                        onInvertChanged: (val) { setState(() {
                          Bv4rs.subFolderSymbolInvert = val;
                          Bv4rs.savesubFolderSymbolInvert(val);
                          });
                        }, 
                        onOverlayChanged: (val) { setState(() {
                          Bv4rs.subFolderSymbolColorOverlay = val;
                          Bv4rs.savesubFolderSymbolColorOverlay(val);
                          });
                        }, 
                        onSaturationChanged: (val) { setState(() {
                          Bv4rs.subFolderSymbolSaturation = val;
                          Bv4rs.savesubFolderSymbolSaturation(val);
                          });
                        },
                        tts: widget.synth,
                        ),
                       //font
                       FontPicker1(
                        size: Fv4rs.subFolderFontSize, 
                        weight: Fv4rs.subFolderFontWeight, 
                        italics: Fv4rs.subFolderFontItalics, 
                        useUnderline: true,
                        underline: Fv4rs.subFolderFontUnderline,
                        font: Fv4rs.subFolderFont, 
                        label: 'Sub-Folder Font:', 
                        color: Fv4rs.subFolderFontColor, 
                        onSizeChanged: (value) {
                          setState(() {
                            Fv4rs.subFolderFontSize = value;
                            Fv4rs.savesubFolderFontSize(value);
                          });
                        },
                        onWeightChanged: (value) {
                          setState(() {
                            Fv4rs.subFolderFontWeight = value;
                            Fv4rs.savesubFolderFontWeight(value);
                          });
                        },
                        onItalicsChanged: (value) {
                          setState(() {
                            Fv4rs.subFolderFontItalics = value;
                            Fv4rs.savesubFolderFontItalics(value);
                          });
                        }, 
                        onFontChanged: (value) {
                          setState(() {
                            Fv4rs.subFolderFont = value;
                            Fv4rs.savesubFolderFont(value);
                          });
                        },
                        onColorChanged: (value) {
                          setState(() {
                            Fv4rs.subFolderFontColor= value.toColor() ?? Fv4rs.subFolderFontColor;
                            Fv4rs.savesubFolderFontColor(value.toColor() ?? Fv4rs.subFolderFontColor);
                          });
                        }, 
                        onUnderlineChanged: (value) {
                          setState(() {
                            Fv4rs.subFolderFontUnderline = value;
                            Fv4rs.savesubFolderFontUnderline(value);
                          });
                        }, 
                        tts: widget.synth
                        ),
              
                    ]
                    ),

                    //Button settings
                    ExpansionTile(
                    title: Text('Button Settings:', style: Sv4rs.settingslabelStyle),
                    collapsedBackgroundColor: Cv4rs.themeColor4,
                    backgroundColor: Cv4rs.themeColor4,
                    childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      //button format
                      ExpansionTile(
                        title: Text('Button Format:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: 
                            Row( children: [
                              Text('Border Weight', style: Sv4rs.settingslabelStyle),
                                Expanded(
                                  child: Slider(
                                    value: Bv4rs.buttonBorderWeight,
                                    min: 0.0,
                                    max: 10.0,
                                    divisions: 20,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Border Weight: ${Bv4rs.buttonBorderWeight}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.buttonBorderWeight = value;
                                        Bv4rs.saveButtonBorderWeight(value);
                                      });
                                    },
                                  ),
                                ),
                               ]),
                          ),
                      
                      Padding(
                            padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20),
                            child: Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.buttonFormat.toDouble(),
                                    min: 1.0,
                                    max: 4.0,
                                    divisions: 3,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Button Format: ${Bv4rs.buttonFormat}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.buttonFormat = value.toInt();
                                        Bv4rs.saveButtonFormat(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]
                                ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Text Below', style: Sv4rs.settingslabelStyle),
                                      Text('Text Above', style: Sv4rs.settingslabelStyle),
                                      Text('Image Only', style: Sv4rs.settingslabelStyle),
                                      Text('Text Only', style: Sv4rs.settingslabelStyle),
                              ],
                              ),
                            ]
                            ),
                          ),
                      
                        ]
                      ),
                      //speak on select
                      ExpansionTile(
                        title: Text('Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                           ExpansionTile(
                              title: Text('Button Speak on Select:', style: Sv4rs.settingslabelStyle),
                              collapsedBackgroundColor: Cv4rs.themeColor4,
                              backgroundColor: Cv4rs.themeColor4,
                              childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                              children: [
                                Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                              Column(
                                children: [
                                  Row(
                                children: [
                                  Expanded(
                                  child: Slider(
                                    value: Bv4rs.buttonSpeakOnSelect.toDouble(),
                                    min: 1.0,
                                    max: 3.0,
                                    divisions: 2,
                                    activeColor: Cv4rs.themeColor1,
                                    inactiveColor: Cv4rs.themeColor3,
                                    thumbColor: Cv4rs.themeColor1,
                                    label: 'Speak on Select: ${Bv4rs.buttonSpeakOnSelect}',
                                    onChanged: (value) async {
                                      setState(() {
                                        Bv4rs.buttonSpeakOnSelect = value.toInt();
                                        Bv4rs.saveButtonSpeakOnSelect(value.toInt());
                                      });
                                    },
                                  ),
                                  ),
                                ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(flex: 1, child:
                                      Text('Off', style: Sv4rs.settingslabelStyle),),
                                      Spacer(flex: 3),
                                      Expanded( flex: 1, child:
                                      Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                      Spacer(flex: 3),
                                      Expanded( flex: 1, child:
                                      Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                                    ],
                                  )
                                ]),
                              )
                              ]
                             ),
                           ExpansionTile(
                        title: Text('Pocket Folder Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                        Column(
                          children: [
                            Row(
                          children: [
                            Expanded(
                            child: Slider(
                              value: Bv4rs.pocketFolderSpeakOnSelect.toDouble(),
                              min: 1.0,
                              max: 3.0,
                              divisions: 2,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Speak on Select: ${Bv4rs.pocketFolderSpeakOnSelect}',
                              onChanged: (value) async {
                                setState(() {
                                  Bv4rs.pocketFolderSpeakOnSelect = value.toInt();
                                  Bv4rs.savepocketFolderSpeakOnSelect(value.toInt());
                                });
                              },
                            ),
                            ),
                          ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child:
                                Text('Off', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                              ],
                            )
                          ]),
                        )
                        ]
                        ),
                           ExpansionTile(
                        title: Text('Folder Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                        Column(
                          children: [
                            Row(
                          children: [
                            Expanded(
                            child: Slider(
                              value: Bv4rs.folderSpeakOnSelect.toDouble(),
                              min: 1.0,
                              max: 3.0,
                              divisions: 2,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Speak on Select: ${Bv4rs.folderSpeakOnSelect}',
                              onChanged: (value) async {
                                setState(() {
                                  Bv4rs.folderSpeakOnSelect = value.toInt();
                                  Bv4rs.savefolderSpeakOnSelect(value.toInt());
                                });
                              },
                            ),
                            ),
                          ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child:
                                Text('Off', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                              ],
                            )
                          ]),
                        )
                        ]
                        ),
                           ExpansionTile(
                        title: Text('Audio Tile Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                        Column(
                          children: [
                            Row(
                          children: [
                            Expanded(
                            child: Slider(
                              value: Bv4rs.audioTileSpeakOnSelect.toDouble(),
                              min: 1.0,
                              max: 3.0,
                              divisions: 2,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Speak on Select: ${Bv4rs.audioTileSpeakOnSelect}',
                              onChanged: (value) async {
                                setState(() {
                                  Bv4rs.audioTileSpeakOnSelect = value.toInt();
                                  Bv4rs.saveaudioTileSpeakOnSelect(value.toInt());
                                });
                              },
                            ),
                            ),
                          ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child:
                                Text('Off', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                              ],
                            )
                          ]),
                        )
                        ]
                        ),
                           ExpansionTile(
                        title: Text('Typing Button Speak on Select:', style: Sv4rs.settingslabelStyle),
                        collapsedBackgroundColor: Cv4rs.themeColor4,
                        backgroundColor: Cv4rs.themeColor4,
                        childrenPadding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 20), child:
                        Column(
                          children: [
                            Row(
                          children: [
                            Expanded(
                            child: Slider(
                              value: Bv4rs.typingKeySpeakOnSelect.toDouble(),
                              min: 1.0,
                              max: 3.0,
                              divisions: 2,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Speak on Select: ${Bv4rs.typingKeySpeakOnSelect}',
                              onChanged: (value) async {
                                setState(() {
                                  Bv4rs.typingKeySpeakOnSelect = value.toInt();
                                  Bv4rs.savetypingKeySpeakOnSelect(value.toInt());
                                });
                              },
                            ),
                            ),
                          ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(flex: 1, child:
                                Text('Off', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Label', style: Sv4rs.settingslabelStyle),),
                                Spacer(flex: 3),
                                Expanded( flex: 1, child:
                                Text('Speak Message ', style: Sv4rs.settingslabelStyle),),
                              ],
                            )
                          ]),
                        )
                        ]
                        ),
                      
                        ]
                        ),
                      //symbol settings
                      SymbolColorCustomizer(
                        invert: Bv4rs.buttonSymbolInvert, 
                        overlay: Bv4rs.buttonSymbolColorOverlay, 
                        saturation: Bv4rs.buttonSymbolSaturation, 
                        contrast: Bv4rs.buttonSymbolContrast, 
                        onContrastChanged: (val) { setState(() {
                          Bv4rs.buttonSymbolContrast = val;
                          Bv4rs.savebuttonSymbolContrast(val);
                          });
                        }, 
                        onInvertChanged: (val) { setState(() {
                          Bv4rs.buttonSymbolInvert = val;
                          Bv4rs.savebuttonSymbolInvert(val);
                          });
                        }, 
                        onOverlayChanged: (val) { setState(() {
                          Bv4rs.buttonSymbolColorOverlay = val;
                          Bv4rs.savebuttonSymbolColorOverlay(val);
                          });
                        }, 
                        onSaturationChanged: (val) { setState(() {
                          Bv4rs.buttonSymbolSaturation = val;
                          Bv4rs.savebuttonSymbolSaturation(val);
                          });
                        },
                        tts: widget.synth,
                        ),
                      //corner tab color
                      ColorPickerWithHex(
                        label: 'Corner Tab Color', 
                        color: Cv4rs.cornerTabColor, 
                        onColorChanged:(value) async {
                            setState(() {
                              Cv4rs.cornerTabColor = value;
                              Cv4rs.saveCornerTabColor(value);
                            });
                          },
                         ),
                      //font settings
                      FontPicker1(
                        size: Fv4rs.buttonFontSize, 
                        weight: Fv4rs.buttonFontWeight, 
                        italics: Fv4rs.buttonFontItalics, 
                        useUnderline: true,
                        underline: Fv4rs.buttonFontUnderline,
                        font: Fv4rs.buttonFont, 
                        label: 'Button Font:', 
                        color: Fv4rs.buttonFontColor, 
                        onSizeChanged: (value) {
                          setState(() {
                            Fv4rs.buttonFontSize = value;
                            Fv4rs.savebuttonFontSize(value);
                          });
                        },
                        onWeightChanged: (value) {
                          setState(() {
                            Fv4rs.buttonFontWeight = value;
                            Fv4rs.savebuttonFontWeight(value);
                          });
                        },
                        onItalicsChanged: (value) {
                          setState(() {
                            Fv4rs.buttonFontItalics = value;
                            Fv4rs.savebuttonFontItalics(value);
                          });
                        }, 
                        onFontChanged: (value) {
                          setState(() {
                            Fv4rs.buttonFont = value;
                            Fv4rs.savebuttonFont(value);
                          });
                        },
                        onColorChanged: (value) {
                          setState(() {
                            Fv4rs.buttonFontColor= value.toColor() ?? Fv4rs.buttonFontColor;
                            Fv4rs.savebuttonFontColor(value.toColor() ?? Fv4rs.buttonFontColor);
                          });
                        }, 
                        onUnderlineChanged: (value) {
                          setState(() {
                            Fv4rs.buttonFontUnderline = value;
                            Fv4rs.savebuttonFontUnderline(value);
                          });
                        }, 
                        tts: widget.synth
                        ),
                      
                    ]
                    )
                      
                    //per boardset settings

                      ],
                    ),

                //
                //special gestures
                //

                ExpansionTile(
                  title: Text('Special Gestures:', style: Sv4rs.settingslabelStyle,),
                  collapsedBackgroundColor: Cv4rs.themeColor4,
                  backgroundColor: Cv4rs.themeColor4,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 40),
                  onExpansionChanged: (bool expanded) {  
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        V4rs.speakOnSelect('Special Gestures:', V4rs.selectedLanguage.value, widget.synth);
                      }},
                  children: [
                    Row(
                      children: [
                        Text('Use Swipe Up Shortcut:', style: Sv4rs.settingslabelStyle, ),
                        Spacer(),
                          Switch(
                            value: V4rs.useSwipeUpShortcut,
                            onChanged: (val) { setState(() {
                                V4rs.useSwipeUpShortcut = val;
                                V4rs.saveuseSwipeUpShortcut(val);
                            });
                            },
                          ),
                        ]
                      ),
                    Row(
                      children: [
                        Text('Use Double Tap Instead of Long Tap:', style: Sv4rs.settingslabelStyle, ),
                        Spacer(),
                          Switch(
                            value: V4rs.useLongTapOr,
                            onChanged: (val) { setState(() {
                                V4rs.useLongTapOr = val;
                                V4rs.saveuseLongTapOr(val);
                            });
                            },
                          ),
                        ]
                      ),
                     Row(
                      children: [
                        Text('Long Tap Duration: ${(V4rs.longTapDuration / 1000).toDouble()}', style: Sv4rs.settingslabelStyle, ),
                          Expanded(
                            child: Slider(
                              value: (V4rs.longTapDuration / 1000).toDouble(),
                              min: 0.0,
                              max: 1.0,
                              divisions: 10,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'long tap duration ${V4rs.longTapDuration / 1000}',
                              onChanged: (value) async {
                                setState(() {
                                  V4rs.longTapDuration = (value * 1000).toInt();
                                  V4rs.savelongTapDuration((value * 1000).toInt());
                                });
                              },
                            ),
                            ),
                        ]
                      ),
                      Row(
                      children: [
                        Text('Double Tap Click Speed ${V4rs.doubleTapClickSpeed / 1000}', style: Sv4rs.settingslabelStyle, ),
                          Expanded(
                            child: Slider(
                              value: (V4rs.doubleTapClickSpeed / 1000).toDouble(),
                              min: 0.0,
                              max: 1.0,
                              divisions: 10,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'double tap click speed ${V4rs.doubleTapClickSpeed / 1000}',
                              onChanged: (value) async {
                                setState(() {
                                  V4rs.doubleTapClickSpeed = (value * 1000).toInt();
                                  V4rs.savedoubleTapClickSpeed((value * 1000).toInt());
                                });
                              },
                            ),
                            ),
                        ]
                      ),
                         
                    ]
                ),

                SizedBox(height: 25,),

                //open welcome screen
                Divider(),
                OpenWelcomeScreen(synth: widget.synth),

                SizedBox(height: 250,),
              ]
            )
          ),
          ],
        ),
        ),
      ),
    );
       },
    );
  }
  );
  }
}