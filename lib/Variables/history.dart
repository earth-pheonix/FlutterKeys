import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:share_plus/share_plus.dart'; //for export
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'dart:async';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutterkeysaac/Variables/colors/color_pickers.dart';
import 'package:flutterkeysaac/Variables/search_variables.dart';
import 'dart:typed_data';
import 'dart:io'; //platform

//
//Pages
//

class HistoryPage{

  static Widget buildHistoryWidget(
    Root root,
    void Function(void Function()) setState,
    BoardObjects obj,
    TTSInterface synth, 
    void Function() goBack, 
    void Function(BoardObjects) openBoard, 
    void Function(BoardObjects) openBoardWithReturn, 
    List<BoardObjects> boards, 
    BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById,
    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth,
    final Future<void> Function() initForSS,
    final AudioPlayer playerForSS,
  ) {
    return ValueListenableBuilder(
      valueListenable: HistoryV4rs.openTapHistory,
      builder: (context, page, _){
        if (!HistoryV4rs.openTapHistory.value){
          return MessageHistoryPage.buildMessageHistoryWidget(
            setState,
            obj,
            synth,
            goBack,
            openBoard,
            openBoardWithReturn,
            boards,
            findBoardById,
            speakSelectSherpaOnnxSynth,
            initForSS,
            playerForSS,
          );
        }
        else {
          return TapHistoryPage.buildTapHistoryWidget(
            root,
            setState,
            obj,
            synth,
            goBack,
            openBoard,
            openBoardWithReturn,
            boards,
            findBoardById,
            speakSelectSherpaOnnxSynth,
            initForSS,
            playerForSS,
          );
        }
      }
    );
  }
}

class MessageHistoryPage {

