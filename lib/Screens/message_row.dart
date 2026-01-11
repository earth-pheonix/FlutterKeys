
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutter/services.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/search_variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_boards.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart'; 
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'package:flutterkeysaac/Variables/highlight_message_window.dart';

class MessageRow extends StatefulWidget {
  final TTSInterface synth;
  final int? highlightStart;
  final int? highlightLength;
  final Root? root;
  final Map<String, sherpa_onnx.OfflineTts?>? sherpaOnnxSynth;
  final Future<void> Function() init;
  final AudioPlayer player;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const MessageRow({
    super.key, 
    required this.synth,
    required this.root,
    this.highlightStart,
    this.highlightLength,
    required this.sherpaOnnxSynth,
    required this.init,
    required this.player,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });

  @override
  State<MessageRow> createState() => _MessageRowState();

}

class _MessageRowState extends State<MessageRow> {
  late final TextEditingController _controller;
  
  final List<TextEditingValue> _undoStack = [];
  final List<TextEditingValue> _redoStack = [];
  
  bool _internalChange = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: V4rs.message.value);
    _undoStack.add(_controller.value);
    _controller.addListener(() {
       if (_internalChange) return; 
        
        _undoStack.add(_controller.value);
        _redoStack.clear(); // Clear redo stack on new change
        
        if (_undoStack.length > 100) {
        _undoStack.removeAt(0);
        }

      setState(() {
         V4rs.message.value = _controller.text;
      });
    });
  }

  @override
  void dispose() {
     V4rs.message.value = _controller.text; // Save the message before disposing
    _controller.dispose();
    super.dispose();
  }

  // undo redo functions
  void _undo() {
    if (_undoStack.length < 2) return;

    _internalChange = true;
    _redoStack.add(_controller.value);
    _undoStack.removeLast(); // Discard current
    _controller.value = _undoStack.last;
    _internalChange = false;

    V4rs.message.value = _controller.text;
  }

  void _redo() {
    if (_redoStack.isEmpty) return;

    _internalChange = true;
    final value = _redoStack.removeLast();
    _undoStack.add(value);
    _controller.value = value;
    _internalChange = false;

    V4rs.message.value = _controller.text;
  }

 @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
          
        //message window and right of message window
        final children = <Widget> [
          Expanded(
              flex: V4rs.xSmallModeWidth ? 8 : 10,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  8, 
                  V4rs.xSmallModeWidth ? 2 : 8, 
                  V4rs.xSmallModeWidth ? 5 : 8, 
                  8
                ),
                child: Container(
                  decoration: BoxDecoration(
                  color: Cv4rs.themeColor4,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                  child: MessageWindow(
                    controller: _controller,
                    synth: widget.synth,
                    highlightLength: widget.highlightLength,
                    highlightStart: widget.highlightStart,
                    sherpaOnnxSynth: widget.sherpaOnnxSynth,
                    init: widget.init,
                    player: widget.player,
                    speakSelectSherpaOnnxSynth: widget.speakSelectSherpaOnnxSynth,
                    initForSS: widget.initForSS,
                    playerForSS: widget.playerForSS,
                  ),
              ),
              ),
            ),
          Expanded (
            flex: V4rs.xSmallModeWidth ? 5 : 3,
            child: ValueListenableBuilder(
              valueListenable: SeV4rs.openSearch, 
              builder: (context, openSearch, _) {
                return (openSearch && (widget.root != null)) 
                  ? SearchDisplay(root: widget.root) 
                  : RightOfMessageWindow(
                    controller: _controller,
                    onUndo: _undo,
                    onRedo: _redo,
                    synth: widget.synth,
                    sherpaOnnxSynth: widget.sherpaOnnxSynth,
                    init: widget.init,
                    player: widget.player,
                    speakSelectSherpaOnnxSynth: widget.speakSelectSherpaOnnxSynth,
                    initForSS: widget.initForSS,
                    playerForSS: widget.playerForSS,
                  );
                }
            )
        ),
        ];
        
        return Flex(
          direction: V4rs.xSmallModeWidth ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
            flex: V4rs.xSmallModeWidth ? 3 : 2,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: V4rs.xSmallModeWidth ? 0 : 5),
              child: LeftOfMessageWindow(
                controller: _controller,
                synth: widget.synth, 
                speakSelectSherpaOnnxSynth: widget.speakSelectSherpaOnnxSynth,
                initForSS: widget.initForSS,
                playerForSS: widget.playerForSS,
              ),
            ),
          ),
          Expanded(flex: V4rs.xSmallModeWidth ? 10 : 13, child: Row(children: children,))
          ],
        );
      },
    );
  }
}

