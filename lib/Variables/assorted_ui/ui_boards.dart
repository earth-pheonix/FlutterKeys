import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/grammer_variables.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'dart:async';
import 'dart:io';

// 
// buttons
//


class BoardButtonStyle extends StatelessWidget{
      final BoardObjects obj;
      final void Function()? onPressed;
      final bool editable;
      final bool isSubFolder;
      final void Function()? editSubFolderPress;
      
      const BoardButtonStyle({
        super.key, 
        required this.obj, 
        required this.onPressed,
        required this.editable,
        this.isSubFolder = false,
        this.editSubFolderPress,
      });

      Widget subFolderEditButton() {
        return Padding(
            padding: EdgeInsetsGeometry.all(V4rs.paddingValue(5)), 
            child: ButtonStyle1(
              glow: true,
              imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
              onPressed: editSubFolderPress!
            ),  
        );
      }

      @override
      Widget build(BuildContext context) {
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
          if (editable && editSubFolderPress != null)
            subFolderEditButton()
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
          if (editable && editSubFolderPress != null)
           subFolderEditButton()
        ];

        Widget case3Contents = 
          Padding(
            padding: EdgeInsets.all(V4rs.paddingValue(obj.padding ?? 2.0)), child:
            theSymbol,
          );
        
        Widget case4Contents = 
          Padding(
            padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), 
            child: theLabel2
          );
        
        Widget button() {
          return ValueListenableBuilder(valueListenable: V4rs.searchPathUUIDS, builder: (context, search, _) {
            return ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                elevation: 2,
                backgroundColor: 
                (editable) 
                ? (Ev4rs.firstSelectedUUID.value == obj.id || Ev4rs.secondSelectedUUID.value == obj.id
                    || Ev4rs.selectedUUIDs.value.contains(obj.id) || Ev4rs.selectedUUIDs.value.contains(obj.id)) 
                    ? (obj.matchPOS ?? true) 
                      ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                      : obj.borderColor ?? Colors.blueGrey
                    : (obj.matchPOS ?? true) 
                      ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                      : obj.backgroundColor ?? Colors.blueGrey
                : (V4rs.isSearchPath(V4rs.searchPathUUIDS.value, obj))
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                  : (obj.matchPOS ?? true) 
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
                  if (!isSubFolder){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: case1Contents,
                    );
                  } 
                  else {
                     if (V4rs.xSmallModeWidth && editable){
                      return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(children: [
                            case1Contents[0],
                            Expanded(
                              flex: 3,
                              child: case1Contents[1],
                            ),
                           ],
                          )
                        ),
                        Expanded(
                          child: case1Contents[2],
                        ),
                      ],
                    );
                     } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        case1Contents[0],
                        Expanded(
                          flex: 4,
                          child: case1Contents[1],
                        ),
                        if (editable)
                        Expanded(
                          flex: 4,
                          child: case1Contents[2],
                        ),
                      ],
                    );
                     }
                  }
                case 2: 
                  if (!isSubFolder){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: case2Contents,
                    );
                  } 
                  else {
                     if (V4rs.xSmallModeWidth && editable){
                      return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(children: [
                            Expanded(
                              flex: 3,
                              child: case2Contents[0],
                            ),
                            case2Contents[1],
                           ],
                          )
                        ),
                        Expanded(
                          child: case1Contents[2],
                        ),
                      ],
                    );
                     } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 4,
                          child: case2Contents[0],
                        ),
                         case2Contents[1],
                        if (editable)
                        Expanded(
                          flex: 4,
                          child: case1Contents[2],
                        ),
                      ],
                    );
                     }
                  }
                case 3: 
                   if (editable && editSubFolderPress != null){
                    if (V4rs.xSmallModeWidth){
                      return Column(children: [
                        Expanded(
                          child: case3Contents,
                        ),
                        Expanded(
                          child: subFolderEditButton()
                        )
                      ]);
                    } else {
                      return Row(children: [
                        Expanded(
                          child: case3Contents,
                        ),
                        Expanded(
                          child: subFolderEditButton()
                        )
                      ]);
                    }
                  } else {
                    return case3Contents;
                  }
                case 4:
                  if (editable && editSubFolderPress != null){
                    if (V4rs.xSmallModeWidth){
                       return Column(children: [
                        Expanded(
                          child: case4Contents,
                        ),
                        Expanded(
                          child: subFolderEditButton()
                        )
                      ]);
                    } else {
                      return Row(children: [
                        Expanded(
                          child: case4Contents,
                        ),
                        Expanded(
                          child: subFolderEditButton()
                        )
                      ]);
                     }
                  } else {
                    return case4Contents;
                  } 
                }
            } (),
            );
            }
          );
        }

        if (editable){
         return Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4, 
            child: button()
          );
        }
        else {
          return Visibility(
            visible: (obj.show ?? true), 
            maintainSize: true, 
            maintainAnimation: true,
            maintainState: true,
            child: button()
          );
        }
      }
    }

//=====: 

class BuildPocketFolder extends StatefulWidget{

    final BoardObjects obj;
    final TTSInterface synth;
    final void Function(BoardObjects board) openBoard;
    final void Function(BoardObjects board) openBoardWithReturn;
    final List<BoardObjects> boards;
    final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;
    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
    final Future<void> Function() initForSS;
    final AudioPlayer playerForSS;

    const BuildPocketFolder({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.openBoard, 
      required this.openBoardWithReturn, 
      required this.boards,
      required this.findBoardById,
      required this.speakSelectSherpaOnnxSynth,
      required this.initForSS,
      required this.playerForSS,
      });
    
    @override
    State<BuildPocketFolder> createState() => _BuildPocketFolderState();
}

class _BuildPocketFolderState extends State<BuildPocketFolder> {
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final findBoardById = widget.findBoardById;
    final boards = widget.boards;
    final openBoard = widget.openBoard;
    final openBoardWithReturn = widget.openBoardWithReturn;
    final synth = widget.synth;
    String linkTo = obj.linkToUUID ?? '';