  static Widget buildMessageHistoryWidget(
    void Function(void Function()) setState,
    BoardObjects obj,
    TTSInterface synth, 
    void Function() goBack, 
    void Function(BoardObjects) openBoard, 
    void Function(BoardObjects) openBoardWithReturn, 
    List<BoardObjects> boards, 
    BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById,
    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth,
    final Future<void> Function() initForSS,
    final AudioPlayer playerForSS,
  ) {
    return ValueListenableBuilder(
      valueListenable: MiniCombinedValueNotifier(
        HistoryV4rs.selectedMessageHistoryPage, HistoryV4rs.messageHistoryPages, null, null, null
      ), 
      builder: (context, page, _){
    
    return Column(
      children: [
        // === Row 0 === 
        Flexible(
          flex: 34,
          child: 
          Column( children: [
          Spacer(flex: 3),
          Expanded(
            flex: 27,
            child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(flex: 1),
              buildBackButton(24, goBack),
              Spacer(flex: 2), 
              buildTapHistoryButton(36),
              Spacer(flex: 40), 
              buildExportButton(36, context),
              Spacer(flex: 2),
              buildClearButton(24, setState),
              Spacer(flex: 1), 
            ],
          ),
          ),
          Spacer(flex: 7),
          ]),
        ),
        

        // === Row 1 === 
        Expanded(
          flex: 36,
          child: 
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSpacer(1), 
            
            buildHistoryButton(46, 0, true),
            buildSpacer(2),
            buildHistoryButton(34, 1, false),
            buildSpacer(2),
            buildHistoryButton(34, 2, true),
            buildSpacer(2),
            buildScrollUpButton(10, setState),

            buildSpacer(1),
          ],
        ),
        ),
          Spacer(flex: 8),

        // === Row 2 ===
          Expanded(
          flex: 36,
          child: 
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSpacer(21), 

            buildHistoryButton(122, 3, false),
            buildSpacer(7),
            buildHistoryButton(165, 4, true),
            buildSpacer(7),
            buildHistoryButton(136, 5, false),

            buildSpacer(20),
          ],
        ),
          ),
          Spacer(flex: 8),

        // === Row 3 === 
          Expanded(
          flex: 36,
          child: 
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSpacer(6), 

            buildHistoryButton(163, 6, true),
            buildSpacer(11),
            buildHistoryButton(221, 7, false),
            buildSpacer(11),
            buildHistoryButton(229, 8, true),

            buildSpacer(15), 
          ],
        ),
          ),
          Spacer(flex: 8),

        // === Row 4 === 
        Expanded(
          flex: 36,
          child: 
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSpacer(2),

            buildHistoryButton(84, 9, false),
            buildSpacer(6),
            buildHistoryButton(84, 10, true),
            buildSpacer(6),
            buildHistoryButton(98, 11, false),
            buildSpacer(20),
            buildScrollDownButton(24, setState),

            buildSpacer(9), 
          ],
        ),
        ),
          Spacer(flex: 17),
      ],
    );
      }
    );
  }

 //----------

  static Widget buildSpacer(int flex) => Expanded(flex: flex, child: const SizedBox());
  
  static Widget buildBackButton(int flex, final void Function() goBack){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iBack.png',
        useThree: true,
        contents: 'Back', 
        onPressed: (){
          HistoryV4rs.openHistory.value = false;
        }, 
        isSubFolder: true
      )
    );
  }
 
  static  Widget buildExportButton(int flex, context){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iExport.png',
        contents: 'Export', 
        onPressed: (){
          HistoryV4rs.exportMessageHistory(context);
        }, 
        isSubFolder: true
      )
    );
  }
 
  static Widget buildTapHistoryButton(int flex){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iPlaceholder.png',
        contents: 'Tap History', 
        onPressed: (){
          HistoryV4rs.openTapHistory.value = true;
          if (HistoryV4rs.openTapHistory.value){
            HistoryV4rs.getTapHistoryPages();
          }
        }, 
        isSubFolder: true
      )
    );
  }
  
  static Widget buildClearButton(int flex, void Function(void Function()) setState){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iClear.png',
        contents: 'Clear History', 
        onPressed: (){ 
          setState((){
            HistoryV4rs.clearPrefsMessageHistory();
            HistoryV4rs.messageHistory = [];
            HistoryV4rs.getMessageHistoryPages();
            }
          );
        }, 
        isSubFolder: true
      )
    );
  }
  
  static Widget buildScrollUpButton(int flex, void Function(void Function()) setState){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        column: true,
        rotate: true,
        image: 'assets/interface_icons/interface_icons/iArrow.png',
        contents: 'Previous', 
        onPressed: (){ setState((){
          if (HistoryV4rs.selectedMessageHistoryPage.value - 1 >= 0){
            HistoryV4rs.selectedMessageHistoryPage.value = HistoryV4rs.selectedMessageHistoryPage.value - 1;
          }
        });
        }, 
        isSubFolder: true,
      )
    );
  }
 
  static Widget buildScrollDownButton(int flex, void Function(void Function()) setState){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        column: true,
        image: 'assets/interface_icons/interface_icons/iArrow.png',
        contents: 'Next', 
        onPressed: (){setState((){
          print('next');
          if (HistoryV4rs.messageHistoryPages.value.length - 1
            >= HistoryV4rs.selectedMessageHistoryPage.value + 1
          ){
            print('adding');
            HistoryV4rs.selectedMessageHistoryPage.value = HistoryV4rs.selectedMessageHistoryPage.value + 1;
          }
        });
        }, 
        isSubFolder: true,
      )
    );
  }
  
  static Widget buildHistoryButton(int flex, int index, bool alternate){
    return ValueListenableBuilder(
      valueListenable: HistoryV4rs.selectedMessageHistoryPage, 
      builder: (context, selected, _){
        return Expanded(
              flex: flex, 
              child: HistoryButtonStyle(
                leading: true,
                alternate: alternate,
                contents: HistoryV4rs.messageHistoryPages.value[selected][index], 
                onPressed: (){
                  V4rs.changedMWfromButton = true;
                  V4rs.message.value 
                    = V4rs.message.value 
                    + (HistoryV4rs.messageHistoryPages.value[selected][index]);
                  V4rs.changedMWfromButton = false;
                }, 
                isSubFolder: false
              )
            );
      });
    
    }
}

class TapHistoryPage {
        