class LeftOfMessageWindow extends StatefulWidget {
  final TextEditingController controller;
  final TTSInterface synth;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const LeftOfMessageWindow({
    super.key, 
    required this.controller, 
    required this.synth,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });

  @override
  State<LeftOfMessageWindow> createState() => _LeftOfMessageWindow();

}

class _LeftOfMessageWindow extends State<LeftOfMessageWindow> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder ( 
      builder: (context, constraints) { 
        var totalHeight = constraints.maxHeight;
        var totalWidth = constraints.maxWidth;
        final children = <Widget>[
          //settings and expand button
            Row( 
                children: [
                  SizedBox(
                    height: totalHeight * (V4rs.xSmallModeWidth ? 0.8 : 0.33),
                    width: totalWidth * (V4rs.xSmallModeWidth ? 0.15 : 0.5),
                    child: Padding (
                  padding: EdgeInsets.symmetric(
                      horizontal: 3, 
                      vertical: V4rs.xSmallModeWidth ? 0 : V4rs.paddingValue(3),
                    ),
                  child: ButtonStyle1(
                    padding: V4rs.xSmallModeHeight ? 15 : 5,
                    imagePath: 'assets/interface_icons/interface_icons/iSettings.png',
                    onPressed: () {
                      if (Sv4rs.speakInterfaceButtonsOnSelect) {
                            V4rs.speakOnSelect(
                              'settings', 
                              V4rs.selectedLanguage.value, 
                              widget.synth,
                              widget.speakSelectSherpaOnnxSynth,
                              widget.initForSS,
                              widget.playerForSS,
                              );
                            }
                      V4rs.showSettings.value = true;
                    },
                  ),
                  ),
                  ),
                  SizedBox(
                    height: totalHeight * (V4rs.xSmallModeWidth ? 0.8 : 0.33),
                    width: totalWidth * (V4rs.xSmallModeWidth ? 0.15 : 0.5),
                    child: Padding (
                    padding: EdgeInsets.symmetric(
                      horizontal: 3, 
                      vertical: V4rs.xSmallModeWidth ? 0 : V4rs.paddingValue(3),
                    ),
                    child: ButtonStyle1(
                    padding: V4rs.xSmallModeHeight ? 15 : 5,
                    imagePath: 'assets/interface_icons/interface_icons/iExpand.png',
                    onPressed: () {
                      if (Sv4rs.speakInterfaceButtonsOnSelect) {
                            V4rs.speakOnSelect(
                              'expand page', 
                              V4rs.selectedLanguage.value, 
                              widget.synth,
                              widget.speakSelectSherpaOnnxSynth,
                              widget.initForSS,
                              widget.playerForSS,
                          );
                        }
                      V4rs.showExpandPage.value = true;
                    },
                  ),
                  ),
                  ),
                ],
              ),
            if (V4rs.xSmallMode) 
            Spacer(),
          //copy and bookmark button 
            Row( 
              children: [
                SizedBox( 
                  height: totalHeight * (V4rs.xSmallModeWidth ? 0.8 : 0.33),
                    width: totalWidth * (V4rs.xSmallModeWidth ? 0.15 : 0.5),
                child: Padding (
                padding: EdgeInsets.symmetric(
                      horizontal: 3, 
                      vertical: V4rs.xSmallModeWidth ? 0 : V4rs.paddingValue(3),
                    ),
                child: ButtonStyle1(
                  padding: V4rs.xSmallModeHeight ? 15 : 5,
                  imagePath: 'assets/interface_icons/interface_icons/iCopy.png',
                  onPressed: () {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                          V4rs.speakOnSelect(
                            'copy', 
                            V4rs.selectedLanguage.value, 
                            widget.synth,
                            widget.speakSelectSherpaOnnxSynth,
                            widget.initForSS,
                            widget.playerForSS,
                          );
                        }
                      Clipboard.setData(ClipboardData(text: widget.controller.text));
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
                SizedBox(
                  height: totalHeight * (V4rs.xSmallModeWidth ? 0.8 : 0.33),
                    width: totalWidth * (V4rs.xSmallModeWidth ? 0.15 : 0.5),
                child: Padding (
                padding: EdgeInsets.symmetric(
                      horizontal: 3, 
                      vertical: V4rs.xSmallModeWidth ? 0 : V4rs.paddingValue(3),
                    ),
                child: ButtonStyle1(
                  padding: V4rs.xSmallModeHeight ? 15 : 5,
                  imagePath: 'assets/interface_icons/interface_icons/iBookmark.png',
                  onPressed: () {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                          V4rs.speakOnSelect(
                            'bookmark', 
                            V4rs.selectedLanguage.value, 
                            widget.synth,
                            widget.speakSelectSherpaOnnxSynth,
                            widget.initForSS,
                            widget.playerForSS,
                            );
                          }
                    // put action here
                  },
                ),
                ),
                ),
              ],
            ),
            if (V4rs.xSmallMode) 
            Spacer(),
          //boardset button 
            SizedBox(
              height: totalHeight * (V4rs.xSmallModeWidth ? 0.8 : 0.33),
              width: totalWidth * (V4rs.xSmallModeWidth ? 0.15 : 0.5),
              child: Padding (
                padding: EdgeInsets.symmetric(
                      horizontal: 3, 
                      vertical: V4rs.xSmallModeWidth ? 0 : V4rs.paddingValue(3),
                    ),
                child: ButtonStyle1(
                  padding: V4rs.xSmallModeHeight ? 15 : 5,
                  imagePath: 'assets/interface_icons/interface_icons/iBoardset.png',
                  onPressed: () {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                      V4rs.speakOnSelect(
                        'quick swap', 
                        V4rs.selectedLanguage.value, 
                        widget.synth,
                        widget.speakSelectSherpaOnnxSynth,
                        widget.initForSS,
                        widget.playerForSS,
                      );
                    }
                    // put action here
                  },
                ),
                ),
          ),
        ];

      if (V4rs.xSmallModeWidth) {
        return Row (
          mainAxisAlignment: MainAxisAlignment.center,
          children: children
        );
      } else {
        return Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: children
        );
      }
      },
    );
  }
}