        //tap action
          Future<void> doTapAction(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.pocketFolderSpeakOnSelect : obj.speakOS) {
            case 1:
              V4rs.changedMWfromButton = true;
              V4rs.message.value = V4rs.message.value + (obj.message ?? '');
              V4rs.changedMWfromButton = false;
              break;
            case 2:
              V4rs.changedMWfromButton = true;
              V4rs.message.value = V4rs.message.value + (obj.message ?? '');
              await V4rs.speakOnSelect(
                obj.label ?? '', 
                V4rs.selectedLanguage.value, 
                synth,
                widget.speakSelectSherpaOnnxSynth,
                widget.initForSS,
                widget.playerForSS,
              );
              V4rs.changedMWfromButton = false;
              break;
            case 3:
              V4rs.changedMWfromButton = true;
              V4rs.message.value = V4rs.message.value + (obj.message ?? '');
              await V4rs.speakOnSelect(
                obj.message ?? '', 
                V4rs.selectedLanguage.value, 
                synth,
                widget.speakSelectSherpaOnnxSynth,
                widget.initForSS,
                widget.playerForSS,
              );
              V4rs.changedMWfromButton = false;
              break;
            }
          }     

          Future<void> doSecondaryTap(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.pocketFolderSpeakOnSelect : obj.speakOS) {
            case 1:
              final board = findBoardById(linkTo, boards);
                if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
              break;
            case 2:
              final board = findBoardById(linkTo, boards);
                if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
              await V4rs.speakOnSelect(
                obj.label ?? '', 
                V4rs.selectedLanguage.value, 
                synth, 
                widget.speakSelectSherpaOnnxSynth,
                widget.initForSS,
                widget.playerForSS,
              );
              break;
            case 3:
              final board = findBoardById(linkTo, boards);
                if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
                }
              await V4rs.speakOnSelect(
                obj.message ?? '', 
                V4rs.selectedLanguage.value, 
                synth,
                widget.speakSelectSherpaOnnxSynth,
                widget.initForSS,
                widget.playerForSS,
              );
              break;
            }
          }
      //
      //button
      //
      return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.2;
      double top = constraints.maxWidth * 0.15;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();
          final now = DateTime.now();
        
        //===: USE LONG TAP :===///
         if (!V4rs.useLongTapOr) {
           if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
            await doTapAction(obj, synth);
            return;
           } else {
            await doSecondaryTap(obj, synth);
            return;
          }

         //===: USE DOUBLE TAP  :===///
         } else {
          if (_lastTapTime != null &&
              now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
            _singleTapTimer?.cancel();
            await doSecondaryTap(obj, synth);
            _lastTapTime = null;
            return;
          }
          _lastTapTime = now;
          _singleTapTimer?.cancel();
          _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
            await doTapAction(obj, synth);
            _lastTapTime = null;
          });

          return;

         }
      },
    child: BoardButtonStyle(
      obj: obj,
      editable: false,
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
        }
      }, 
      ),
        )),
        ),


        //
        //CORNER TAB 
        //
        Positioned(
              top: 2,
              right: 3,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  await doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  await doTapAction(obj, synth);
                }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                   Image.asset('assets/interface_icons/interface_icons/iCornerTabPocketFolder.png'),
                  )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildTypingKey extends StatefulWidget{

    final BoardObjects obj;
    final TTSInterface synth;

    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
    final Future<void> Function() initForSS;
    final AudioPlayer playerForSS;

    const BuildTypingKey({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.speakSelectSherpaOnnxSynth,
      required this.initForSS,
      required this.playerForSS,
      });
    
    @override
    State<BuildTypingKey> createState() => _BuildTypingKeyState();
}

class _BuildTypingKeyState extends State<BuildTypingKey> {
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final synth = widget.synth;

        //tap action
          Future<void> doTapAction(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value.trim() + (obj.message ?? '');
                    V4rs.changedMWfromButton = false;
                    break;
                  case 2:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value.trim() + (obj.message ?? '');
                    await V4rs.speakOnSelect(
                      obj.label ?? '', 
                      V4rs.selectedLanguage.value, 
                      synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    V4rs.changedMWfromButton = false;
                    break;
                  case 3:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value.trim() + (obj.message ?? '');
                    await V4rs.speakOnSelect(
                      obj.message ?? '', 
                      V4rs.selectedLanguage.value, 
                      synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    V4rs.changedMWfromButton = false;
                    break;
                  }
                }     

          Future<void> doSecondaryTap(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    V4rs.changedMWfromButton = false;
                    break;
                  case 2:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(
                      obj.label ?? '', 
                      V4rs.selectedLanguage.value, 
                      synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    V4rs.changedMWfromButton = false;
                    break;
                  case 3:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(
                      obj.message ?? '', 
                      V4rs.selectedLanguage.value, 
                      synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    V4rs.changedMWfromButton = false;
                    break;
                  }
                }

      
      //
      //button
      //
      return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.2;
      double top = constraints.maxWidth * 0.2;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, 
        child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();

          final now = DateTime.now();

            //===: USE LONG TAP :===///
            if (!V4rs.useLongTapOr) {
              if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
                await doTapAction(obj, synth);
                return;
              } else {
                await doSecondaryTap(obj, synth);
                return;
              }

            //===: USE DOUBLE TAP  :===///
          } else {
            if (_lastTapTime != null &&
                now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
              _singleTapTimer?.cancel();
              await doSecondaryTap(obj, synth);
              _lastTapTime = null;
              return;
            }
            _lastTapTime = now;
            _singleTapTimer?.cancel();
            _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
              await doTapAction(obj, synth);
              _lastTapTime = null;
            });

              return;
          }
      },
    child: BoardButtonStyle(
      obj: obj,
      editable: false,
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
        }
      }, 
      ),
        )),
        ),
        //
        //CORNER TAB 
        //
        Positioned(
              top: 0,
              right: 5,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  doTapAction(obj, synth);
                }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true, 
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                     Image.asset('assets/interface_icons/interface_icons/iCornerTabTypingKey.png'),
                )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildAudioTile extends StatefulWidget{

    final BoardObjects obj;
    final TTSInterface synth;

  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

    const BuildAudioTile({
      super.key, 
      required this.obj, 
      required this.synth,

        required this.speakSelectSherpaOnnxSynth,
        required this.initForSS,
        required this.playerForSS,
      });
    
    @override
    State<BuildAudioTile> createState() => _BuildAudioTileState();
}

class _BuildAudioTileState extends State<BuildAudioTile> {
    late AudioPlayer _player;
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    void initState() {
      super.initState();
      _player = AudioPlayer();
    }