  static Widget buildTapHistoryWidget(
    Root root,
    void Function(void Function()) setState,
    BoardObjects obj,
    TTSInterface synth, 
    void Function() goBack, 
    void Function(BoardObjects) openBoard, 
    void Function(BoardObjects) openBoardWithReturn, 
    List<BoardObjects> boards, 
    BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById,
    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth,
    final Future<void> Function() initForSS,
    final AudioPlayer playerForSS,
  ) {
        return ValueListenableBuilder(
          valueListenable: MiniCombinedValueNotifier(
            HistoryV4rs.selectedTapHistoryPage, HistoryV4rs.tapHistoryPages, null, null, null
          ), 
          builder: (context, page, _){
            
        return Column(
          children: [
            // === Row 0 === 
            Flexible(
              flex: 34,
              child: 
              Column( children: [
              Spacer(flex: 3),
              Expanded(
                flex: 27,
                child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacer(flex: 1),
                  buildBackButton(24, goBack),
                  Spacer(flex: 2), 
                  buildOpenMessageHistoryButton(36),
                  Spacer(flex: 40), 
                  buildExportButton(36, context, root, boards),
                  Spacer(flex: 2),
                  buildClearButton(24, setState),
                  Spacer(flex: 1), 
                ],
              ),
              ),
              Spacer(flex: 7),
              ]),
            ),
            

            // === Row 1 === 
            Expanded(
              flex: 36,
              child: 
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSpacer(1), 
                
                buildHistoryButton(46, 0, 3, root, boards),
                buildSpacer(2),
                buildHistoryButton(34, 1, 2, root, boards),
                buildSpacer(2),
                buildHistoryButton(34, 2, 2, root, boards),
                buildSpacer(2),
                buildScrollUpButton(10, setState),

                buildSpacer(1),
              ],
            ),
            ),
             Spacer(flex: 8),

            // === Row 2 ===
             Expanded(
              flex: 36,
              child: 
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSpacer(21), 

                buildHistoryButton(122, 3, 2, root, boards),
                buildSpacer(7),
                buildHistoryButton(165, 4, 3, root, boards),
                buildSpacer(7),
                buildHistoryButton(136, 5, 2, root, boards),

                buildSpacer(20),
              ],
            ),
             ),
              Spacer(flex: 8),

            // === Row 3 === 
             Expanded(
              flex: 36,
              child: 
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSpacer(6), 

                buildHistoryButton(163, 6, 2, root, boards),
                buildSpacer(11),
                buildHistoryButton(221, 7, 3, root, boards),
                buildSpacer(11),
                buildHistoryButton(229, 8, 3, root, boards),

                buildSpacer(15), 
              ],
            ),
             ),
              Spacer(flex: 8),

            // === Row 4 === 
            Expanded(
              flex: 36,
              child: 
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSpacer(2),

                buildHistoryButton(84, 9, 2, root, boards),
                buildSpacer(6),
                buildHistoryButton(84, 10, 2, root, boards),
                buildSpacer(6),
                buildHistoryButton(98, 11, 2, root, boards),
                buildSpacer(20),
                buildScrollDownButton(24, setState),

                buildSpacer(9), 
              ],
            ),
            ),
             Spacer(flex: 17),
          ],
        );
          }
        );
  }

 //----------

  static Widget buildSpacer(int flex) => Expanded(flex: flex, child: const SizedBox());
  
  static Widget buildBackButton(int flex, final void Function() goBack){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iBack.png',
        useThree: true,
        contents: 'Back', 
        onPressed: (){
          HistoryV4rs.openTapHistory.value = false;
        }, 
        isSubFolder: true
      )
    );
  }
  
  static Widget buildExportButton(int flex, context, Root root, List<BoardObjects> boards){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iExport.png',
        contents: 'Export', 
        onPressed: (){
          HistoryV4rs.exportTapHistory(
            context,
            boards,
            root
          );
        }, 
        isSubFolder: true
      )
    );
  }
  
  static  Widget buildOpenMessageHistoryButton(int flex){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iPlaceholder.png',
        contents: 'Message History', 
        onPressed: (){
          HistoryV4rs.openTapHistory.value = false;
        }, 
        isSubFolder: true
      )
    );
  }
  
  static Widget buildClearButton(int flex, void Function(void Function()) setState){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        image: 'assets/interface_icons/interface_icons/iClear.png',
        contents: 'Clear History', 
        onPressed: (){ setState((){
          HistoryV4rs.clearPrefsTapHistory(HistoryV4rs.tapHistory);
          HistoryV4rs.tapHistory = {};
          HistoryV4rs.getTapHistoryPages();
          }
        );
        }, 
        isSubFolder: true
      )
    );
  }
  
  static Widget buildScrollUpButton(int flex, void Function(void Function()) setState){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        column: true,
        rotate: true,
        image: 'assets/interface_icons/interface_icons/iArrow.png',
        contents: 'Previous', 
        onPressed: (){ setState((){
          if (HistoryV4rs.selectedTapHistoryPage.value - 1 >= 0){
            HistoryV4rs.selectedTapHistoryPage.value = HistoryV4rs.selectedTapHistoryPage.value - 1;
          }
        });
        }, 
        isSubFolder: true,
      )
    );
  }
  
  static Widget buildScrollDownButton(int flex, void Function(void Function()) setState){
    return Expanded(
      flex: flex, 
      child: HistoryButtonStyle(
        column: true,
        image: 'assets/interface_icons/interface_icons/iArrow.png',
        contents: 'Next', 
        onPressed: (){setState((){
          if (HistoryV4rs.tapHistoryPages.value.length - 1
            >= HistoryV4rs.selectedTapHistoryPage.value + 1
          ){
            HistoryV4rs.selectedTapHistoryPage.value = HistoryV4rs.selectedTapHistoryPage.value + 1;
          }
        });
        }, 
        isSubFolder: true,
      )
    );
  }
  
  static Widget buildHistoryButton(int flex, int index, int pathWidth, Root root, List<BoardObjects> boards){
    final pages = HistoryV4rs.tapHistoryPages.value;
    final pageIndex = HistoryV4rs.selectedTapHistoryPage.value;

    Map<String, int>? thePage 
      =  ((pageIndex >= 0 && pageIndex < pages.length))
      ? HistoryV4rs.tapHistoryPages.value[HistoryV4rs.selectedTapHistoryPage.value]
      : null;

    String? thePath = ((thePage != null) ? index < thePage.length : false)
      ? SeV4rs.getPath(SeV4rs.findPath(root, thePage.entries.elementAt(index).key))
      : null;
    BoardObjects? theObj = ((thePage != null) ? index < thePage.length: false)
      ? Ev4rs.findBoardById(boards, thePage.entries.elementAt(index).key)
      : null;
    int theCount = ((thePage != null) ? index < thePage.length : false)
      ? thePage.entries.elementAt(index).value
      : 0;

    return ValueListenableBuilder(
      valueListenable: HistoryV4rs.selectedMessageHistoryPage, 
      builder: (context, selected, _){
        return Expanded(
              flex: flex, 
              child: (thePath != null && theObj != null) 
                ? TapHistoryButtonStyle(
                  pathWidth: pathWidth,
                  path: thePath,
                  obj: theObj,
                  count: theCount,
                  onPressed: (){}, 
                )
                : TapHistoryPlaceholder(),
            );
      });
    }

}

