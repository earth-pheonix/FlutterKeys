import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'dart:async';


class HistoryV4rs {
  static bool useHistory = true;
  static bool trackTaps = false;

  static List<String> messageHistory = [];
  static List<List<String>> messageHistoryPages = [];

  static int selectedMessageHistoryPage = 0;

  static Future<void> saveMessageHistory (List<String> messageHistory ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("messageHistory", messageHistory);
  } 
  static Future<void> saveuseHistory (bool useHistory ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("useHistory", useHistory);
  } 
  static Future<void> savetrackTaps (bool trackTaps ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("trackTaps", trackTaps);
  } 

  static List<List<String>> getMessageHistoryPages(){
    List<List<String>> pages = [];
    List<String> lastPage = [];

    for (int i=0; i < messageHistory.length; i += 12){
      if ((i+12 < messageHistory.length)) {
         int lastItem = i+12;
         pages.sublist(i, lastItem);
      } 
      else {
        int lastItem = messageHistory.length;
        int difference = i+12 - messageHistory.length;
        lastPage.sublist(i, lastItem);
        for (difference = 0; i < difference; i++){
          lastPage.add('');
        }
        pages.add(lastPage);
      }
    }
    return pages;
  }
}

class HistoryPage {
  Widget buildHistoryWidget(
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
                  buildBackButton(24),
                  Spacer(flex: 2), 
                  buildExportButton(36),
                  Spacer(flex: 40), 
                  buildTapHistoryButton(36),
                  Spacer(flex: 2),
                  buildClearButton(24),
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
                
                buildHistoryButton(46, 0),
                buildSpacer(2),
                buildHistoryButton(34, 1),
                buildSpacer(2),
                buildHistoryButton(34, 2),
                buildSpacer(2),
                buildScrollUpButton(10),

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

                buildHistoryButton(122, 3),
                buildSpacer(7),
                buildHistoryButton(165, 4),
                buildSpacer(7),
                buildHistoryButton(136, 5),

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

                buildHistoryButton(163, 6),
                buildSpacer(11),
                buildHistoryButton(221, 7),
                buildSpacer(11),
                buildHistoryButton(229, 8),

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

                buildHistoryButton(84, 9),
                buildSpacer(6),
                buildHistoryButton(84, 10),
                buildSpacer(6),
                buildHistoryButton(98, 11),
                buildSpacer(20),
                buildScrollDownButton(24),

                buildSpacer(9), 
              ],
            ),
            ),
             Spacer(flex: 17),
          ],
        );
  }

  Widget buildSpacer(int flex) => Expanded(flex: flex, child: const SizedBox());
  Widget buildBackButton(int flex){
    return Expanded(
      flex: flex, 
      child: historyButtonStyle(
        isBack: true,
        contents: 'Back', 
        onPressed: (){}, 
        isSubFolder: true
      )
    );
  }
  Widget buildExportButton(int flex){
    return Expanded(
      flex: flex, 
      child: historyButtonStyle(
        image: 'assets/interface_icons/interface_icons/iExport.png',
        contents: 'Export', 
        onPressed: (){}, 
        isSubFolder: true
      )
    );
  }
  Widget buildTapHistoryButton(int flex){
    return Expanded(
      flex: flex, 
      child: historyButtonStyle(
        contents: 'Tap History', 
        onPressed: (){}, 
        isSubFolder: true
      )
    );
  }
  Widget buildClearButton(int flex){
    return Expanded(
      flex: flex, 
      child: historyButtonStyle(
        image: 'assets/interface_icons/interface_icons/iClear.png',
        contents: 'Clear History', 
        onPressed: (){}, 
        isSubFolder: true
      )
    );
  }
  Widget buildScrollUpButton(int flex){
    return Expanded(
      flex: flex, 
      child: historyButtonStyle(
        image: 'assets/interface_icons/interface_icons/iArrow.png',
        contents: 'Previous', 
        onPressed: (){}, 
        isSubFolder: false
      )
    );
  }
  Widget buildScrollDownButton(int flex){
    return Expanded(
      flex: flex, 
      child: historyButtonStyle(
        rotate: true,
        image: 'assets/interface_icons/interface_icons/iArrow.png',
        contents: 'Next', 
        onPressed: (){}, 
        isSubFolder: false
      )
    );
  }
  Widget buildHistoryButton(int flex, int index){
    return Expanded(
      flex: flex, 
      child: historyButtonStyle(
        contents: HistoryV4rs.messageHistoryPages[HistoryV4rs.selectedMessageHistoryPage][index], 
        onPressed: (){}, 
        isSubFolder: false
      )
    );
  }
}


class historyButtonStyle extends StatelessWidget{
      final void Function()? onPressed;
      final String contents;
      final String? image;
      final bool isSubFolder;
      final bool isBack;
      final bool rotate;
      
      const historyButtonStyle({
        super.key, 
        required this.contents, 
        required this.onPressed,
        this.image = '',
        required this.isSubFolder,
        this.isBack = false,
        this.rotate = false,
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
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
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
              matchOverlayColor:  true, 
              overlayColor:  Colors.white,
              defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
              matchSymbolContrast: true, 
              matchSymbolInvert: true, 
              matchSymbolSaturation: true, 
              defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
              defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
              defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
            );

          Widget theSymbol = (rotate) ? RotatedBox(quarterTurns: 2, child: aSymbol) : aSymbol;

        var case1Contents = <Widget> [
          Flexible(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                V4rs.paddingValue(2.0),
                V4rs.paddingValue(4),
                V4rs.paddingValue(2.0),
                V4rs.paddingValue(2.0),
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
            V4rs.paddingValue(2.0),
            V4rs.paddingValue(4),
            V4rs.paddingValue(2.0),
            V4rs.paddingValue(2.0),), 
          child:
            theSymbol,
          ),
          ),
        ];

        Widget case3Contents = 
          Padding(
            padding: EdgeInsets.all(V4rs.paddingValue(2.0)), child:
            theSymbol,
          );
        
        Widget case4Contents = 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), 
            child: theLabel
          );
        
        Widget button() {
          return ValueListenableBuilder(valueListenable: V4rs.searchPathUUIDS, builder: (context, search, _) {
            return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                elevation: 2,
                backgroundColor: Cv4rs.posToColor('Extra 2'),
                shadowColor: Cv4rs.themeColor4, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Cv4rs.posToBorderColor('Extra 2'),
                    width: Bv4rs.buttonBorderWeight
                  )
                ),
              ),
            onPressed: onPressed,
            child: () {
              switch(isBack ? 3 : Bv4rs.buttonFormat) {
                case 1: 
                  if (!isSubFolder){
                    return case4Contents;
                  } 
                  else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        case1Contents[0],
                        Expanded(
                          flex: 4,
                          child: case1Contents[1],
                        ),
                      ],
                    );
                  }
                case 2: 
                  if (!isSubFolder){
                    return case4Contents;
                  } 
                  else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: case2Contents[0],
                        ),
                         case2Contents[1],
                      ],
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