    @override
    void dispose() {
      _player.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final synth = widget.synth;

        //tap action
          Future<void> doTapAction(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    await LoadAudio.fromAudio(obj.audioClip);
                    break;
                  case 2:
                    await V4rs.speakOnSelect(
                      obj.label ?? '', 
                      V4rs.selectedLanguage.value, synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    await LoadAudio.fromAudio(obj.audioClip);
                    break;
                  case 3:
                    await V4rs.speakOnSelect(
                      obj.message ?? '', 
                      V4rs.selectedLanguage.value, 
                      synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    await LoadAudio.fromAudio(obj.audioClip);
                    break;
                  }
                }     

          Future<void> doSecondaryTap(
            BoardObjects obj,
            TTSInterface synth,
            ) async {
              setState(() {
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              });
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                  case 1:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    V4rs.changedMWfromButton = false;
                    break;
                  case 2:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(
                      obj.label ?? '', 
                      V4rs.selectedLanguage.value, 
                      synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    V4rs.changedMWfromButton = false;
                    break;
                  case 3:
                    V4rs.changedMWfromButton = true;
                    V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                    await V4rs.speakOnSelect(
                      obj.message ?? '', 
                      V4rs.selectedLanguage.value, 
                      synth,
                      widget.speakSelectSherpaOnnxSynth,
                      widget.initForSS,
                      widget.playerForSS,
                    );
                    V4rs.changedMWfromButton = false;
                    break;
                  }
                }

      
      //
      //button
      //
      return LayoutBuilder(builder: (context, constraints) {
      double side = constraints.maxHeight * 0.3;
      double top = constraints.maxWidth * 0.2;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, 
        child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();

          final now = DateTime.now();

            //===: USE LONG TAP :===///
            if (!V4rs.useLongTapOr) {
              if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
                await doTapAction(obj, synth);
                return;
              } else {
                await doSecondaryTap(obj, synth);
                return;
              }

            //===: USE DOUBLE TAP  :===///
          } else {
            if (_lastTapTime != null &&
                now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
              _singleTapTimer?.cancel();
              await doSecondaryTap(obj, synth);
              _lastTapTime = null;
              return;
            }
            _lastTapTime = now;
            _singleTapTimer?.cancel();
            _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
              await doTapAction(obj, synth);
              _lastTapTime = null;
            });

              return;
          }
      },
    child: BoardButtonStyle(
      obj: obj,
      editable: false,
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
        }
      },
     ),
        )),
        ),
        //
        //CORNER TAB 
        //
        Positioned(
              top: 3,
              right: 5,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  doTapAction(obj, synth);
                }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true, 
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                     Image.asset('assets/interface_icons/interface_icons/iCornerTabAudioTile.png'),
                )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildButtonGrammer extends StatelessWidget{

  final BoardObjects obj;
  final TTSInterface synth;

  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

    const BuildButtonGrammer({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.speakSelectSherpaOnnxSynth,
      required this.initForSS,
      required this.playerForSS,
    });

     @override
    Widget build(BuildContext context) {
      return LayoutBuilder(builder: (context, constraints) {
        double side = constraints.maxHeight * 0.2;
        double top = constraints.maxWidth * 0.2;

        //
        //button
        //
        return Stack(children: [ 
        Positioned.fill(
          child: BoardButtonStyle(
            obj: obj,
            editable: false,
            onPressed: () async {
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
              case 1:
                V4rs.changedMWfromButton = true;
                Gv4rs.grammerFunctions(obj.function ?? '');
                V4rs.changedMWfromButton = false;
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
                break;
              case 2:
                V4rs.changedMWfromButton = true;
                Gv4rs.grammerFunctions(obj.function ?? '');
                await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
                V4rs.changedMWfromButton = false;
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
                break;
              case 3:
                V4rs.changedMWfromButton = true;
                Gv4rs.grammerFunctions(obj.function ?? '');
                await V4rs.speakOnSelect(
                  Gv4rs.lastWord, 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
                V4rs.changedMWfromButton = false;
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
                break;
              }
            },
          )
        ),

        //
        //corner tab
        //
        Positioned(
              top: 5,
              right: 0,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { 
                    switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
                      case 1:
                        V4rs.changedMWfromButton = true;
                        Gv4rs.grammerFunctions(obj.function ?? '');
                        V4rs.changedMWfromButton = false;
                        break;
                      case 2:
                        V4rs.changedMWfromButton = true;
                        Gv4rs.grammerFunctions(obj.function ?? '');
                        V4rs.speakOnSelect(
                          obj.label ?? '', 
                          V4rs.selectedLanguage.value, 
                          synth,
                          speakSelectSherpaOnnxSynth,
                          initForSS,
                          playerForSS,
                        );
                        V4rs.changedMWfromButton = false;
                        break;
                      case 3:
                        V4rs.changedMWfromButton = true;
                        Gv4rs.grammerFunctions(obj.function ?? '');
                        await V4rs.speakOnSelect(
                          Gv4rs.lastWord, 
                          V4rs.selectedLanguage.value, 
                          synth,
                          speakSelectSherpaOnnxSynth,
                          initForSS,
                          playerForSS,
                          );
                        V4rs.changedMWfromButton = false;
                        break;
                      }
                },
                child: Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true,
                  child: Transform.rotate(angle: 190, child:
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                    Image.asset('assets/interface_icons/interface_icons/iCornerTabTypingKey.png'),
                  )
                  )
                )
                )
              ),
        )
        
       ]
      );
    });
    }
  }

class BuildFolder extends StatefulWidget{

  final BoardObjects obj;
  final TTSInterface synth;
  final void Function(BoardObjects board) openBoard;
  final void Function(BoardObjects board) openBoardWithReturn;
  final List<BoardObjects> boards;
  final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

    const BuildFolder({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.openBoard, 
      required this.openBoardWithReturn, 
      required this.boards,
      required this.findBoardById,

        required this.speakSelectSherpaOnnxSynth,
        required this.initForSS,
        required this.playerForSS,
      });
    
    @override
    State<BuildFolder> createState() => _BuildFolderState();
}

class _BuildFolderState extends State<BuildFolder> {
    final Stopwatch _stopwatch = Stopwatch();
    DateTime? _lastTapTime;
    final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
    Timer? _singleTapTimer;