//
//Settings
//

class HistorySettings extends StatefulWidget{
  const HistorySettings({super.key});

  @override
  State<HistorySettings> createState() => _HistorySettings();
}

class _HistorySettings extends State<HistorySettings>{
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text('History:', style: Sv4rs.settingslabelStyle),
      collapsedBackgroundColor: Cv4rs.themeColor4,
      backgroundColor: Cv4rs.themeColor4,
      childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(40)),
          child: Row(
            children: [
              Text('Track Message History:', style: Sv4rs.settingslabelStyle),
              Spacer(),
              Switch(value: HistoryV4rs.useHistory, onChanged: (value) {
                setState(() {
                  HistoryV4rs.useHistory = value;
                  HistoryV4rs.saveuseHistory(value);
                });
              }),
            ]
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(40)),
          child: Row(
            children: [
              Text('Track Tap History:', style: Sv4rs.settingslabelStyle),
              Spacer(),
              Switch(value: HistoryV4rs.trackTaps, onChanged: (value) {
                setState(() {
                  HistoryV4rs.trackTaps = value;
                  HistoryV4rs.savetrackTaps(value);
                });
              }),
            ]
          ),
        ),
        ExpansionTile(
          title: Text('Export:', style: Sv4rs.settingslabelStyle),
          collapsedBackgroundColor: Cv4rs.themeColor4,
          backgroundColor: Cv4rs.themeColor4,
          childrenPadding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(20)),
          children: [ 
            Row (children: [
              if (!V4rs.xSmallModeWidth)
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
                      Expanded(child: 
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(V4rs.paddingValue(10)),), 
                          child: Text(
                            'Message History:', 
                            maxLines: 2, 
                            textAlign: TextAlign.center, 
                            style: Fv4rs.mwLabelStyle.copyWith(
                              color: Cv4rs.themeColor4, 
                            ),
                          ),
                        ),
                      ),
                    ]),
                  onPressed: () {
                    HistoryV4rs.exportMessageHistory(context);
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
                      Expanded(child: 
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10),), 
                        child: Text('Tap History', 
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: Fv4rs.mwLabelStyle.copyWith(
                          color: Cv4rs.themeColor4,
                        )),
                      ),
                      )
                    ]),
                  onPressed: () {
                    
                  }, 
                ),
              ),
              if (!V4rs.xSmallModeWidth)
              Spacer(),
            ]
            ),
           ]
          ),
        ExpansionTile(
          title: Row(
            children: [
              Text('Color:', style: Sv4rs.settingslabelStyle,),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Cv4rs.themeColor3,
                radius: 20,
                child: Icon(Icons.circle, color: HistoryV4rs.historyButtonColor, size: 40, shadows: [
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
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: V4rs.paddingValue(40), 
                vertical: V4rs.paddingValue(20)),
              child: HexCodeInput(
                startValue: HistoryV4rs.historyButtonColor.toHexString(),
                textStyle: Sv4rs.settingslabelStyle,
                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                onColorChanged: (color) {
                  setState(() {
                      HistoryV4rs.historyButtonColor= color;
                      HistoryV4rs.savehistoryButtonColor(color);
                  });
                },
              ),
            ),
            //color picker
            Padding(
              padding: EdgeInsets.fromLTRB(
                V4rs.paddingValue(40), 0, V4rs.paddingValue(10), V4rs.paddingValue(10)),
              child: ColorPicker(
                pickerColor: HistoryV4rs.historyButtonColor, 
                enableAlpha: false,
                displayThumbColor: false,
                labelTypes: ColorLabelType.values,
                onColorChanged:  (Color color) {
                    setState(() {
                      HistoryV4rs.historyButtonColor = color;
                      HistoryV4rs.savehistoryButtonColor(color);
                  });
                },
              ),
          ),
          ],
        ),
      ]
    );
  }
}