class MessageWindow extends StatefulWidget {
  final TextEditingController controller;
  final TTSInterface synth;
  final int? highlightStart;
  final int? highlightLength;
  final Map<String, sherpa_onnx.OfflineTts?>? sherpaOnnxSynth;
  final Future<void> Function() init;
  final AudioPlayer player;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;
      
  const MessageWindow({
    super.key, 
    required this.controller, 
    required this.synth,
    this.highlightLength,
    this.highlightStart,
    required this.sherpaOnnxSynth,
    required this.init,
    required this.player,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });

  @override
  State<MessageWindow> createState() => _MessageWindowState();
}

class _MessageWindowState extends State<MessageWindow> {
  int currentLanguageIndex = 0;

  late final ScrollController _scrollController;

  late final VoidCallback _clearListener;
  late final VoidCallback _mwChange;

    @override
    void initState() {
      super.initState();

      // Listen for clear requests
      _clearListener = () {
        if (V4rs.message.value == "") {
          widget.controller.clear();
          V4rs.wasPaused.value = false;
          if (mounted) setState(() {}); // reset notifier
        }
      };
      V4rs.message.addListener(_clearListener);

      //listen for changes in message generally
      _mwChange = () {
        final oldValue = widget.controller.value;
        final oldSelection = widget.controller.selection;
        final newText = V4rs.message.value;

        if (oldValue.text == newText) return;
        
        widget.controller.value = TextEditingValue(
          text: newText,
          selection: oldSelection, // preserve cursor
          composing: oldValue.composing, //preserve chinese typing
        );
        
        if (V4rs.changedMWfromButton) {
        _scrollToBottom();
        }

        if (mounted) setState(() {}); 
      };
      V4rs.message.addListener(_mwChange);

      //stuff for languages 
      final savedLanguage = V4rs.selectedLanguage.value;
      final languagesList = Sv4rs.myLanguages.toList();
      final index = languagesList.indexOf(savedLanguage);

      if (index != -1) {
        currentLanguageIndex = index;
      } else {
        currentLanguageIndex = 0;
      }
      

      //scrolling 
      _scrollController = ScrollController();
    }

    //remove clear after speak listener
    @override
    void dispose() {
      _scrollController.dispose();
      V4rs.message.removeListener(_mwChange);
      V4rs.message.removeListener(_clearListener);
      super.dispose();
    }

  //var for language functions
  String get localCurrentLanguage => Sv4rs.myLanguages.elementAt(currentLanguageIndex);
 
  //scrolling 
  void _scrollOneLineDown() {
    final double lineHeight = Fv4rs.mwFontSize * 2;

    _scrollController.animateTo(_scrollController.offset + lineHeight, 
    duration: Duration(milliseconds: 300), 
    curve: Curves.easeOut,
    );
  }

  void _scrollOneLineUp() {
    final double lineHeight = Fv4rs.mwFontSize * 2;

    _scrollController.animateTo(_scrollController.offset - lineHeight, 
    duration: Duration(milliseconds: 300), 
    curve: Curves.easeOut,
    );
  }