    @override
    Widget build(BuildContext context) {

    final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
    
    final obj = widget.obj;
    final findBoardById = widget.findBoardById;
    final boards = widget.boards;
    final openBoard = widget.openBoard;
    final openBoardWithReturn = widget.openBoardWithReturn;
    final synth = widget.synth;
    String linkTo = obj.linkToUUID ?? '';
      
    //tap action
    Future<void> doTapAction(
      BoardObjects obj,
      TTSInterface synth,
      ) async { 
        setState(() {
          V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
        });
        switch ((obj.matchSpeakOS ?? true) ? Bv4rs.folderSpeakOnSelect : obj.speakOS) {
        case 1:
          final board = findBoardById(linkTo, boards);
            if (board != null) {
            if (obj.returnAfterSelect == true) {
              openBoardWithReturn(board);
            } else {
              openBoard(board);
            }
          }
          break;
        case 2:
          final board = findBoardById(linkTo, boards);
            if (board != null) {
            if (obj.returnAfterSelect == true) {
              openBoardWithReturn(board);
            } else {
              openBoard(board);
            }
          }
          await V4rs.speakOnSelect(
            obj.label ?? '', 
            V4rs.selectedLanguage.value, 
            synth,
            widget.speakSelectSherpaOnnxSynth,
            widget.initForSS,
            widget.playerForSS,
          );
          break;
        case 3:
          final board = findBoardById(linkTo, boards);
            if (board != null) {
            if (obj.returnAfterSelect == true) {
              openBoardWithReturn(board);
            } else {
              openBoard(board);
            }
          }
          await V4rs.speakOnSelect(
            obj.message ?? '', 
            V4rs.selectedLanguage.value, 
            synth,
            widget.speakSelectSherpaOnnxSynth,
            widget.initForSS,
            widget.playerForSS,
          );
          break;
        }
      }
    Future<void> doSecondaryTap(
      BoardObjects obj,
      TTSInterface synth,
      ) async {
        setState(() {
          V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
        });
        switch ((obj.matchSpeakOS ?? true) ? Bv4rs.folderSpeakOnSelect : obj.speakOS) {
        case 1:
          V4rs.changedMWfromButton = true;
          V4rs.message.value = V4rs.message.value + (obj.message ?? '');
          V4rs.changedMWfromButton = false;
          break;
        case 2:
          V4rs.changedMWfromButton = true;
          V4rs.message.value = V4rs.message.value + (obj.message ?? '');
          await V4rs.speakOnSelect(
            obj.label ?? '', 
            V4rs.selectedLanguage.value, 
            synth,
            widget.speakSelectSherpaOnnxSynth,
            widget.initForSS,
            widget.playerForSS,
          );
          V4rs.changedMWfromButton = false;
          break;
        case 3:
          V4rs.changedMWfromButton = true;
          V4rs.message.value = V4rs.message.value + (obj.message ?? '');
          await V4rs.speakOnSelect(
            obj.message ?? '', 
            V4rs.selectedLanguage.value, 
            synth,
            widget.speakSelectSherpaOnnxSynth,
            widget.initForSS,
            widget.playerForSS,
          );
          V4rs.changedMWfromButton = false;
          break;
        }
      }

    //
    //button
    //
    return LayoutBuilder(
      builder: (context, constraints) {
      double side = constraints.maxHeight * 0.3;
      double top = constraints.maxWidth * 0.25;

      return Stack(children: [ 
      Positioned.fill(child: 
      Visibility(
        visible: (obj.show ?? true), 
        maintainSize: true, 
        maintainAnimation: true,
        maintainState: true, child:
       Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _stopwatch..reset()..start(),
        onPointerUp: (_) async {
          _stopwatch.stop();
          final now = DateTime.now();


            //===: USE LONG TAP :===///
            if (!V4rs.useLongTapOr) {
              if (_stopwatch.elapsedMilliseconds < V4rs.longTapDuration) {
                await doTapAction(obj, synth);
                return;
              } else {
                await doSecondaryTap(obj, synth);
                return;
              }

            //===: USE DOUBLE TAP  :===///
          } else {
              if (_lastTapTime != null &&
                  now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
                _singleTapTimer?.cancel();
                await doSecondaryTap(obj, synth);
                _lastTapTime = null;
                return;
              }
              _lastTapTime = now;
              _singleTapTimer?.cancel();
              _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
                await doTapAction(obj, synth);
                _lastTapTime = null;
              });

              return;
        }
      },
    child: BoardButtonStyle(
      obj: obj,
      editable: false,
      onPressed: () async {
        if (altAccessActive) {
          await doTapAction(obj, synth);
          }
        }, 
      ),
      )),
        ),
        //
        //CORNER TAB 
        //
        Positioned(
              top: 0,
              right: 0,
              child: SizedBox(width: top, height: side,
                child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),),
                onPressed: () async { if (altAccessActive) {
                  await doSecondaryTap(obj, synth);
                } else { 
                  //pretend you hit the button
                  await doTapAction(obj, synth);
                }
                },
                child:  Visibility(
                visible: (obj.show ?? true), 
                maintainSize: true, 
                maintainAnimation: true,
                maintainState: true, 
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Cv4rs.cornerTabColor, BlendMode.srcIn
                    ), child:
                   Image.asset('assets/interface_icons/interface_icons/iCornerTabFolder.png'),
                  )
                )
                )
              ),
        )
        ]); 
      });
    }
  }

class BuildButton extends StatelessWidget{
    final BoardObjects obj;
    final TTSInterface synth;
    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
      
    final Future<void> Function() initForSS;
    final AudioPlayer playerForSS;

    const BuildButton({
      super.key, 
      required this.obj, 
      required this.synth,
        required this.speakSelectSherpaOnnxSynth,
        required this.initForSS,
        required this.playerForSS,
    });

    @override
    Widget build(BuildContext context) {
      //
      //button
      //
      return BoardButtonStyle(
        obj: obj,
        editable: false,
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.buttonSpeakOnSelect : obj.speakOS) {
          case 1:
            V4rs.changedMWfromButton = true;
            V4rs.message.value = V4rs.message.value + (obj.message ?? '');
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          case 2:
            V4rs.changedMWfromButton = true;
            V4rs.message.value = V4rs.message.value + (obj.message ?? '');
            await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          case 3:
            V4rs.changedMWfromButton = true;
            V4rs.message.value = V4rs.message.value + (obj.message ?? '');
            await V4rs.speakOnSelect(
                  obj.message ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
            V4rs.changedMWfromButton = false;
            V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
            break;
          }
        },
      );
    }
  }

class BuildSubFolder extends StatelessWidget {

    final BoardObjects obj;
    final TTSInterface synth;

    final void Function() goBack;
    final void Function(BoardObjects board) openBoard;
    final void Function(BoardObjects board) openBoardWithReturn;
    final List<BoardObjects> boards;
    final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

    const BuildSubFolder({
      super.key, 
      required this.obj, 
      required this.synth, 
      required this.goBack, 
      required this.openBoard, 
      required this.openBoardWithReturn, 
      required this.boards,
      required this.findBoardById,

        required this.speakSelectSherpaOnnxSynth,
        required this.initForSS,
        required this.playerForSS,
      });

    @override
  Widget build(BuildContext context) {
    //navigation  
      String linkTo = obj.linkToUUID ?? '';

      //
      //back button
      //
      if (obj.type1 == 'backButton'){
        return BoardButtonStyle(
          isSubFolder: true,
          editable: false,
          obj: obj,
          onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.subFolderSpeakOnSelect : obj.speakOS) {
          case 1:
            goBack();
            break;
          case 2:
            goBack();
            await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
            break;
          case 3:
            goBack();
            await V4rs.speakOnSelect(
                obj.alternateLabel ?? '', 
                V4rs.selectedLanguage.value, 
                synth,
                speakSelectSherpaOnnxSynth,
                initForSS,
                playerForSS,
              );
            break;
          }
        },
        );
      } 

      //
      //sub folders + more
      //
      return BoardButtonStyle(
        isSubFolder: true,
        editable: false,
        obj: obj,
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.subFolderSpeakOnSelect : obj.speakOS) {
            case 1:
              final board = findBoardById(linkTo, boards);
               if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
              }
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              break;
            case 2:
              final board = findBoardById(linkTo, boards);
               if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
              }

              await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              break;
            case 3:
              final board = findBoardById(linkTo, boards);
               if (board != null) {
                  if (obj.returnAfterSelect == true) {
                    openBoardWithReturn(board);
                  } else {
                    openBoard(board);
                  }
              }
              await V4rs.speakOnSelect(
                obj.alternateLabel ?? '', 
                V4rs.selectedLanguage.value, 
                synth,
                speakSelectSherpaOnnxSynth,
                initForSS,
                playerForSS,
              );
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, obj.id);
              break;
            }},
      );
    }
}