//
//UI Shortcuts
//

class HistoryButtonStyle extends StatelessWidget{
      final void Function()? onPressed;
      final String contents;
      final String? image;
      final bool isSubFolder;
      final bool useThree;
      final bool rotate;
      final bool column;
      final bool leading;
      final bool alternate;
      
      const HistoryButtonStyle({
        super.key, 
        required this.contents, 
        required this.onPressed,
        this.image = '',
        required this.isSubFolder,
        this.useThree = false,
        this.rotate = false,
        this.column = false,
        this.leading = false,
        this.alternate = false,
      });

      @override
      Widget build(BuildContext context) {
        
        TextStyle matchStyle =  
        (isSubFolder) 
        ? TextStyle(
          color: Fv4rs.subFolderFontColor,
          fontSize: V4rs.fontValue(Fv4rs.subFolderFontSize),
          fontFamily: Fontsy.fontToFamily[Fv4rs.subFolderFont], 
          fontWeight: FontWeight.values[((Fv4rs.subFolderFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.subFolderFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.subFolderFontUnderline ? TextDecoration.underline : TextDecoration.none,
         ) 
        : TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: V4rs.fontValue(Fv4rs.buttonFontSize),
          fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
          fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Text theLabel = 
        Text(contents, 
          style: matchStyle,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        );
      
      //image
          Widget symbol 
            = LoadImage.fromSymbol(
              image ?? 'assets/interface_icons/interface_icons/iPlaceholder.png',
            );
          
          Widget aSymbol = 
            ImageStyle1(
              image: symbol, 
              symbolSaturation:  1.0, 
              symbolContrast:  1.0, 
              invertSymbolColors:  false, 
              overlayColor:  Colors.black,
              matchOverlayColor:  true, 
              matchSymbolContrast: true, 
              matchSymbolInvert: true, 
              matchSymbolSaturation: true, 
              defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
              defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
              defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
              defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay
            );

          Widget theSymbol = (rotate) ? RotatedBox(quarterTurns: 2, child: aSymbol) : aSymbol;

        var case1Contents = <Widget> [
          Flexible(
            child: Padding(
              padding: (column) 
                ? EdgeInsets.all(V4rs.paddingValue(3))
                : EdgeInsets.all(V4rs.paddingValue(8)),
              child: theSymbol,
            ),
          ),
          Flexible(child:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), 
              child: theLabel,
            ),
          ),
        ];

        var case2Contents = <Widget> [
          Flexible(child:
            Padding(
              padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
              theLabel,
            ),
          ),
          Flexible(
            child: 
          Padding(padding: (column) 
                ? EdgeInsets.all(V4rs.paddingValue(3))
                : EdgeInsets.all(V4rs.paddingValue(8)),
          child:
            theSymbol,
          ),
          ),
        ];

        Widget case3Contents = 
          Padding(
            padding: EdgeInsets.all(V4rs.paddingValue(8)), child:
            theSymbol,
          );
        
        Widget case4Contents = 
        Row(
          mainAxisAlignment: (leading) ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: V4rs.paddingValue(10), 
              vertical: V4rs.paddingValue(5)
            ), 
            child: theLabel
          ),
        ]
        );
        
        Widget button() {
          return ValueListenableBuilder(valueListenable: V4rs.searchPathUUIDS, builder: (context, search, _) {
            return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                elevation: 2,
                backgroundColor: (alternate)
                  ? Cv4rs.adjustAlternateColor(HistoryV4rs.historyButtonColor)
                  : HistoryV4rs.historyButtonColor,
                shadowColor: Cv4rs.themeColor4, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Cv4rs.adjustLuminance(HistoryV4rs.historyButtonColor, -0.12),
                    width: Bv4rs.buttonBorderWeight
                  )
                ),
              ),
            onPressed: onPressed,
            child: () {
              switch(useThree ? 3 : Bv4rs.buttonFormat) {
                case 1: 
                  if (column){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: case1Contents,
                    );
                  } 
                  else if (!isSubFolder){
                    return case4Contents;
                  } 
                  else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: case1Contents
                    );
                  }
                case 2: 
                  if (column){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:
                         case2Contents,
                    );
                  }
                  else if (!isSubFolder){
                    return case4Contents;
                  } 
                  else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: case2Contents,
                    );
                     
                  }
                case 3: 
                  if (!isSubFolder){
                    return case4Contents;
                  } 
                  else {
                    return case3Contents;
                  }
                case 4:
                  return case4Contents;
                }
            } (),
            );
            }
          );
        }

        return Visibility(
          visible: (contents != ''), 
          maintainSize: true, 
          maintainAnimation: true,
          maintainState: true,
          child: button()
        );
        }
    }