  void _scrollToBottom() {
  _scrollController.animateTo(
    _scrollController.position.maxScrollExtent,
    duration: Duration(milliseconds: 300), 
    curve: Curves.easeOut,
  );
}


//UI starts
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Message window
            Expanded(
              flex: 20,
              child: Padding(
                padding: EdgeInsets.fromLTRB(V4rs.paddingValue(8), 0, 0, 0),
                child: Stack(
                  children: [
                    ValueListenableBuilder<bool>(
                  valueListenable: V4rs.theIsSpeaking,
                  builder: (context, isSpeaking, _) {
                     return isSpeaking
                          ? Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: HV4rs.highlightAsSpoken 
                                ? V4rs.paddingValue(8) 
                                : V4rs.paddingValue(10)
                              ),
                               child:
                               SizedBox( child: 
                            HV4rs.highlightAsSpoken ? 
                                 HV4rs.highlightedTextWidget(context, widget.controller, _scrollController)
                            : SizedBox(child:
                            SingleChildScrollView( child:
                            Text(V4rs.message.value, style: Fv4rs.mwLabelStyle,) ))
                          )
                          )
                          )
                           : 
                    Positioned.fill(
                      child: SizedBox( 
                      child: MessageWindowTextField(
                        controller: widget.controller, 
                        scrollController: _scrollController,
                        ),
                      )
                      );
                    },
                      ),
                    
                    //
                    // scroll buttons
                    //
                   
                    Positioned(
                      right: V4rs.xSmallMode ? 2 : 0,
                      bottom: V4rs.xSmallMode ? 2 : 0,
                      child: 
                     Visibility(
                      visible: V4rs.showScrollButtons,
                      child: Container( 
                        height: V4rs.xSmallMode ? 27 : 37,
                        width: V4rs.xSmallMode ? 40 : 50,
                        padding: EdgeInsets.all(V4rs.paddingValue(5)),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Cv4rs.themeColor3,
                            padding: EdgeInsets.all(V4rs.paddingValue(2)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _scrollOneLineDown,
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Cv4rs.uiIconColor,
                              BlendMode.srcIn,
                            ),
                            child: Image.asset("assets/interface_icons/interface_icons/iArrow.png"),
                          ),
                        ),
                      ),
                    ),
                    ),
                    
                    Positioned(
                      right: V4rs.xSmallModeWidth ? 2 : 0,
                      bottom: V4rs.xSmallMode ? 32 : 37,
                      child: 
                    Visibility(
                      visible: V4rs.showScrollButtons,
                      child:   
                      Container( 
                        height: V4rs.xSmallMode ? 27 : 37,
                        width: V4rs.xSmallMode ? 40 : 50,
                        padding: EdgeInsets.all(V4rs.paddingValue(5)),
                        child:
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Cv4rs.themeColor3,
                          padding: EdgeInsets.all(V4rs.paddingValue(2)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _scrollOneLineUp,
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Cv4rs.uiIconColor,
                            BlendMode.srcIn,
                          ),
                          child: RotatedBox(quarterTurns: 2, child:
                          Image.asset("assets/interface_icons/interface_icons/iArrow.png"),
                        ),
                        ),
                      ),
                      ),
                    ),
                    ),
                    //
                    //language selector slider
                    //
                    if (Sv4rs.myLanguages.length != 1)
                    Positioned(
                      right: V4rs.showScrollButtons ? (V4rs.xSmallMode ? 45 : 50) : 0,
                      bottom: V4rs.xSmallMode ? 2 : 0,
                      child: 
                     Visibility(
                      visible: V4rs.showLanguageSelectorSlider,
                      child:  
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child:
                      languageSelectorSlider(),
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Alerts
            if (Sv4rs.alertCount > 0)
            Expanded(
              flex: V4rs.xSmallModeWidth ? 5 : 2,
              child: Alerts(
                tts: widget.synth,
                sherpaOnnxSynth: widget.sherpaOnnxSynth,
                init: widget.init,
                player: widget.player,
                speakSelectSherpaOnnxSynth: widget.speakSelectSherpaOnnxSynth,
                initForSS: widget.initForSS,
                playerForSS: widget.playerForSS,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget languageSelectorSlider() {
  final languages = Sv4rs.myLanguages.toList();
  
  final double sliderWidth = languages.length * (V4rs.xSmallModeWidth ? 30 : 40.0);

  return Padding(padding: EdgeInsets.symmetric(
    horizontal: V4rs.paddingValue(10), 
    vertical: V4rs.paddingValue(3)
  ),
  child: Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      //slider
      Padding(padding: EdgeInsets.symmetric(
        horizontal: V4rs.paddingValue(4), 
        vertical: V4rs.paddingValue(4)
      ),
      child: 
      SizedBox(
        width: sliderWidth, 
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Cv4rs.themeColor3,
            inactiveTrackColor: Cv4rs.themeColor3,
            overlayShape: SliderComponentShape.noOverlay,
            thumbColor: Cv4rs.themeColor3,
          ),
          child: Slider(
            min: 0,
            max: (languages.length - 1).toDouble(),
            divisions: languages.length == 1 ? 1 : languages.length - 1,
            value: currentLanguageIndex.toDouble(),
            onChanged: (value) async {
               currentLanguageIndex = value.round();
                if (Sv4rs.speakInterfaceButtonsOnSelect) {
                  V4rs.speakOnSelect(
                    'selected language set to ${V4rs.languageToLocalePrefix_(localCurrentLanguage).toUpperCase()}', 
                    V4rs.selectedLanguage.value, 
                    widget.synth,
                    widget.speakSelectSherpaOnnxSynth,
                    widget.initForSS,
                    widget.playerForSS,
                    );
                  }
              setState(() {
                V4rs.selectedLanguage.value = localCurrentLanguage;
              });
              await V4rs.saveSelectedLang(localCurrentLanguage);
            },
          ),
        ),
      ),
      ),
      Container(
        width: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Cv4rs.themeColor3,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          V4rs.languageToLocalePrefix_(localCurrentLanguage).toUpperCase(),
          style: TextStyle(
            color: Cv4rs.themeColor4,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    ],
  ),
  );
}
}

class Alerts extends StatelessWidget {
  final TTSInterface tts;
  final Map<String, sherpa_onnx.OfflineTts?>? sherpaOnnxSynth;
  final Future<void> Function() init;
  final AudioPlayer player;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;
  
  const Alerts ({
    super.key, 
    required this.tts,
    required this.sherpaOnnxSynth,
    required this.init,
    required this.player,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder ( 
       builder: (context, constraints) { 

      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (Sv4rs.alertCount >= 1)
          Expanded(
            child: AlertStyle(
                  imagePath: 'assets/interface_icons/interface_icons/iAlertC.png',
                  invertColors: true,
                  onPressed: () async {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                      await Future.delayed(const Duration(milliseconds: 100));
                      await V4rs.speakOnSelect(
                        'first alert', 
                        V4rs.selectedLanguage.value, 
                        tts,
                        speakSelectSherpaOnnxSynth,
                        initForSS,
                        playerForSS,
                        );
                      await Future.delayed(const Duration(milliseconds: 100));
                      await V4rs.mwSpeakWithSSRestore(
                        Sv4rs.firstAlert, V4rs.selectedLanguage.toString(), 
                        tts,
                        sherpaOnnxSynth,
                        init,
                        player
                      );
                      } else {
                      await V4rs.messageWindowSpeak(
                        Sv4rs.firstAlert, 
                        V4rs.selectedLanguage.toString(), 
                        tts,
                        sherpaOnnxSynth,
                        init,
                        player
                        );
                      }
                  },
                ),
          ),
          if (Sv4rs.alertCount >= 2)
          Expanded(
            child: AlertStyle(
                  imagePath: 'assets/interface_icons/interface_icons/iAlertS.png',
                  invertColors: true,
                  onPressed: () async {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                      await V4rs.speakOnSelect(
                        'second alert', 
                        V4rs.selectedLanguage.value, 
                        tts,
                        speakSelectSherpaOnnxSynth,
                        initForSS,
                        playerForSS,
                      );
                      await V4rs.mwSpeakWithSSRestore(
                        Sv4rs.secondAlert, 
                        V4rs.selectedLanguage.toString(), 
                        tts,
                        sherpaOnnxSynth,
                        init,
                        player
                        );
                      } else {
                    await V4rs.messageWindowSpeak(
                      Sv4rs.secondAlert, 
                      V4rs.selectedLanguage.toString(), 
                      tts,
                      sherpaOnnxSynth,
                      init,
                      player
                     );
                    }
                  },
                ),
          ),
          if (Sv4rs.alertCount >= 3)
          Expanded(
            child: AlertStyle(
                  imagePath: 'assets/interface_icons/interface_icons/iAlertT.png',
                  invertColors: true,
                  onPressed: () async {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                        await V4rs.speakOnSelect(
                          'third alert', 
                          V4rs.selectedLanguage.value, 
                          tts,
                          speakSelectSherpaOnnxSynth,
                          initForSS,
                          playerForSS,
                        );
                        await V4rs.mwSpeakWithSSRestore(
                          Sv4rs.thirdAlert, 
                          V4rs.selectedLanguage.toString(), 
                          tts,
                          sherpaOnnxSynth,
                          init,
                          player
                        );
                      } else {
                     await V4rs.messageWindowSpeak(
                      Sv4rs.thirdAlert, 
                      V4rs.selectedLanguage.toString(), 
                      tts,
                      sherpaOnnxSynth,
                      init,
                      player
                     );
                    }
                  },
                ),
          ),
          ],
        );
      },
    );
  }
}