//for print
class PreveiwButton extends StatelessWidget{
  
  final BoardObjects obj;

  const PreveiwButton({super.key, required this.obj});

    @override
    Widget build(BuildContext context) {

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
      //
      //button
      //
      return Opacity(
        opacity: (obj.show ?? true) ? 1.0 : 0.0, 
        child: Container(
          decoration: BoxDecoration(
            color: (obj.matchPOS ?? true) 
                ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                : obj.backgroundColor ?? Colors.blueGrey,
            border: Border.all(
              color: (obj.matchBorder ?? true) 
                ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                : obj.borderColor ?? Colors.white,
              width: (obj.matchBorder ?? true) 
                ? Bv4rs.buttonBorderWeight
                : obj.borderWeight ?? 2.5
            ),
            borderRadius: BorderRadius.circular(10),
            ),
            child: () {
          switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
            case 1: 
              return Row(children: [
                Flexible(
                  flex: 2,
                  child: 
                Padding(padding: EdgeInsets.fromLTRB(
                  V4rs.paddingValue(obj.padding ?? 2.0),
                  V4rs.paddingValue((obj.padding ?? 2.0) + 2.0),
                  V4rs.paddingValue(obj.padding ?? 2.0),
                  V4rs.paddingValue(obj.padding ?? 2.0),
                ), 
                child:
                theSymbol,
                ),
                ),
                Flexible(
                  flex: 5, 
                  child:
                Padding(
                padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
                theLabel,
                ),
                ),
              ],
            );
            case 2: 
              return Row(children: [
                Flexible( flex: 5, child:
                Padding(
                padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
                theLabel,
                ),
                ),
                Flexible(
                  flex: 2,
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
            ],
            );
            case 3: 
              return Padding(
                padding: EdgeInsets.all(V4rs.paddingValue(obj.padding ?? 2.0)), child:
                theSymbol,
              );
            case 4:
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
              theLabel2);
          }
        } (),
          ),

      );
    }
}

//
//nav row buttons 
//

class NavButtonStyle extends StatelessWidget {
  final NavObjects? me;
  final String label;
  final String symbol;
  final TTSInterface tts;
  final void Function(BoardObjects board) openBoard;
  final List<BoardObjects> boards;
  final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

  final String linkToLabel;
  final String linkToUUID;

  final bool show;
  final bool matchFormat;
  final int format;

  final String pos;
  final bool matchPOS;
  final Color backgroundColor;

  final bool matchBorder;
  final double borderWeight;
  final Color borderColor;

  final bool matchFont;
  final String fontFamily;
  final double fontSize;
  final int fontWeight;
  final bool fontItalics;
  final bool fontUnderline;
  final Color fontColor;

  final double padding;
  final bool matchOverlayColor;
  final Color overlayColor;
  final double symbolSaturation;
  final double symbolContrast;
  final bool invertSymbolColors;
  final bool matchSymbolContrast;
  final bool matchSymbolInvert;
  final bool matchSymbolSaturation;

  final bool matchSpeakOS;
  final int speakOS;
  final String alternateLabel;

  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  final String note;

  TextStyle get labelStyle =>  
    TextStyle(
      color: fontColor,
      fontSize: V4rs.fontValue(fontSize),
      fontFamily: Fontsy.fontToFamily[fontFamily], 
      fontWeight: FontWeight.values[((fontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: fontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: fontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

  //constructs the button 
  const NavButtonStyle ({
    super.key,
    this.symbol = 'assets/interface_icons/interface_icons/iPlaceholder.png',
    required this.tts,
    required this.openBoard,
    required this.boards,
    required this.findBoardById,
    required this.me,
    this.label = '',
    this.linkToLabel = '',
    this.linkToUUID = '',
    this.show = true,
    this.matchFormat = true,
    this.format = 1,
    this.pos = 'Extra 1',
    this.matchPOS = true,
    this.backgroundColor = Colors.white,
    this.matchBorder = true,
    this.borderWeight = 0,
    this.borderColor = Colors.black,
    this.matchFont = true,
    this.fontFamily = 'Default',
    this.fontSize = 16,
    this.fontWeight = 400,
    this.fontItalics = false,
    this.fontUnderline = false,
    this.fontColor = Colors.black,
    this.padding = 5,
    this.matchOverlayColor = true,
    this.overlayColor = Colors.red,
    this.symbolSaturation = 1.0,
    this.symbolContrast = 1.0,
    this.invertSymbolColors = false,
    this.matchSpeakOS = true,
    this.speakOS = 1,
    this.alternateLabel = '',
    this.note = '',
    this.matchSymbolContrast = true,
    this.matchSymbolSaturation = true,
    this.matchSymbolInvert = true,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });




  //defines the button 
  @override
  Widget build(BuildContext context) {
    
    //image
     Widget image = LoadImage.fromSymbol(symbol);

    return Visibility (
      visible: (Bv4rs.showNavRow == 2) ? false : show,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: ValueListenableBuilder(valueListenable: V4rs.searchPathUUIDS, builder: (context, search, _) {
      
   return ElevatedButton(
        onPressed: () {
        switch (matchSpeakOS ? Bv4rs.navRowSpeakOnSelect : speakOS) {
          case 1:
              if (me != null){
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
              }
              final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
                FocusScope.of(context).unfocus();
              }
              
            break;
          case 2:
              if (me != null){
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
              }
            final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
                FocusScope.of(context).unfocus();
              }
            V4rs.speakOnSelect(
              label, 
              V4rs.selectedLanguage.value, 
              tts,
              speakSelectSherpaOnnxSynth,
              initForSS,
              playerForSS,
              );
            break;
          case 3:
            if (me != null){
                V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
              }

            final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
                FocusScope.of(context).unfocus();
              }
            V4rs.speakOnSelect(
              alternateLabel, 
              V4rs.selectedLanguage.value, 
              tts,
              speakSelectSherpaOnnxSynth,
              initForSS,
              playerForSS,
              );
            break;
          }},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: V4rs.paddingValue(5), 
            vertical: V4rs.paddingValue(2)
          ),
          backgroundColor: (V4rs.isSearchPathNav(V4rs.searchPathUUIDS.value, me)) 
          ? Cv4rs.posToBorderColor(pos)
          : matchPOS
            ? Cv4rs.posToColor(pos) 
            : backgroundColor, 
          elevation: 2,
          shadowColor: Cv4rs.themeColor4, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: matchBorder ? Cv4rs.posToBorderColor(pos) : borderColor, 
              width: matchBorder ? Bv4rs.navRowBorderWeight : borderWeight,
              ), 
          ),
        ),
        child: () {
        switch (matchFormat ? Bv4rs.navButtonFormat : format){
          
          //
          //text below
          //

          case 1: 
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //image
                Flexible( child:
                Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                ),

                //label
                Text(
                  label, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                  textAlign: TextAlign.center, 
                ),
              ]
            );

          //
          //text above
          //

          case 2: 
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //label 
                Text(
                  label, 
                  maxLines: 1,  
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                  overflow: TextOverflow.ellipsis, 
                  textAlign: TextAlign.center, 
                ),

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                     image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                 ),
              ]
            );
          
          //
          //image only
          //

          case 3:
            return SizedBox.expand(
              child: Center( child:
            Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
            )
              )
                );
         
          //
          //text only
          //
          
          case 4:
            return SizedBox.expand(child: Center( child:
            Text(
                  label, maxLines: 3,  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, textAlign: TextAlign.center,   overflow: TextOverflow.ellipsis, 
            ),
            ),
            );
          
          //
          //oops
          //

          default:
            return Text(
                  'error (1366572)', style: Sv4rs.settingslabelStyle, 
                );
        } 
  } (),
    ); 
  })
  );
      
  }
}