class TapHistoryButtonStyle extends StatelessWidget{
      final BoardObjects obj;
      final void Function()? onPressed;
      final String path;
      final int pathWidth;
      final int count;
      
      const TapHistoryButtonStyle({
        super.key, 
        required this.obj, 
        required this.onPressed,
        required this.path,
        required this.count,
        this.pathWidth = 2,
      });

      @override
      Widget build(BuildContext context) {
        final defaultStyle = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();

        //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: V4rs.fontValue(obj.fontSize ?? 16),
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: V4rs.fontValue(Fv4rs.buttonFontSize),
          fontFamily: Fontsy.fontToFamily[Fv4rs.buttonFont], 
          fontWeight: FontWeight.values[((Fv4rs.buttonFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.buttonFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.buttonFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Text countAndPath = 
          Text.rich(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            TextSpan(
              style: (obj.matchFont ?? true) ? defaultStyle.merge(matchStyle) : defaultStyle.merge(uniqueStyle),
              children: [
                TextSpan(
                  text: 'Taps: $count ',
                  style: (obj.matchFont ?? true) 
                    ? matchStyle.copyWith(fontWeight: FontWeight.w600) 
                    : uniqueStyle.copyWith(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: '- $path -> ${obj.label}',
                ),
              ]
            ), 
        );
        Text theLabel = 
          Text(obj.label ?? "", 
            style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        Text theLabel2 = 
          Text(obj.label ?? "", 
            style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          );
      
      //image
        Widget image = LoadImage.fromSymbol(obj.symbol);

      //symbol
        Widget theSymbol = 
          ImageStyle1(
            image: image, 
            symbolSaturation: obj.symbolSaturation ?? 1.0, 
            symbolContrast: obj.symbolContrast ?? 1.0, 
            invertSymbolColors: obj.invertSymbol ?? false, 
            matchOverlayColor: obj.matchOverlayColor ?? true, 
            overlayColor: obj.overlayColor ?? Colors.white,
            defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
            defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
          );

        var case1Contents = <Widget> [
          
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                V4rs.paddingValue(obj.padding ?? 2.0),
                V4rs.paddingValue((obj.padding ?? 2.0) + 2.0),
                V4rs.paddingValue(obj.padding ?? 2.0),
                V4rs.paddingValue(obj.padding ?? 2.0),
              ), 
              child: theSymbol,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), 
            child: theLabel,
          ),
        ];

        var case2Contents = <Widget> [
         
          Padding(
            padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
            theLabel,
          ),
          Flexible(
            child: 
          Padding(padding: EdgeInsets.fromLTRB(
            V4rs.paddingValue(obj.padding ?? 2.0),
            V4rs.paddingValue((obj.padding ?? 2.0) + 2.0),
            V4rs.paddingValue(obj.padding ?? 2.0),
            V4rs.paddingValue(obj.padding ?? 2.0),), 
          child:
            theSymbol,
          ),
          ),
        ];

        var case3Contents = <Widget> [
          
          Padding(
            padding: EdgeInsets.all(V4rs.paddingValue(obj.padding ?? 2.0)), child:
            theSymbol,
          )
        ];

        var case4Contents = <Widget> [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), 
              child: theLabel2
            )
        ];

        

        Widget button() {
          return ValueListenableBuilder(valueListenable: V4rs.searchPathUUIDS, builder: (context, search, _) {
            return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                elevation: 2,
                backgroundColor: 
                  (obj.matchPOS ?? true) 
                    ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                    : obj.backgroundColor ?? Cv4rs.themeColor2,
                shadowColor: Cv4rs.themeColor4, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: (obj.matchBorder ?? true) 
                      ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                      : obj.borderColor ?? Colors.white,
                    width: (obj.matchBorder ?? true) 
                      ? Bv4rs.buttonBorderWeight
                      : obj.borderWeight ?? 2.5
                  )
                ),
              ),
            onPressed: onPressed,
            child: () {
              switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
                case 1: 
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: case1Contents
                          )
                        ),
                        Expanded(
                          flex: pathWidth,
                          child: 
                            Padding(
                              padding: EdgeInsets.all(V4rs.paddingValue(8)),
                              child: countAndPath
                            ),
                        ),
                      ],
                    );
                case 2: 
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: case2Contents
                          )
                        ),
                        Expanded(
                          flex: pathWidth,
                          child: 
                            Padding(
                              padding: EdgeInsets.all(V4rs.paddingValue(5)),
                              child: countAndPath
                            ),
                        ),
                      ],
                    );
                case 3: 
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(children: case3Contents,) 
                        ),
                        Expanded(
                          flex: pathWidth,
                          child: 
                            Padding(
                              padding: EdgeInsets.all(V4rs.paddingValue(5)),
                              child: countAndPath
                            ),
                        ),
                      ],
                    );
                case 4:
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(children: case4Contents),
                        ),
                        Expanded(
                          flex: pathWidth,
                          child: 
                            Padding(
                              padding: EdgeInsets.all(V4rs.paddingValue(5)),
                              child: countAndPath
                            ),
                        ),
                      ],
                    );
                }
            } (),
            );
            }
          );
        }
          return Visibility(
            visible: (obj.show ?? true), 
            maintainSize: true, 
            maintainAnimation: true,
            maintainState: true,
            child: button()
          );
        }
    }

