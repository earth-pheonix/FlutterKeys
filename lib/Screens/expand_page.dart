import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutter/services.dart';
import 'package:flutterkeysaac/Variables/more_font_variables.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/tts/tts_factory.dart';
import 'package:flutterkeysaac/Variables/settings_variable.dart';




class ExpandPage extends StatefulWidget {
  const ExpandPage({super.key});

  @override
  State<ExpandPage> createState() => _ExpandPage();
}

class _ExpandPage extends State<ExpandPage> with WidgetsBindingObserver {
 late final TextEditingController _controller;
 
  TTSInterface? synth;
  bool synthInitialized = false;

 bool _isFlipped = false; 

  @override
  void initState() {
    initSynth();
    super.initState();
    _controller = TextEditingController(text:  V4rs.message.value);

    _controller.addListener(() {
      setState(() {
         V4rs.message.value = _controller.text;
      });
    });
  }

  Future<void> initSynth() async {
    synth = await TTSFactory.getTTS(
      languageCode: V4rs.selectedLanguage.value);
      setState(() {
        synthInitialized = true;
      });
  }

  @override
  void dispose() {
     V4rs.message.value = _controller.text; // Save the message before disposing
    _controller.dispose();
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cv4rs.expandColor2,
      body: SafeArea(
        bottom: false, // Ignore keyboard
        child: Padding (
          padding: const EdgeInsets.all(5.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              var totalHeight = constraints.maxHeight;
              var totalWidth = constraints.maxWidth;

              return Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // Expanded Message Window
                Expanded(
                  flex: 15,
                  child: Padding ( 
                    padding: const EdgeInsets.all(5.0),
                    child: Stack(
                      children: [ 
                        Container(
                            decoration: BoxDecoration(
                              color: Cv4rs.expandColor4,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: _isFlipped 
                                  ? Matrix4.rotationZ(3.1415)// 180 degrees in radians
                                  : Matrix4.identity(),
                              child: TextField(
                                controller: _controller,
                                minLines: 12,
                                maxLines: null,
                                style: Fv4rs.expandedLabelStyle,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Cv4rs.expandColor3),
                                    hintText: 'Message Window...',
                                    contentPadding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                                  ),
                                  textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          if (!_isFlipped) 
                          Positioned(
                          top: 0,
                          right: 0,
                          child: SizedBox (
                            height: totalHeight *  0.06,
                            width: totalWidth * 0.09,
                            child:
                              ExpandButtonStyle(
                                imagePath: 'assets/interface_icons/interface_icons/iClear.png',
                                onPressed: () {
                                   if (Sv4rs.speakInterfaceButtonsOnSelect) {
                                    V4rs.speakOnSelect('clear', V4rs.selectedLanguage.value, synth!);
                                    }
                                  _controller.clear();
                                },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
                Expanded(
                  flex: 2,
                  child: Padding(padding: const EdgeInsets.all(5.0),
                  child: Row( 
                    children: [
                      //back button 
                    SizedBox(
                        height: totalHeight *  0.09,
                        width: totalWidth * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ExpandButtonStyle(
                            imagePath: 'assets/interface_icons/interface_icons/iBack.png',
                            onPressed: () {
                              if (Sv4rs.speakInterfaceButtonsOnSelect) {
                                    V4rs.speakOnSelect('back', V4rs.selectedLanguage.value, synth!);
                                    }
                              V4rs.showExpandPage.value = false;
                            },
                          ),
                        ),
                    ),
                    //slider for font size
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                         overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: Fv4rs.expandedFontSize,
                          min: 20.0,
                          max: 150.0,
                          activeColor: Cv4rs.expandColor4,
                          inactiveColor: Cv4rs.expandColor1,
                          thumbColor: Cv4rs.expandColor4, 
                          label: 'Font Size: ${Fv4rs.expandedFontSize.round()}',
                          onChangeEnd: (value) {
                             if (Sv4rs.speakInterfaceButtonsOnSelect) {
                              V4rs.speakOnSelect('font size ${Fv4rs.expandedFontSize.round()}', V4rs.selectedLanguage.value, synth!);
                            }
                          },
                          onChanged: (value)  {
                            setState(() {
                              Fv4rs.expandedFontSize = value;
                            });
                          },
                        ),
                        ),
                    ),
                    //copy text button
                    SizedBox(
                        height: totalHeight *  0.09,
                        width: totalWidth * 0.09,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ExpandButtonStyle(
                            imagePath: 'assets/interface_icons/interface_icons/iCopy.png',
                            onPressed: () {
                              if (Sv4rs.speakInterfaceButtonsOnSelect) {
                                    V4rs.speakOnSelect('copy', V4rs.selectedLanguage.value, synth!);
                                    }
                              Clipboard.setData(ClipboardData(text: _controller.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Text copied to clipboard'), 
                                  duration: Duration(milliseconds: 750),
                                  ),
                              );
                            },
                          ),
                        ),
                    ),
                    //flip text button
                    SizedBox(
                        height: totalHeight *  0.1,
                        width: totalWidth * 0.09,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ExpandButtonStyle(
                            imagePath: 'assets/interface_icons/interface_icons/iFlip.png',
                            onPressed: () {
                              setState(() {
                                if (Sv4rs.speakInterfaceButtonsOnSelect) {
                                    V4rs.speakOnSelect('flip', V4rs.selectedLanguage.value, synth!);
                                    }
                                _isFlipped = !_isFlipped;
                              });
                            },
                          ),
                        ),
                    ),
                  ],
                    ),

                  ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}