class StorageButtonStyle extends StatelessWidget {
  final VoidCallback onPressed; 
  final String label;
  final String symbol;
  final TTSInterface tts;

  final String linkToLabel;
  final String linkToUUID;

  final int showOr;
  final bool matchFormat;
  final int format;

  final String pos;
  final bool matchPOS;
  final Color backgroundColor;

  final bool matchBorder;
  final double borderWeight;
  final Color borderColor;

  final bool matchFont;
  final String fontFamily;
  final double fontSize;
  final int fontWeight;
  final bool fontItalics;
  final bool fontUnderline;
  final Color fontColor;

  final double padding;
  final bool matchOverlayColor;
  final Color overlayColor;
  final double symbolSaturation;
  final double symbolContrast;
  final bool invertSymbolColors;
  final bool matchSymbolContrast;
  final bool matchSymbolInvert;
  final bool matchSymbolSaturation;

  final bool matchSpeakOS;
  final int speakOS;
  final String alternateLabel;

  final String note;

  TextStyle get labelStyle =>  
    TextStyle(
      color: fontColor,
      fontSize: fontSize,
      fontFamily: Fontsy.fontToFamily[fontFamily], 
      fontWeight: FontWeight.values[((fontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: fontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: fontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

  const StorageButtonStyle ({
    super.key,
    required this.onPressed,
    this.symbol = 'assets/interface_icons/interface_icons/iPlaceholder.png',
    required this.tts,
    this.label = '',
    this.linkToLabel = '',
    this.linkToUUID = '',
    this.showOr = 1,
    this.matchFormat = true,
    this.format = 1,
    this.pos = 'Extra 1',
    this.matchPOS = true,
    this.backgroundColor = Colors.white,
    this.matchBorder = true,
    this.borderWeight = 0,
    this.borderColor = Colors.black,
    this.matchFont = true,
    this.fontFamily = 'Default',
    this.fontSize = 16,
    this.fontWeight = 400,
    this.fontItalics = false,
    this.fontUnderline = false,
    this.fontColor = Colors.black,
    this.padding = 5,
    this.matchOverlayColor = true,
    this.overlayColor = Colors.red,
    this.symbolSaturation = 1.0,
    this.symbolContrast = 1.0,
    this.invertSymbolColors = false,
    this.matchSpeakOS = true,
    this.speakOS = 1,
    this.alternateLabel = '',
    this.note = '',
    this.matchSymbolContrast = true,
    this.matchSymbolSaturation = true,
    this.matchSymbolInvert = true,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget image = ((symbol).startsWith('/')) ? 
        Image.file(
          File(symbol),
        )
       : Image.asset(
          symbol,
          fit: BoxFit.contain,
        );

    return Visibility (
      visible: V4rs.showOrAsBool(showOr),
      maintainAnimation: true,
      maintainSize: true,
      maintainState: true,
      child:
    ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: V4rs.paddingValue(5), 
            vertical: V4rs.paddingValue(2)
          ),
          backgroundColor: matchPOS ? Cv4rs.posToColor(pos) : backgroundColor, 
          elevation: 2,
          shadowColor: Cv4rs.themeColor4, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: matchBorder ? Cv4rs.posToBorderColor(pos) : borderColor, 
              width: matchBorder ? Bv4rs.navRowBorderWeight : borderWeight,
              ), 
          ),
        ),
        child: () {
        switch (matchFormat ? Bv4rs.centerButtonFormat: format){
          
          //
          //text below
          //

          case 1: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                ),

                //label
                Text(
                  label, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis, 
                  textAlign: TextAlign.center, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                ),
              ]
            );

          //
          //text above
          //

          case 2: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //label 
                Text(
                  label, maxLines: 1,  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  textAlign: TextAlign.center,   overflow: TextOverflow.ellipsis, 
                ),

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: 
                  ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                 ),
                ),
              ]
            );
          
          //
          //image only
          //

          case 3:
            return Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                );
         
          //
          //text only
          //
          
          case 4:
            return Text(
                  label, maxLines: 3, style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  textAlign: TextAlign.center,   overflow: TextOverflow.ellipsis, 
                );
          
          //
          //oops
          //

          default:
            return Text(
                  'error (1366572)', style: Sv4rs.settingslabelStyle, 
                );
        } 
  } (),
    ),  
      );
  }
}

class SpecialNavButtonStyle extends StatelessWidget {
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;
  final VoidCallback onPressed; 
  final String label;
  final String symbol;
  final TTSInterface tts;

  final String linkToLabel;
  final String linkToUUID;

  final int showOr;
  final bool matchFormat;
  final int format;

  final String pos;
  final bool matchPOS;
  final Color backgroundColor;

  final bool matchBorder;
  final double borderWeight;
  final Color borderColor;

  final bool matchFont;
  final String fontFamily;
  final double fontSize;
  final int fontWeight;
  final bool fontItalics;
  final bool fontUnderline;
  final Color fontColor;

  final double padding;
  final bool matchOverlayColor;
  final Color overlayColor;
  final double symbolSaturation;
  final double symbolContrast;
  final bool invertSymbolColors;
  final bool matchSymbolContrast;
  final bool matchSymbolInvert;
  final bool matchSymbolSaturation;