class TapHistoryPlaceholder extends StatelessWidget{

  const TapHistoryPlaceholder({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: (false), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true,
        child: SizedBox()
      );
    }
}

//
// Variables
//

class HistoryV4rs {

  static Map<int, String> englishMonths = {
    1: 'January',
    2: 'Febuary',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  static Color historyButtonColor = Color(0xFFD0CFCF);
  static Future<void> savehistoryButtonColor(Color historyButtonColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("historyButtonColor", historyButtonColor.toARGB32());
  }

  //
  //message history
  //

  static ValueNotifier<bool> openHistory = ValueNotifier(false);
  static ValueNotifier<int> selectedMessageHistoryPage = ValueNotifier(0);
  
  static bool useHistory = true;
  static Future<void> saveuseHistory (bool useHistory ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("useHistory", useHistory);
  } 

  static List<String> messageHistory = [];
  static Future<void> saveMessageHistory (List<String> messageHistory ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("messageHistory", messageHistory);
  } 

  static Future<void> clearPrefsMessageHistory () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("messageHistory");
  } 

  static ValueNotifier<List<List<String>>> messageHistoryPages  = ValueNotifier([]);
  static List<List<String>> getMessageHistoryPages(){
    print('getMessageHistoryPages: hello');

    messageHistoryPages.value  = [];
    
    for (int i=0; i < messageHistory.length; i += 12){
      int lastItem = (i + 12 < messageHistory.length) ? i + 12 : messageHistory.length;
      (i + 12 < messageHistory.length) ? i + 12 : messageHistory.length;
      List<String> page = messageHistory.sublist(i, lastItem);

      while (page.length < 12) { //while = keep going while condition is true
        page.add('');
      }
      messageHistoryPages.value .add(page);
    }
    if (messageHistory.isEmpty){
      List<String> page = [];
      while (page.length < 12) {
        page.add('');
      }
      messageHistoryPages.value .add(page);
    }
    return messageHistoryPages.value ;
  }