class RightOfMessageWindow extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final TTSInterface synth;
  final Map<String, sherpa_onnx.OfflineTts?>? sherpaOnnxSynth;
  final Future<void> Function() init;
  final AudioPlayer player;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const RightOfMessageWindow({
    super.key, 
    required this.controller, 
    required this.onUndo,
    required this.onRedo,
    required this.synth,
    required this.sherpaOnnxSynth,
    required this.init,
    required this.player,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
    });

  @override
  State<RightOfMessageWindow> createState() => _RightOfMessageWindowState();
}

class _RightOfMessageWindowState extends State<RightOfMessageWindow> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder ( 
       builder: (context, constraints) { 

        var totalHeight = constraints.maxHeight;
        var totalWidth = constraints.maxWidth;

      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //undo, play, pause, redo
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, V4rs.paddingValue(5)),
            child: 
          Row( 
           children: [
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.33,
                child: Padding (
                  padding: EdgeInsets.all(V4rs.paddingValue(3)),
                    child: ButtonStyle1(
                      padding: V4rs.xSmallMode ? 15 : 5,
                      imagePath: 'assets/interface_icons/interface_icons/iUndo.png',
                      onPressed: () {
                        if (Sv4rs.speakInterfaceButtonsOnSelect) {
                          V4rs.speakOnSelect(
                            'undo', 
                            V4rs.selectedLanguage.value, 
                            widget.synth,
                            widget.speakSelectSherpaOnnxSynth,
                            widget.initForSS,
                            widget.playerForSS,
                           );
                          }
                        widget.onUndo();
                      },
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: V4rs.theIsSpeaking,
                  builder: (context, isSpeaking, _) {
                  
                    return isSpeaking
                          ? SizedBox(
                            height: totalHeight * 0.35,
                            width: totalWidth * 0.33,
                            child:  Padding (
                            padding: EdgeInsets.all(V4rs.paddingValue(3)),
                            child: ButtonStyle1(
                              padding: V4rs.xSmallMode ? 15 : 5,
                              imagePath: 'assets/interface_icons/interface_icons/iPause.png',
                              onPressed: () 
                                async {
                                  if (Sv4rs.speakInterfaceButtonsOnSelect) {
                                    await widget.synth.stop();
                                    V4rs.speakOnSelect(
                                      'pause', 
                                      V4rs.selectedLanguage.value, 
                                      widget.synth,
                                      widget.speakSelectSherpaOnnxSynth,
                                      widget.initForSS,
                                      widget.playerForSS,
                                    );
                                    } else {
                                      await widget.synth.pause();
                                      V4rs.wasPaused.value = true;
                                    }
                                },
                              ),
                            ),
                          ) 
                        : SizedBox(
                            height: totalHeight * 0.35,
                            width: totalWidth * 0.33,
                            child:  Padding (
                            padding: EdgeInsets.all(V4rs.paddingValue(3)),
                            child: ButtonStyle1(
                              padding: V4rs.xSmallMode ? 15 : 5,
                              imagePath: 'assets/interface_icons/interface_icons/iPlay.png',
                              onPressed: () 
                                async {
                                  if (Sv4rs.speakInterfaceButtonsOnSelect) {
                                    await V4rs.speakOnSelect(
                                      'play', 
                                      V4rs.selectedLanguage.value, 
                                      widget.synth,
                                      widget.speakSelectSherpaOnnxSynth,
                                      widget.initForSS,
                                      widget.playerForSS,
                                    );
                                    await V4rs.mwSpeakWithSSRestore(
                                      V4rs.message.value, 
                                      V4rs.selectedLanguage.value, 
                                      widget.synth,
                                      widget.sherpaOnnxSynth,
                                      widget.init,
                                      widget.player
                                    );
                                    } else {
                                  await V4rs.messageWindowSpeak(
                                    V4rs.message.value, 
                                    V4rs.selectedLanguage.value, 
                                    widget.synth,
                                    widget.sherpaOnnxSynth,
                                    widget.init,
                                    widget.player
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
        
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.33,
                child:  Padding (
                padding: EdgeInsets.all(V4rs.paddingValue(3)),
                child: ButtonStyle1(
                  padding: V4rs.xSmallMode ? 15 : 5,
                  imagePath: 'assets/interface_icons/interface_icons/iRe-do.png',
                  onPressed: () {
                    if (Sv4rs.speakInterfaceButtonsOnSelect) {
                      V4rs.speakOnSelect(
                        'redo', 
                        V4rs.selectedLanguage.value, 
                        widget.synth,
                        widget.speakSelectSherpaOnnxSynth,
                        widget.initForSS,
                        widget.playerForSS,
                      );
                    }
                    widget.onRedo();
                  },
                ),
                ),
              ),
            ],
          ),
          ),
            //rewind, search, and clear button 
            Row( 
              children: [
                SizedBox(
                  height: totalHeight * 0.35,
                  width: totalWidth * 0.3,
                  child: Padding (
                      padding: EdgeInsets.all(V4rs.paddingValue(3)),
                      child: ButtonStyle1(
                        padding: V4rs.xSmallMode ? 15 : 5,
                        imagePath: 'assets/interface_icons/interface_icons/iRewind.png',
                        onPressed: () async {
                         
                            await widget.synth.stop();
                            V4rs.currentSpeakingFile = null;
                          
                          if (Sv4rs.speakInterfaceButtonsOnSelect) {
                            await V4rs.speakOnSelect(
                              'rewind', 
                              V4rs.selectedLanguage.value, 
                              widget.synth,
                              widget.speakSelectSherpaOnnxSynth,
                              widget.initForSS,
                              widget.playerForSS,
                            );
                            await V4rs.mwSpeakWithSSRestore(
                              V4rs.message.value, 
                              V4rs.selectedLanguage.value, 
                              widget.synth,
                              widget.sherpaOnnxSynth,
                              widget.init,
                              widget.player
                            );
                          } else {
                          await V4rs.messageWindowSpeak( 
                            V4rs.message.value, 
                            V4rs.selectedLanguage.value, 
                            widget.synth,
                            widget.sherpaOnnxSynth,
                            widget.init,
                            widget.player
                            );
                          }
                        },
                      ),
                      ),
                      ),
                SizedBox(
                  height: totalHeight * 0.35,
                  width: totalWidth * 0.3,
                  child: Padding (
                    padding: EdgeInsets.all(V4rs.paddingValue(3)),
                    child: ButtonStyle1(
                      padding: V4rs.xSmallMode ? 15 : 5,
                      imagePath: 'assets/interface_icons/interface_icons/iSearch.png',
                      onPressed: () { setState((){
                        if (Sv4rs.speakInterfaceButtonsOnSelect) {
                          V4rs.speakOnSelect(
                            'search', 
                            V4rs.selectedLanguage.value, 
                            widget.synth,
                            widget.speakSelectSherpaOnnxSynth,
                            widget.initForSS,
                            widget.playerForSS,
                            );
                          }
                          SeV4rs.openSearch.value = true;
                          SeV4rs.findAndPick.value = false;
                        // put action here
                      });
                      },
                    ),
                    ),
               ),
               SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.4,
                child: Padding (
                  padding: EdgeInsets.all(V4rs.paddingValue(2)),
                  child: ButtonStyle1(
                    padding: V4rs.xSmallMode ? 15 : 5,
                    imagePath: 'assets/interface_icons/interface_icons/iClear.png',
                    onPressed: () {
                      if (Sv4rs.speakInterfaceButtonsOnSelect) {
                          V4rs.speakOnSelect(
                            'clear', 
                            V4rs.selectedLanguage.value, 
                            widget.synth,
                            widget.speakSelectSherpaOnnxSynth,
                            widget.initForSS,
                            widget.playerForSS,
                            );
                          }
                      widget.controller.clear();
                    },
                  ),
                ),
               ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class SearchDisplay extends StatefulWidget {
  final Root? root;

  const SearchDisplay({
    super.key, 
    required this.root,
    });

  @override
  State<SearchDisplay> createState() => _SearchDisplay();
}

class _SearchDisplay extends State<SearchDisplay> {

  int searchIndex = 0;
  List<BoardObjects?> foundObjects = [];
  List<Widget> indexedChildren = [];
  

  void updateFoundObjects(List<BoardObjects?> objects) {
    foundObjects = objects;
    indexedChildren = foundObjects.map((obj) {
      return (obj != null) ? SizedBox.expand(child: PreveiwButton(obj: obj)) : SizedBox();
    }).toList();
    searchIndex = 0;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
          ValueListenableBuilder<bool>(valueListenable: SeV4rs.findAndPick, builder: (context, findAndPick, _) {
            return (findAndPick) 
              ? pickButton()
              : startSearch();
           }
          );
  }

  Widget startSearch(){
    return LayoutBuilder ( 
       builder: (context, constraints) { 

        var totalHeight = constraints.maxHeight;
        var totalWidth = constraints.maxWidth;

      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //search box
          Padding(
            padding: EdgeInsets.fromLTRB(
              V4rs.paddingValue(3), 
              V4rs.paddingValue(3), 
              V4rs.paddingValue(3), 
              V4rs.paddingValue(8)
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Cv4rs.themeColor4,
                borderRadius: BorderRadius.circular(10)
                ),
              child: SizedBox(
                height: totalHeight * 0.35,
                child: TextField(
                  style: Fv4rs.mwLabelStyle,
                  onChanged: (value){
                    SeV4rs.searchFor = value;
                    },
                  decoration: InputDecoration(
                    hintStyle: Fv4rs.mwLabelStyle.copyWith(
                      color: Cv4rs.themeColor2
                    ),
                    hintText: 'Search:',
                  ),
                )
              )
            ),
          ),
          
          //close and check 
          Row( 
            children: [
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.3,
                child: Padding (
                    padding: EdgeInsets.all(V4rs.paddingValue(3)),
                    child: ButtonStyle1(
                      imagePath: 'assets/interface_icons/interface_icons/iClose.png',
                      onPressed: () {
                        setState(() {
                          SeV4rs.openSearch.value = false;
                          SeV4rs.searchFor = '';
                        });
                      },
                    ),
                    ),
                    ),
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.3
              ),
              SizedBox(
              height: totalHeight * 0.35,
              width: totalWidth * 0.4,
              child: Padding (
                padding: EdgeInsets.all(V4rs.paddingValue(2)),
                child: ButtonStyle1(
                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png',
                  onPressed: () { 
                    setState(() {
                      if (widget.root != null) {
                        foundObjects = SeV4rs.objectsReturned(
                          widget.root!, 
                          SeV4rs.findAllUUIDsForWord(widget.root!.boards, SeV4rs.searchFor)
                        );
                        updateFoundObjects(foundObjects);
                        SeV4rs.findAndPick.value = true;
                      }
                    });
                  },
                ),
              ),
              ),
            ],
          ),
          ],
        );
      },
    );
  }

  Widget pickButton(){
    bool start = true;
    bool end = false;

    void next() {
      setState(() {
        if (searchIndex < foundObjects.length - 1) {
          searchIndex++;
        } 
      });
    }

    void previous() {
      setState(() {
        if (searchIndex > 0) {
          searchIndex = 0;
        }
      });
    }

    void move(){
      setState((){
        if (searchIndex == 0){
          start = true;
          end = false;
        } else if (searchIndex == foundObjects.length - 1) {
          end = true;
          start = false;
        }

        if (start){
          next();
        } else if (end) {
          previous();
        }
      });
    }

    return LayoutBuilder ( 
       builder: (context, constraints) { 

        var totalHeight = constraints.maxHeight;
        var totalWidth = constraints.maxWidth;

      return Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //search box
           Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, V4rs.paddingValue(5)),
            child: 
          Row( 
           children: [
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.66,
                child: (widget.root != null) 
                 ? IndexedStack(
                      index: searchIndex,
                      children: indexedChildren,
                    )
                  : SizedBox(),
                ),
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.33,
                child:  Padding (
                padding: EdgeInsets.all(V4rs.paddingValue(3)),
                child: ButtonStyle1(
                  turn: 270,
                  imagePath: 'assets/interface_icons/interface_icons/iArrow.png',
                  onPressed: move,
                ),
                ),
              ),
            ],
          ),
          ),

          //close and check 
          Row( 
            children: [
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.3,
                child: Padding (
                    padding: EdgeInsets.all(V4rs.paddingValue(3)),
                    child: ButtonStyle1(
                      imagePath: 'assets/interface_icons/interface_icons/iClose.png',
                      onPressed: () {
                        setState(() {
                          SeV4rs.openSearch.value = false;
                          SeV4rs.findAndPick.value = false;
                          SeV4rs.searchFor = '';
                          V4rs.searchPathUUIDS.value = [];
                        });
                      },
                    ),
                    ),
                    ),
              SizedBox(
                height: totalHeight * 0.35,
                width: totalWidth * 0.3
              ),
              SizedBox(
              height: totalHeight * 0.35,
              width: totalWidth * 0.4,
              child: Padding (
                padding: EdgeInsets.all(V4rs.paddingValue(2)),
                child: ButtonStyle1(
                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png',
                  onPressed: () { 
                    setState(() {
                      SeV4rs.findThis = foundObjects[searchIndex];
                      if (widget.root != null && SeV4rs.findThis != null && V4rs.thisBoard != null){
                        SeV4rs.startBoard.add(V4rs.thisBoard!);
                        SeV4rs.startBoard.addAll(V4rs.thisBoard!.content);
                        
                        if (SeV4rs.startBoard.isNotEmpty) {
                         V4rs.searchPathUUIDS.value = 
                          SeV4rs.findWord(widget.root!, SeV4rs.findThis!.id, V4rs.thisBoard!.content).keys.toList();
                         if (!V4rs.searchPathUUIDS.value.contains(SeV4rs.findThis!.id)){
                          V4rs.searchPathUUIDS.value.add(SeV4rs.findThis!.id);
                         }
                        }
                      }
                    });
                  },
                ),
              ),
              ),
            ],
          ),
          ],
        );
      },
    );
  }
}