  final bool matchSpeakOS;
  final int speakOS;
  final String alternateLabel;

  final String note;
  final NavObjects? me;

  TextStyle get labelStyle =>  
    TextStyle(
      color: fontColor,
      fontSize: fontSize,
      fontFamily: Fontsy.fontToFamily[fontFamily], 
      fontWeight: FontWeight.values[((fontWeight ~/ 100) - 1 ).clamp(0, 8)],
      fontStyle: fontItalics ? FontStyle.italic : FontStyle.normal,
      decoration: fontUnderline ? TextDecoration.underline : TextDecoration.none,
    );

  const SpecialNavButtonStyle ({
    super.key,
    required this.onPressed,
    this.symbol = 'assets/interface_icons/interface_icons/iPlaceholder.png',
    required this.tts,
    required this.me,
    this.label = '',
    this.linkToLabel = '',
    this.linkToUUID = '',
    this.showOr = 1,
    this.matchFormat = true,
    this.format = 1,
    this.pos = 'Extra 1',
    this.matchPOS = true,
    this.backgroundColor = Colors.white,
    this.matchBorder = true,
    this.borderWeight = 0.0,
    this.borderColor = Colors.black,
    this.matchFont = true,
    this.fontFamily = 'Default',
    this.fontSize = 16,
    this.fontWeight = 400,
    this.fontItalics = false,
    this.fontUnderline = false,
    this.fontColor = Colors.black,
    this.padding = 5,
    this.matchOverlayColor = true,
    this.overlayColor = Colors.red,
    this.symbolSaturation = 1.0,
    this.symbolContrast = 1.0,
    this.invertSymbolColors = false,
    this.matchSpeakOS = true,
    this.speakOS = 1,
    this.alternateLabel = '',
    this.note = '',
    this.matchSymbolContrast = true,
    this.matchSymbolSaturation = true,
    this.matchSymbolInvert = true,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });

  @override
  Widget build(BuildContext context) {
    
    Widget image = ((symbol).startsWith('/')) ? 
        Image.file(
          File(symbol),
        )
       : Image.asset(
          symbol,
          fit: BoxFit.contain,
        );

    return Visibility (
      visible: (Bv4rs.showNavRow == 2) ? false : V4rs.showOrAsBool(showOr),
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child:
    ElevatedButton(
        onPressed:  () {
        switch (matchSpeakOS ? Bv4rs.navRowSpeakOnSelect : speakOS) {
          case 1:
            //add navigation link to
            FocusScope.of(context).unfocus();
            if (me != null){
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
            }
            break;
          case 2:
            //add navigation link to
            FocusScope.of(context).unfocus();
            if (me != null){
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
            }
            V4rs.speakOnSelect(
              label, 
              V4rs.selectedLanguage.value, 
              tts,
              speakSelectSherpaOnnxSynth,
              initForSS,
              playerForSS,
            );
            break;
          case 3:
            //add navigation link to
            FocusScope.of(context).unfocus();
            if (me != null){
              V4rs.updateSearchPath(V4rs.searchPathUUIDS.value, me!.linkToUUID ?? '');
            }
            V4rs.speakOnSelect(
              alternateLabel, 
              V4rs.selectedLanguage.value, 
              tts,
              speakSelectSherpaOnnxSynth,
              initForSS,
              playerForSS,
            );
            break;
          }},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: V4rs.paddingValue(5), 
            vertical: V4rs.paddingValue(2)
          ),
          backgroundColor: (V4rs.isSearchPathNav(V4rs.searchPathUUIDS.value, me)) 
            ? Cv4rs.posToBorderColor(pos)
            : matchPOS 
              ? Cv4rs.posToColor(pos) 
              : backgroundColor, 
          elevation: 2,
          shadowColor: Cv4rs.themeColor4, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: matchBorder ? Cv4rs.posToBorderColor(pos) : borderColor, 
              width: matchBorder ? Bv4rs.navRowBorderWeight : borderWeight,
              ), 
          ),
        ),
        child: () {
        switch (matchFormat ? Bv4rs.centerButtonFormat : format){
          
          //
          //text below
          //

          case 1: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //image
                Expanded(child: 
                Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                  ),
                ),

                //label
                Text(
                  label, maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  textAlign: TextAlign.center, 
                ),
              ]
            );

          //
          //text above
          //

          case 2: 
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //label 
                Text(
                  label, maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, textAlign: TextAlign.center, 
                ),

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                ),
                ),
              ]
            );
          
          //
          //image only
          //

          case 3:
            return Padding(
                  padding: EdgeInsets.all(V4rs.paddingValue(padding)),
                  child: ImageStyle1(
                    image: image, 
                    matchSymbolSaturation: matchSymbolSaturation,
                    symbolSaturation: symbolSaturation, 
                    matchSymbolContrast: matchSymbolContrast,
                    symbolContrast: symbolContrast, 
                    matchSymbolInvert: matchSymbolInvert,
                    invertSymbolColors: invertSymbolColors, 
                    matchOverlayColor: matchOverlayColor, 
                    overlayColor: overlayColor, 
                    defaultSymbolInvert: Bv4rs.navRowSymbolInvert,
                    defaultSymbolSaturation: Bv4rs.navRowSymbolSaturation,
                    defaultSymbolContrast: Bv4rs.navRowSymbolContrast,
                    defaultSymbolColorOverlay: Bv4rs.navRowSymbolColorOverlay)
                );
         
          //
          //text only
          //
          
          case 4:
            return Text(
                  label, maxLines: 3, style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle,  
                  textAlign: TextAlign.center, 
                  overflow: TextOverflow.ellipsis, 
                );
          
          //
          //oops
          //

          default:
            return Text(
                  'error (1366572)', style: Sv4rs.settingslabelStyle, 
                );
        } 
  } (),
    ),  
      );
  }
}

//
//gramer row buttons
//

class GrammerButtonStyle extends StatelessWidget{
      final GrammerObjects obj;
      final void Function()? onPressed;
      final bool editable;
      
      const GrammerButtonStyle({
        super.key, 
        required this.obj, 
        required this.onPressed,
        required this.editable,
      });