  static Future<void> exportMessageHistory(dynamic context) async {
    final pdf = pw.Document();
    DateTime now = DateTime.now();
    final box = context.findRenderObject() as RenderBox?;

    pdf.addPage(
       pw.MultiPage(
        footer: (context) => 
          pw.Text(
            '(${englishMonths[now.month]} ${now.day}, ${now.year}) - ${context.pageNumber}'
          ),
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Text("Message History (${englishMonths[now.month]} ${now.day}, ${now.year})")),
          pw.ListView.builder(
            itemCount: HistoryV4rs.messageHistory.length,
            itemBuilder: (context, index) => pw.Text(HistoryV4rs.messageHistory[index]),
          ),
        ],
      ),
    );

    final Uint8List bytes = await pdf.save();

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/message_history_${now.year}-${now.month}-${now.day}.pdf');

    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)], 
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
  
  //
  //tap history
  //

  static ValueNotifier<bool> openTapHistory = ValueNotifier(false);
  static ValueNotifier<int> selectedTapHistoryPage = ValueNotifier(0);

  static bool trackTaps = false;
  static Future<void> savetrackTaps (bool trackTaps ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("trackTaps", trackTaps);
  } 
  
  static Map<String, int> tapHistory = {};
  static Future<void> savetapHistory (Map<String, int> tapHistory) async {
    final prefs = await SharedPreferences.getInstance();
    final i = tapHistory.length - 1;
    await prefs.setInt("tapHistoryLength", tapHistory.length);
    await prefs.setString("tapHistory-key-$i", tapHistory.entries.elementAt(i).key);
    await prefs.setInt("tapHistory-value-$i", tapHistory.entries.elementAt(i).value);
  } 
  static Future<void> clearPrefsTapHistory (Map<String, int> tapHistory) async {
    final prefs = await SharedPreferences.getInstance();
    for(int i=0; i < tapHistory.length; i++){
      await prefs.setInt("tapHistoryLength", 0);
      await prefs.remove("tapHistory-key-$i");
      await prefs.remove("tapHistory-value-$i");
    }
  } 

  static ValueNotifier<List<Map<String, int>>> tapHistoryPages  = ValueNotifier([]);
  static List<Map<String, int>> getTapHistoryPages(){
    tapHistoryPages.value  = [];
    
    for (int i=0; i < tapHistory.length; i += 12){
      int lastItem = (i + 12 < tapHistory.length) ? i + 12 : tapHistory.length;
      
      final values = tapHistory.entries.toList().sublist(i, lastItem);
      Map<String, int> page = Map.fromEntries(values);

      tapHistoryPages.value.add(page);
    }
    return tapHistoryPages.value;
  }

  static void addTap(BoardObjects obj){
    if (HistoryV4rs.trackTaps){
      if (HistoryV4rs.tapHistory[obj.id] != null){
        HistoryV4rs.tapHistory[obj.id] = HistoryV4rs.tapHistory[obj.id]! + 1;
      } 
      else {
        HistoryV4rs.tapHistory[obj.id] = 1;
      }
      savetapHistory(HistoryV4rs.tapHistory);
    }
  }

  
  static Future<void> exportTapHistory(dynamic context, List<BoardObjects> boards, Root root) async {
    final pdf = pw.Document();
    DateTime now = DateTime.now();
    final box = context.findRenderObject() as RenderBox?;

    pw.TableRow buildTableHeading(List<String> cells) {
      return pw.TableRow(
        children: cells.map((cell) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(
              cell,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
            ),
          );
        }).toList(),
      );
    }

    pw.TableRow buildTableRow(int index, List<BoardObjects> boards, Root root) {
      String? thePath = (index < HistoryV4rs.tapHistory.length)
        ? SeV4rs.getPath(SeV4rs.findPath(root, HistoryV4rs.tapHistory.entries.elementAt(index).key))
        : null;
      BoardObjects? theObj = (index < HistoryV4rs.tapHistory.length)
        ? Ev4rs.findBoardById(boards, HistoryV4rs.tapHistory.entries.elementAt(index).key)
        : null;
      int theCount = (index < HistoryV4rs.tapHistory.length)
        ? HistoryV4rs.tapHistory.entries.elementAt(index).value
        : 0;

      List<String> cells = [theObj?.label ?? '', theCount.toString(), '$thePath -> ${theObj?.label}'];

      return pw.TableRow(
        children: cells.map((cell) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(5),
            child: pw.Text(
              cell,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.normal,
                fontSize: 10,
              ),
            ),
          );
        }).toList(),
      );
    }

    pdf.addPage(
       pw.MultiPage(
        footer: (context) => 
          pw.Text(
            '(${englishMonths[now.month]} ${now.day}, ${now.year}) - ${context.pageNumber}'
          ),
        build: (pw.Context context) => [
          pw.Header(level: 0, child: pw.Text("Tap History (${englishMonths[now.month]} ${now.day}, ${now.year})")),
          pw.Table(
            columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(2), 
                  2: const pw.FlexColumnWidth(3),
                },
            children: [
              buildTableHeading(['Button', 'Count', 'Path']),
              for (int i=0; i<tapHistory.length; i++)
                buildTableRow(i, boards, root),
            ],
          ),
        ],
       ),
    );

    final Uint8List bytes = await pdf.save();

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/tap_history_${now.year}-${now.month}-${now.day}.pdf');

    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(file.path)], 
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
  
  
  //
  //load saved values 
  //

  static Future<void> loadSavedHistoryValues() async {
    final prefs = await SharedPreferences.getInstance(); 

    messageHistory = prefs.getStringList('messageHistory') ?? [];
    useHistory = prefs.getBool('useHistory') ?? true;
    trackTaps = prefs.getBool('trackTaps') ?? false;
    historyButtonColor = Color(prefs.getInt('historyButtonColor') ?? 0xFFD0CFCF);

    tapHistory = {};
    final count = prefs.getInt('tapHistoryLength') ?? 0;
    for (int i=0; i < count; i++){
       final String? key = prefs.getString("tapHistory-key-$i");
       final int? value = prefs.getInt("tapHistory-value-$i");

       if ((key != null) && (value != null)){
        tapHistory[key] = value;
       }
    } 

    getMessageHistoryPages();
  } 

}