      @override
      Widget build(BuildContext context) {
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
          color: Fv4rs.grammerFontColor,
          fontSize: V4rs.fontValue(Fv4rs.grammerFontSize),
          fontFamily: Fontsy.fontToFamily[Fv4rs.grammerFont], 
          fontWeight: FontWeight.values[((Fv4rs.grammerFontWeight ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: Fv4rs.grammerFontItalics ? FontStyle.italic : FontStyle.normal,
          decoration: Fv4rs.grammerFontUnderline ? TextDecoration.underline : TextDecoration.none,
        );

      //label
        Widget theLabel = 
        Text(obj.label ?? "", 
          textAlign: TextAlign.center,
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          );
        Text theLabel2 = 
        Text(obj.label ?? "", 
          textAlign: TextAlign.center,
          style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
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
            defaultSymbolColorOverlay: Bv4rs.grammerRowSymbolColorOverlay, 
            matchSymbolContrast: obj.matchSymbolContrast ?? true, 
            matchSymbolInvert: obj.matchInvertSymbol ?? true, 
            matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
            defaultSymbolInvert: Bv4rs.grammerRowSymbolInvert, 
            defaultSymbolContrast: Bv4rs.grammerRowSymbolContrast, 
            defaultSymbolSaturation: Bv4rs.grammerRowSymbolSaturation
            );

          //
          //button
          //
          return ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                elevation: 0,
                backgroundColor: 
                  (editable)
                  ? (Ev4rs.firstGrammerSelectedUUID.value == obj.id || Ev4rs.secondGrammerSelectedUUID.value == obj.id
                    || Ev4rs.grammerSelectedUUIDs.value.contains(obj.id)) 
                    ? Cv4rs.themeColor3
                    : obj.backgroundColor ?? Colors.transparent
                  : obj.backgroundColor ?? Colors.transparent,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                )
              ),
              child: () {
              switch((obj.matchFormat ?? true) ? Bv4rs.grammerRowFormat : obj.format) {
                case 1: 
                  final children = <Widget> [
                    (obj.symbol != null) ?
                    Flexible(flex: 4, child: 
                    Padding(padding: EdgeInsets.fromLTRB(
                      V4rs.paddingValue(obj.padding ?? 2.0),
                      V4rs.paddingValue((obj.padding ?? 2.0) + 2.0),
                      V4rs.paddingValue(obj.padding ?? 2.0),
                      V4rs.paddingValue(obj.padding ?? 2.0),), 
                    child:
                    theSymbol,
                    ),
                    ) : SizedBox.shrink(),
                    Flexible(flex: 7,
                      child: 
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
                    theLabel,
                    ),
                    ),
                  ];

                  if (!V4rs.xSmallModeWidth) { 
                    return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children);
                  } else {
                    return Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: children);
                  }
                  
                case 2:
                  final children = <Widget> [
                    Expanded(flex: 7, child: 
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
                    theLabel,
                    ),
                    ),
                    (obj.symbol != null) ?
                    Flexible(flex: 4, child: 
                    Padding(padding: EdgeInsets.fromLTRB(
                      V4rs.paddingValue(obj.padding ?? 2.0),
                      V4rs.paddingValue((obj.padding ?? 2.0) + 2.0),
                      V4rs.paddingValue(obj.padding ?? 2.0),
                      V4rs.paddingValue(obj.padding ?? 2.0),), 
                    child:
                      theSymbol,
                    ),
                    ) : SizedBox.shrink(),
                  ];
                  if (!V4rs.xSmallModeWidth) { 
                    return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children);
                  } else {
                    return Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: children);
                  }
                case 3: 
                  return (obj.symbol != null) ? Padding(
                    padding: EdgeInsets.all(V4rs.paddingValue(obj.padding ?? 2.0)), child:
                    theSymbol,
                  ) : SizedBox.shrink();
                case 4:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Expanded(child: 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5)), child:
                  theLabel2
                  )
                    )
                  ]
                  );
              }
            } (),
            );
        
      }
    }

//=====: 

class BuildGrammerButton extends StatelessWidget{

    final GrammerObjects obj;
    final TTSInterface synth;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

    const BuildGrammerButton({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.speakSelectSherpaOnnxSynth,
      required this.initForSS,
      required this.playerForSS,
    });

     @override
    Widget build(BuildContext context) {

    
      //
      //button
      //
      return GrammerButtonStyle(
        obj: obj,
        editable: false,
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
          case 1:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            V4rs.changedMWfromButton = false;
            break;
          case 2:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
            V4rs.changedMWfromButton = false;
            break;
          case 3:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(
              Gv4rs.lastWord, 
              V4rs.selectedLanguage.value, 
              synth,
              speakSelectSherpaOnnxSynth,
              initForSS,
              playerForSS,
              );
            V4rs.changedMWfromButton = false;
            break;
          }
        },
       );
    }
  }

class BuildGrammerFolder extends StatelessWidget{

    final GrammerObjects obj;
    final TTSInterface synth;

    final void Function(BoardObjects board) openBoard;
    final List<BoardObjects> boards;
    final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;
    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
    final Future<void> Function() initForSS;
    final AudioPlayer playerForSS;

    const BuildGrammerFolder({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.openBoard, 
      required this.boards,
      required this.findBoardById,
      required this.speakSelectSherpaOnnxSynth,
      required this.initForSS,
      required this.playerForSS,
    });

     @override
    Widget build(BuildContext context) {

      //
      //button
      //
      return GrammerButtonStyle(
        obj: obj,
        editable: false,
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
          case 1:
             final board = findBoardById((obj.openUUID ?? ''), boards);
              if (board != null) {
                openBoard(board);
              }
            break;
          case 2:
             final board = findBoardById(obj.openUUID ?? '', boards);
              if (board != null) {
                openBoard(board);
              }
            await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
            break;
          case 3:
             final board = findBoardById(obj.openUUID ?? '', boards);
              if (board != null) {
                openBoard(board);
              }
            if (Bv4rs.folderSpeakOnSelect != 1) {
            await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
            }
            break;
          }
        },
        
      );
    }
  }

class BuildGrammerPlacholder extends StatelessWidget{

    final GrammerObjects obj;
    final TTSInterface synth;
    final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
    final Future<void> Function() initForSS;
    final AudioPlayer playerForSS;

    const BuildGrammerPlacholder({
      super.key, 
      required this.obj, 
      required this.synth,
      required this.speakSelectSherpaOnnxSynth,
      required this.initForSS,
      required this.playerForSS,
      });

    @override
    Widget build(BuildContext context) {

      //
      //button
      //
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 0,
            backgroundColor: obj.backgroundColor ?? Colors.transparent,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, 
            )
          ),
        onPressed: () async {
          switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
          case 1:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            V4rs.changedMWfromButton = false;
            break;
          case 2:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  speakSelectSherpaOnnxSynth,
                  initForSS,
                  playerForSS,
                );
            V4rs.changedMWfromButton = false;
            break;
          case 3:
            V4rs.changedMWfromButton = true;
            Gv4rs.grammerFunctions(obj.function ?? '');
            await V4rs.speakOnSelect(
              Gv4rs.lastWord, 
              V4rs.selectedLanguage.value, 
              synth,
              speakSelectSherpaOnnxSynth,
              initForSS,
              playerForSS,
              );
            V4rs.changedMWfromButton = false;
            break;
          }
        },
        child: () {
          return Row(children: [
            Spacer(),
          ]
          );
           } (),
        );
    }
  }

