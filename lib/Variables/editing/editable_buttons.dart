
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/fonts.dart';
import 'package:flutterkeysaac/Variables/more_font_variables.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/settings_variable.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/grammer_variables.dart';
import 'dart:async';

//
//for boards
//

  //
  //main buttons
  //

    class BuildEditableButton extends StatefulWidget{
      final BoardObjects obj;
      final TTSInterface synth;
      final Root root;

      const BuildEditableButton({super.key, required this.obj, required this.synth, required this.root});

      @override
      State<BuildEditableButton> createState() => _BuildEditableButton();

    }

    class _BuildEditableButton extends State<BuildEditableButton>{
        @override
        Widget build(BuildContext context) {

        final obj = widget.obj;

        //font settings
            TextStyle uniqueStyle =  
            TextStyle(
              color: obj.fontColor ?? Colors.black,
              fontSize: obj.fontSize ?? 16,
              fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
              fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
              fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
              decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
            );

            TextStyle matchStyle =  
            TextStyle(
              color: Fv4rs.buttonFontColor,
              fontSize: Fv4rs.buttonFontSize,
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
                overlayColor: obj.overlayColor ?? Colors.white,

                matchOverlayColor: obj.matchOverlayColor ?? true, 
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
          return ValueListenableBuilder(
            valueListenable: Ev4rs.selectedUUIDs, 
            builder: (context, selected, _){
          return Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4, 
            child:
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  elevation: 2,
                  backgroundColor: 
                    (Ev4rs.firstSelectedUUID.value == obj.id || Ev4rs.secondSelectedUUID.value == obj.id
                    || Ev4rs.selectedUUIDs.value.contains(obj.id) || Ev4rs.selectedUUIDs.value.contains(obj.id)) 
                    ? (obj.matchPOS ?? true) 
                      ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                      : obj.borderColor ?? Colors.blueGrey
                    : (obj.matchPOS ?? true) 
                      ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                      : obj.backgroundColor ?? Colors.blueGrey,
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
            onPressed: ()  {
              setState(() {
              Ev4rs.selectingAction2(obj, widget.root);
              });
            },
            child: () {
              switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
                case 1: 
                  return Column(children: [
                    Flexible(child: 
                    Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                    child:
                    theSymbol,
                    ),
                    ),
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                    theLabel,
                    ),
                  ],
                );
                case 2: 
                  return Column(children: [
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                    theLabel,
                    ),
                    Flexible(child: 
                    Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                    child:
                      theSymbol,
                    ),
                    ),
                ],
                );
                case 3: 
                  return Padding(
                    padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                    theSymbol,
                  );
                case 4:
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                  theLabel2);
              }
            } (),
            )
          );
        }
        );
        }
      }

    class BuildEditablePocketFolder extends StatefulWidget{

        final BoardObjects obj;
        final Root root;
        final TTSInterface synth;
        final void Function(BoardObjects board) openBoard;
        final List<BoardObjects> boards;
        final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

        const BuildEditablePocketFolder({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.openBoard, 
          required this.boards,
          required this.findBoardById,
          required this.root,
          });
        
        @override
        State<BuildEditablePocketFolder> createState() => _BuildEditablePocketFolderState();
    }

    class _BuildEditablePocketFolderState extends State<BuildEditablePocketFolder> {
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
        final synth = widget.synth;
        String linkTo = obj.linkToUUID ?? '';

        //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: Fv4rs.buttonFontSize,
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

            //tap action
              Future<void> doTapAction(BoardObjects obj) async {
                setState(() {
                Ev4rs.selectingAction2(obj, widget.root);
                });
              }   

              Future<void> doSecondaryTap(
                BoardObjects obj,
                ) async {
                switch ((obj.matchSpeakOS ?? true) ? Bv4rs.pocketFolderSpeakOnSelect : obj.speakOS) {
                case 1:
                  final board = findBoardById(linkTo, boards);
                    if (board != null) {
                      openBoard(board);
                    }
                  break;
                case 2:
                  final board = findBoardById(linkTo, boards);
                    if (board != null) {
                      openBoard(board);
                    }
                  await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                  break;
                case 3:
                  final board = findBoardById(linkTo, boards);
                    if (board != null) {
                      openBoard(board);
                    }
                  await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
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
          Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4,  
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
                await doTapAction(obj);
                return;
              } else {
                await doSecondaryTap(obj);
                return;
              }

            //===: USE DOUBLE TAP  :===///
            } else {
              if (_lastTapTime != null &&
                  now.difference(_lastTapTime!) <= _doubleTapMaxDelay) {
                _singleTapTimer?.cancel();
                await doSecondaryTap(obj);
                _lastTapTime = null;
                return;
              }
              _lastTapTime = now;
              _singleTapTimer?.cancel();
              _singleTapTimer = Timer(_doubleTapMaxDelay, () async {
                await doTapAction(obj);
                _lastTapTime = null;
              });

              return;

            }
          },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 2,
            backgroundColor: 
              (Ev4rs.firstSelectedUUID.value == obj.id || Ev4rs.secondSelectedUUID.value == obj.id
                    || Ev4rs.selectedUUIDs.value.contains(obj.id) || Ev4rs.selectedUUIDs.value.contains(obj.id))
                ? (obj.matchPOS ?? true) 
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                  : obj.borderColor ?? Colors.blueGrey
                : (obj.matchPOS ?? true) 
                  ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                  : obj.backgroundColor ?? Colors.blueGrey,
            shadowColor: Cv4rs.themeColor4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true)
                    ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                    : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true)
                    ? Bv4rs.buttonBorderWeight
                    : obj.borderWeight ?? 2.5,
              ),
            ),
          ),
          onPressed: () async {
            if (altAccessActive) {
              await doTapAction(obj);
            }
          }, 
          child: () {
            switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
              case 1:
                return Stack(children: [
                  Column(children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          obj.padding ?? 2.0,
                          (obj.padding ?? 2.0) + 2.0,
                          obj.padding ?? 2.0,
                          obj.padding ?? 2.0,
                        ),
                        child: theSymbol,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ),
                  ]),
                ]);
              case 2:
                return Stack(children: [
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ), 
                    Flexible(child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        (obj.padding ?? 2.0) + 2.0,
                      ),
                      child: theSymbol,
                    ),
                    ),
                  ]),
                ]);
              case 3:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.all(obj.padding ?? 2.0),
                    child: theSymbol,
                  ),
                ]);
              case 4:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: theLabel2,
                  ),
                ]);
              default:
                return SizedBox.shrink();
                }
              }(),
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
                      await doSecondaryTap(obj);
                    } else { 
                      //pretend you hit the button
                      await doTapAction(obj);
                    }
                    },
                    child: Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4,  
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

    class BuildEditableTypingKey extends StatefulWidget{
        final Root root;
        final BoardObjects obj;
        final TTSInterface synth;

        const BuildEditableTypingKey({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.root,
          });
        
        @override
        State<BuildEditableTypingKey> createState() => _BuildEditableTypingKeyState();
    }

    class _BuildEditableTypingKeyState extends State<BuildEditableTypingKey> {
        final Stopwatch _stopwatch = Stopwatch();
        DateTime? _lastTapTime;
        final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
        Timer? _singleTapTimer;

        @override
        Widget build(BuildContext context) {

        final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
        
        final obj = widget.obj;
        final synth = widget.synth;

        //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: Fv4rs.buttonFontSize,
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

            //tap action
              Future<void> doTapAction(
                BoardObjects obj,
                TTSInterface synth,
                ) async {
                setState(() {
                Ev4rs.selectingAction2(obj, widget.root);
                });
              }     

              Future<void> doSecondaryTap(
                BoardObjects obj,
                TTSInterface synth,
                ) async {
                switch ((obj.matchSpeakOS ?? true) ? Bv4rs.typingKeySpeakOnSelect : obj.speakOS) {
                      case 1:
                        V4rs.changedMWfromButton = true;
                        V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                        V4rs.changedMWfromButton = false;
                        break;
                      case 2:
                        V4rs.changedMWfromButton = true;
                        V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                        await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                        V4rs.changedMWfromButton = false;
                        break;
                      case 3:
                        V4rs.changedMWfromButton = true;
                        V4rs.message.value = V4rs.message.value + (obj.message ?? '');
                        await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
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
          Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4,  
            child:
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _stopwatch..reset()..start(),
            onPointerUp: (_) async {
              _stopwatch.stop();

              final now = DateTime.now();

              if (!V4rs.useLongTapOr) {

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
            }
          },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 2,
            backgroundColor: 
              (Ev4rs.firstSelectedUUID.value == obj.id || Ev4rs.secondSelectedUUID.value == obj.id
                    || Ev4rs.selectedUUIDs.value.contains(obj.id) || Ev4rs.selectedUUIDs.value.contains(obj.id))
                  ? (obj.matchPOS ?? true) 
                    ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                    : obj.borderColor ?? Colors.blueGrey
                  : (obj.matchPOS ?? true) 
                    ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                    : obj.backgroundColor ?? Colors.blueGrey,
            shadowColor: Cv4rs.themeColor4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true)
                    ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                    : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true)
                    ? Bv4rs.buttonBorderWeight
                    : obj.borderWeight ?? 2.5,
              ),
            ),
          ),
          onPressed: () async {
            if (altAccessActive) {
              await doTapAction(obj, synth);
            }
          },
          child: () {
            switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
              case 1:
                //text below
                return Stack(children: [
                  Column(children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          obj.padding ?? 2.0,
                          (obj.padding ?? 2.0) + 2.0,
                          obj.padding ?? 2.0,
                          obj.padding ?? 2.0,
                        ),
                        child: theSymbol,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ),
                  ]),
                ]);

              //text above 
              case 2:
                return Stack(children: [
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ), 
                    Flexible(child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        (obj.padding ?? 2.0) + 2.0,
                      ),
                      child: theSymbol,
                    ),
                    ),
                  ]),
                ]);
              
              //symbol only 
              case 3:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.all(obj.padding ?? 2.0),
                    child: theSymbol,
                  ),
                ]);

              //label only
              case 4:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: theLabel2,
                  ),
                ]);
              
              //fallback
              default:
                return SizedBox.shrink();
                }
              }(),
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
                    child: Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4,  
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

    class BuildEditableAudioTile extends StatefulWidget{
        final Root root;
        final BoardObjects obj;
        final TTSInterface synth;

        const BuildEditableAudioTile({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.root,
          });
        
        @override
        State<BuildEditableAudioTile> createState() => _BuildEditableAudioTileState();
    }

    class _BuildEditableAudioTileState extends State<BuildEditableAudioTile> {
        final Stopwatch _stopwatch = Stopwatch();
        DateTime? _lastTapTime;
        final Duration _doubleTapMaxDelay = Duration(milliseconds: (V4rs.doubleTapClickSpeed));
        Timer? _singleTapTimer;

        @override
        Widget build(BuildContext context) {

        final bool altAccessActive = MediaQuery.of(context).accessibleNavigation;
        
        final obj = widget.obj;
        final synth = widget.synth;

        //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: Fv4rs.buttonFontSize,
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

            //tap action
              Future<void> doTapAction(
                BoardObjects obj,
                TTSInterface synth,
                ) async {
                setState(() {
                Ev4rs.selectingAction2(obj, widget.root);
                });
              }     

              Future<void> doSecondaryTap(
                BoardObjects obj,
                TTSInterface synth,
                ) async { }

          
          //
          //button
          //
          return LayoutBuilder(builder: (context, constraints) {
          double side = constraints.maxHeight * 0.3;
          double top = constraints.maxWidth * 0.2;

          return Stack(children: [ 
          Positioned.fill(child: 
          Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4,  
            child:
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _stopwatch..reset()..start(),
            onPointerUp: (_) async {
              _stopwatch.stop();

              final now = DateTime.now();

              if (!V4rs.useLongTapOr) {

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
            }
          },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 2,
            backgroundColor: 
              (Ev4rs.firstSelectedUUID.value == obj.id || Ev4rs.secondSelectedUUID.value == obj.id
                    || Ev4rs.selectedUUIDs.value.contains(obj.id) || Ev4rs.selectedUUIDs.value.contains(obj.id))
                ? (obj.matchPOS ?? true) 
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                  : obj.borderColor ?? Colors.blueGrey
                : (obj.matchPOS ?? true) 
                  ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                  : obj.backgroundColor ?? Colors.blueGrey,
            shadowColor: Cv4rs.themeColor4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true)
                    ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                    : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true)
                    ? Bv4rs.buttonBorderWeight
                    : obj.borderWeight ?? 2.5,
              ),
            ),
          ),
          onPressed: () async {
            if (altAccessActive) {
              await doTapAction(obj, synth);
            }
          },
          child: () {
            switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
              case 1:
                //text below
                return Stack(children: [
                  Column(children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          obj.padding ?? 2.0,
                          (obj.padding ?? 2.0) + 2.0,
                          obj.padding ?? 2.0,
                          obj.padding ?? 2.0,
                        ),
                        child: theSymbol,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ),
                  ]),
                ]);

              //text above 
              case 2:
                return Stack(children: [
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ), 
                    Flexible(child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        (obj.padding ?? 2.0) + 2.0,
                      ),
                      child: theSymbol,
                    ),
                    ),
                  ]),
                ]);
              
              //symbol only 
              case 3:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.all(obj.padding ?? 2.0),
                    child: theSymbol,
                  ),
                ]);

              //label only
              case 4:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: theLabel2,
                  ),
                ]);
              
              //fallback
              default:
                return SizedBox.shrink();
                }
              }(),
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
                    child: Opacity(
                      opacity: (obj.show ?? true) ? 1.0 : 0.4,  
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

    class BuildEditableFolder extends StatefulWidget{
        final Root root;
        final BoardObjects obj;
        final TTSInterface synth;
        final void Function(BoardObjects board) openBoard;
        final List<BoardObjects> boards;
        final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

        const BuildEditableFolder({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.openBoard, 
          required this.boards,
          required this.findBoardById,
          required this.root,
          });
        
        @override
        State<BuildEditableFolder> createState() => _BuildEditableFolderState();
    }

    class _BuildEditableFolderState extends State<BuildEditableFolder> {
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
        final synth = widget.synth;
        String linkTo = obj.linkToUUID ?? '';

        //font settings
        TextStyle uniqueStyle =  
        TextStyle(
          color: obj.fontColor ?? Colors.black,
          fontSize: obj.fontSize ?? 16,
          fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
          fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
          fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
          decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
        );

        TextStyle matchStyle =  
        TextStyle(
          color: Fv4rs.buttonFontColor,
          fontSize: Fv4rs.buttonFontSize,
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
          
          //tap action
              Future<void> doTapAction(
                BoardObjects obj,
                TTSInterface synth,
                ) async { 
                  if (Ev4rs.selectingAction1(obj)) {
                    setState(() {
                      Ev4rs.selectingAction1(obj);
                    });
                  } else {
                  switch ((obj.matchSpeakOS ?? true) ? Bv4rs.folderSpeakOnSelect : obj.speakOS) {
                  case 1:
                  Ev4rs.selectingAction2(obj, widget.root);
                    break;
                  case 2:
                  Ev4rs.selectingAction2(obj, widget.root);
                    await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                    break;
                  case 3:
                  Ev4rs.selectingAction2(obj, widget.root);
                    await V4rs.speakOnSelect(obj.message ?? '', V4rs.selectedLanguage.value, synth);
                    break;
                  }
                }
                }
              Future<void> doSecondaryTap(
                BoardObjects obj,
                TTSInterface synth,
                ) async {
                  setState(() {
                    final board = findBoardById(linkTo, boards);
                      if (board != null) {
                        openBoard(board);
                      }
                  });
                }
          
          //
          //button
          //
          return LayoutBuilder(builder: (context, constraints) {
          double side = constraints.maxHeight * 0.3;
          double top = constraints.maxWidth * 0.25;

          return Stack(children: [ 
          Positioned.fill(child: 
          Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4,  
            child:
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) => _stopwatch..reset()..start(),
            onPointerUp: (_) async {
              _stopwatch.stop();
              final now = DateTime.now();

            if (!V4rs.useLongTapOr) {

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
            }
          },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            elevation: 2,
            backgroundColor: 
              (Ev4rs.firstSelectedUUID.value == obj.id || Ev4rs.secondSelectedUUID.value == obj.id
                    || Ev4rs.selectedUUIDs.value.contains(obj.id) || Ev4rs.selectedUUIDs.value.contains(obj.id))
                ? (obj.matchPOS ?? true) 
                  ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                  : obj.borderColor ?? Colors.blueGrey
                : (obj.matchPOS ?? true) 
                  ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                  : obj.backgroundColor ?? Colors.blueGrey,
            shadowColor: Cv4rs.themeColor4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: (obj.matchBorder ?? true)
                    ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2')
                    : obj.borderColor ?? Colors.white,
                width: (obj.matchBorder ?? true)
                    ? Bv4rs.buttonBorderWeight
                    : obj.borderWeight ?? 2.5,
              ),
            ),
          ),
          onPressed: () async {
            if (altAccessActive) {
              await doTapAction(obj, synth);
              }
            }, 
          child: () {
            switch ((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
              case 1:
                //text below
                return Stack(children: [
                  Column(children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          obj.padding ?? 2.0,
                          (obj.padding ?? 2.0) + 2.0,
                          obj.padding ?? 2.0,
                          obj.padding ?? 2.0,
                        ),
                        child: theSymbol,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ),
                  ]),
                ]);

              //text above
              case 2:
                return Stack(children: [
                  Column(children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: theLabel,
                    ), 
                    Flexible(child: 
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        obj.padding ?? 2.0,
                        (obj.padding ?? 2.0) + 2.0,
                      ),
                      child: theSymbol,
                    ),
                    ),
                  ]),
                ]);

              //image only
              case 3:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.all(obj.padding ?? 2.0),
                    child: theSymbol,
                  ),
                ]);

              //label only  
              case 4:
                return Stack(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: theLabel2,
                  ),
                ]);

              //fallback 
              default:
                return SizedBox.shrink();
            }
          }(),
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
                    child:  Opacity(
                      opacity: (obj.show ?? true) ? 1.0 : 0.4,  
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

    class BuildEditableButtonGrammer extends StatefulWidget{
      final BoardObjects obj;
        final TTSInterface synth;
        final Root root;

        const BuildEditableButtonGrammer({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.root,
          });
        
        @override
        State<BuildEditableButtonGrammer> createState() => _BuildEditableButtonGrammerState();

    }

    class _BuildEditableButtonGrammerState extends State<BuildEditableButtonGrammer>{

        @override
        Widget build(BuildContext context) {
          final obj = widget.obj;
          final synth = widget.synth;

        //font settings
            TextStyle uniqueStyle =  
            TextStyle(
              color: obj.fontColor ?? Colors.black,
              fontSize: obj.fontSize ?? 16,
              fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
              fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
              fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
              decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
            );

            TextStyle matchStyle =  
            TextStyle(
              color: Fv4rs.buttonFontColor,
              fontSize: Fv4rs.buttonFontSize,
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
                return LayoutBuilder(builder: (context, constraints) {
          double side = constraints.maxHeight * 0.2;
          double top = constraints.maxWidth * 0.2;

          //
          //button
          //
          return 
          
          Stack(children: [ 
          Positioned.fill(child: 
          Visibility(
            visible: (obj.show ?? true), 
            maintainSize: true, 
            maintainAnimation: true,
            maintainState: true, child:
            ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                elevation: 2,
                backgroundColor: (obj.matchPOS ?? true) 
                  ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                  : obj.backgroundColor ?? Colors.blueGrey,
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
            onPressed: () async {
              setState(() async {
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
              case 1:
                Ev4rs.selectingAction2(obj, widget.root);
                break;
              case 2:
                Ev4rs.selectingAction2(obj, widget.root);
                await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                break;
              case 3:
                Ev4rs.selectingAction2(obj, widget.root);
                await V4rs.speakOnSelect(Gv4rs.lastWord, V4rs.selectedLanguage.value, synth);
                break;
              }
              });
            },
            child: () {
              switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
                case 1: 
                  return Column(children: [
                    Flexible(child: 
                    Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                    child:
                    theSymbol,
                    ),
                    ),
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                    theLabel,
                    ),
                  ],
                );
                case 2: 
                  return Column(children: [
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                    theLabel,
                    ),
                    Flexible(child: 
                    Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                    child:
                      theSymbol,
                    ),
                    ),
                ],
                );
                case 3: 
                  return Padding(
                    padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                    theSymbol,
                  );
                case 4:
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                  theLabel2);
              }
            } (),
            )
          
          )
          
        ),

        //
            //CORNER TAB 
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
                            await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                            V4rs.changedMWfromButton = false;
                            break;
                          case 3:
                            V4rs.changedMWfromButton = true;
                            Gv4rs.grammerFunctions(obj.function ?? '');
                            await V4rs.speakOnSelect(Gv4rs.lastWord, V4rs.selectedLanguage.value, synth);
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

  //
  //sub folders
  //

    class BuildEditableSubFolder extends StatefulWidget {
        final BoardObjects obj;
        final TTSInterface synth;
        final Root root;
        final void Function(BoardObjects board) openBoard;
        final void Function() goBack;
        final List<BoardObjects> boards;
        final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

        const BuildEditableSubFolder({
          super.key, 
          required this.root,
          required this.obj, 
          required this.synth,
          required this.goBack,
          required this.openBoard, 
          required this.boards,
          required this.findBoardById
          });
        
        @override
        State<BuildEditableSubFolder> createState() => _BuildEditableSubFolder();
    }

    class _BuildEditableSubFolder extends State<BuildEditableSubFolder> {

        @override
        Widget build(BuildContext context) {

          final obj = widget.obj;
          final synth = widget.synth;
          final goBack = widget.goBack;

          final openBoard = widget.openBoard;
          final boards = widget.boards;
          final findBoardById = widget.findBoardById;

          //font settings
            TextStyle uniqueStyle =  
            TextStyle(
              color: obj.fontColor ?? Colors.black,
              fontSize: obj.fontSize ?? 16,
              fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
              fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
              fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
              decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
            );

            TextStyle matchStyle =  
            TextStyle(
              color: Fv4rs.subFolderFontColor,
              fontSize: Fv4rs.subFolderFontSize,
              fontFamily: Fontsy.fontToFamily[Fv4rs.subFolderFont], 
              fontWeight: FontWeight.values[((Fv4rs.subFolderFontWeight ~/ 100) - 1 ).clamp(0, 8)],
              fontStyle: Fv4rs.subFolderFontItalics ? FontStyle.italic : FontStyle.normal,
              decoration: Fv4rs.subFolderFontUnderline ? TextDecoration.underline : TextDecoration.none,
            );

          //label
            Text theLabel = 
            Text(obj.label ?? "", 
              style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle, 
              maxLines: 3,
              overflow: TextOverflow.ellipsis
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
                defaultSymbolColorOverlay: Bv4rs.subFolderSymbolColorOverlay, 
                matchSymbolContrast: obj.matchSymbolContrast ?? true, 
                matchSymbolInvert: obj.matchInvertSymbol ?? true, 
                matchSymbolSaturation: obj.matchSymbolSaturation ?? true, 
                defaultSymbolInvert: Bv4rs.subFolderSymbolInvert, 
                defaultSymbolContrast: Bv4rs.subFolderSymbolContrast, 
                defaultSymbolSaturation: Bv4rs.subFolderSymbolSaturation
                );

          //navigation  
          String linkTo = obj.linkToUUID ?? '';

          //
          //back button
          //
          if (obj.type1 == 'backButton'){
            return Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.5,
            child:
            ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                elevation: 2,
                backgroundColor: (Ev4rs.firstSubFolderSelectedUUID.value == obj.id || Ev4rs.secondSubFolderSelectedUUID.value == obj.id
                    || Ev4rs.subFolderSelectedUUIDs.value.contains(obj.id) || Ev4rs.subFolderSelectedUUIDs.value.contains(obj.id)) 
                    ? (obj.matchPOS ?? true) 
                      ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                      : obj.borderColor ?? Colors.blueGrey
                    : (obj.matchPOS ?? true) 
                      ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                      : obj.backgroundColor ?? Colors.blueGrey,
                shadowColor: Cv4rs.themeColor4, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: (obj.matchBorder ?? true) 
                      ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                      : obj.borderColor ?? Colors.white,
                    width: (obj.matchBorder ?? true) 
                      ? Bv4rs.subFolderBorderWeight
                      : obj.borderWeight ?? 2.5
                  )
                ),
              ),
            onPressed: () async {
              if (Ev4rs.subFolderSelectingAction1(obj)){
                Ev4rs.subFolderSelectingAction1(obj);
              } else {
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.subFolderSpeakOnSelect : obj.speakOS) {
              case 1:
                goBack();
                break;
              case 2:
                goBack();
                await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                break;
              case 3:
              goBack();
                await V4rs.speakOnSelect(obj.alternateLabel ?? '', V4rs.selectedLanguage.value, synth);
                break;
              }
              }
            },
            child: () {
              switch((obj.matchFormat ?? true) ? Bv4rs.subFolderFormat : obj.format) {
                case 1: 
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Padding(padding: EdgeInsets.all(obj.padding ?? 5.0), child:
                    theSymbol,
                    ),
                    Flexible(child: 
                    Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                    theLabel,
                    ),
                  
                    ),
                    
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),  
                        ),
                    ),
                  ],
                );
                case 2: 
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: 
                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                    theLabel,
                      ),
                      ),
                    Padding(padding: EdgeInsets.all(obj.padding ?? 5.0), child:
                      theSymbol,
                    ),
                    
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),  
                        ),
                    ),
                ],
                );
                case 3: 
                  return Row(children: [
                  Padding(
                    padding: EdgeInsets.all(obj.padding ?? 5.0), child:
                    theSymbol,
                  ),
                  
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),    
                        ),
                    ),
                  ]
                  );
                case 4:
                  return Row(children: [
                  Flexible(child: 
                  Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                  theLabel,
                  )
                  ),
                  
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),    
                          ),
                    ),
                  ]
                  );
              }
            } (),
            )
          );
          } 

          //
          //sub folders + more
          //
          return Opacity(
            opacity: (obj.show ?? true) ? 1.0 : 0.4, 
            child:
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                elevation: 2,
                backgroundColor: (Ev4rs.firstSubFolderSelectedUUID.value == obj.id || Ev4rs.secondSubFolderSelectedUUID.value == obj.id
                    || Ev4rs.subFolderSelectedUUIDs.value.contains(obj.id) || Ev4rs.subFolderSelectedUUIDs.value.contains(obj.id)) 
                    ? (obj.matchPOS ?? true) 
                      ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                      : obj.borderColor ?? Colors.blueGrey
                    : (obj.matchPOS ?? true) 
                      ? Cv4rs.posToColor(obj.pos ?? 'Extra 2') 
                      : obj.backgroundColor ?? Colors.blueGrey,
                shadowColor: Cv4rs.themeColor4, 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: (obj.matchBorder ?? true) 
                      ? Cv4rs.posToBorderColor(obj.pos ?? 'Extra 2') 
                      : obj.borderColor ?? Colors.white,
                    width: (obj.matchBorder ?? true) 
                      ? Bv4rs.subFolderBorderWeight
                      : obj.borderWeight ?? 2.5
                  )
                ),
              ),
              onPressed: () async {
                if (Ev4rs.subFolderSelectingAction1(obj)){
                  Ev4rs.subFolderSelectingAction1(obj);
                } else{
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.subFolderSpeakOnSelect : obj.speakOS) {
                case 1:
                  final board = findBoardById(linkTo, boards);
                  if (board != null) {
                      if (obj.returnAfterSelect == true) {
                        //openBoardWithReturn(board);
                      } else {
                        openBoard(board);
                      }
                  }
                  break;
                case 2:
                  final board = findBoardById(linkTo, boards);
                  if (board != null) {
                      if (obj.returnAfterSelect == true) {
                      //  openBoardWithReturn(board);
                      } else {
                        openBoard(board);
                      }
                  }
                  await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
                  break;
                case 3:
                  final board = findBoardById(linkTo, boards);
                  if (board != null) {
                      if (obj.returnAfterSelect == true) {
                      // openBoardWithReturn(board);
                      } else {
                        openBoard(board);
                      }
                  }
                  await V4rs.speakOnSelect(obj.alternateLabel ?? '', V4rs.selectedLanguage.value, synth);
                  break;
                }
                }
              },
              child: () {
              switch((obj.matchFormat ?? true) ? Bv4rs.subFolderFormat : obj.format) {
                case 1: 
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    Padding(padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                    theSymbol,
                    ),
                  Flexible(child: 
                  Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                  theLabel
                  )
                    ),
                    
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),    
                          ),
                    ),
                  ],
                );
                case 2: 
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Flexible(child: 
                  Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                  theLabel
                  )
                      ),
                    Padding(padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                      theSymbol,
                    ),
                    
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),    
                        ),
                    ),
                ],
                );
                case 3: 
                  return Row(children: [
                  Padding(
                    padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                    theSymbol,
                  ),
                  
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),   
                        ),
                    ),
                  ]
                  );
                case 4:
                  return Row( children: [
                    Flexible(child: 
                  Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 5.0), child:
                  theLabel
                  )
                    ),
                    
                    Flexible(
                    fit: FlexFit.tight,
                    child:
                    Padding(padding: EdgeInsetsGeometry.all(5), child: 
                    ButtonStyle1(
                        glow: true,
                        imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
                          onPressed: (){
                            setState(() {
                              Ev4rs.subFolderSelectingAction2(obj, widget.root);
                            });
                          }, 
                          ),    
                        ),
                    ),
                  ]);
              }
            } (),
          ),
        );
        }
    }

//
//grammer row
//

  class BuildEditableGrammerButton extends StatelessWidget{
      final Root root;
      final GrammerObjects obj;
      final TTSInterface synth;

      const BuildEditableGrammerButton({super.key, required this.obj, required this.synth, required this.root});

      @override
      Widget build(BuildContext context) {

      //font settings
          TextStyle uniqueStyle =  
          TextStyle(
            color: obj.fontColor ?? Colors.black,
            fontSize: obj.fontSize ?? 16,
            fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
            fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
            fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
            decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
          );

          TextStyle matchStyle =  
          TextStyle(
            color: Fv4rs.grammerFontColor,
            fontSize: Fv4rs.grammerFontSize,
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
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              elevation: 0,
              backgroundColor: 
                  (Ev4rs.firstGrammerSelectedUUID.value == obj.id || Ev4rs.secondGrammerSelectedUUID.value == obj.id
                  || Ev4rs.grammerSelectedUUIDs.value.contains(obj.id)) 
                  ? Cv4rs.themeColor3
                  : obj.backgroundColor ?? Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
              )
            ),
          onPressed: () async {
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
            case 1:
              Ev4rs.grammerSelectingAction2(obj, root);
              break;
            case 2:
              Ev4rs.grammerSelectingAction2(obj, root);
              await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
              break;
            case 3:
              Ev4rs.grammerSelectingAction2(obj, root);
              break;
            }
          },
          child: () {
            switch((obj.matchFormat ?? true) ? Bv4rs.grammerRowFormat : obj.format) {
              case 1: 
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  (obj.symbol != null) ?
                  Flexible(flex: 4, child: 
                  Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                  child:
                  theSymbol,
                  ),
                  ) : SizedBox.shrink(),
                  Expanded(flex: 7,
                    child: 
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                  theLabel,
                  ),
                  ),
                ],
              );
              case 2: 
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Expanded(flex: 7, child: 
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                  theLabel,
                  ),
                  ),
                  (obj.symbol != null) ?
                  Flexible(flex: 4, child: 
                  Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                  child:
                    theSymbol,
                  ),
                  ) : SizedBox.shrink(),
              ],
              );
              case 3: 
                return (obj.symbol != null) ? Padding(
                  padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                  theSymbol,
                ) : SizedBox.shrink();
              case 4:
                return Column(children: [
                  Expanded(child: 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0), child:
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

 class BuildEditableGrammerFolder extends StatefulWidget{
   
      final GrammerObjects obj;
      final TTSInterface synth;
      final Root root;

      final void Function(BoardObjects board) openBoard;
      final List<BoardObjects> boards;
      final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;

    

      const BuildEditableGrammerFolder({
        super.key, 
        required this.obj, 
        required this.synth,
        required this.openBoard, 
        required this.boards,
        required this.findBoardById,
        required this.root
      });

      @override
      State<BuildEditableGrammerFolder> createState() => _BuildEditableGrammerFolder();

 }

  class _BuildEditableGrammerFolder extends State<BuildEditableGrammerFolder> {


      @override
      Widget build(BuildContext context) {


      final GrammerObjects obj = widget.obj;
      final TTSInterface synth = widget.synth;
      final void Function(BoardObjects board) openBoard = widget.openBoard;
      final List<BoardObjects> boards = widget.boards;
      final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById = widget.findBoardById;  
      final Root root = widget.root;

      //font settings
          TextStyle uniqueStyle =  
          TextStyle(
            color: obj.fontColor ?? Colors.black,
            fontSize: obj.fontSize ?? 16,
            fontFamily: Fontsy.fontToFamily[(obj.fontFamily ?? 'default')], 
            fontWeight: FontWeight.values[(((obj.fontWeight ?? 400) ~/ 100) - 1 ).clamp(0, 8)],
            fontStyle: (obj.fontItalics ?? false) ? FontStyle.italic : FontStyle.normal,
            decoration: (obj.fontUnderline ?? false) ? TextDecoration.underline : TextDecoration.none,
          );

          TextStyle matchStyle =  
          TextStyle(
            color: Fv4rs.grammerFontColor,
            fontSize: Fv4rs.grammerFontSize,
            fontFamily: Fontsy.fontToFamily[Fv4rs.grammerFont], 
            fontWeight: FontWeight.values[((Fv4rs.grammerFontWeight ~/ 100) - 1 ).clamp(0, 8)],
            fontStyle: Fv4rs.grammerFontItalics ? FontStyle.italic : FontStyle.normal,
            decoration: Fv4rs.grammerFontUnderline ? TextDecoration.underline : TextDecoration.none,
          );

        //label
          Text theLabel = 
          Text(obj.label ?? "", 
            style: (obj.matchFont ?? true) ? matchStyle : uniqueStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            );
          Text theLabel2 = 
          Text(obj.label ?? "", 
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
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              elevation: 0,
              backgroundColor: (Ev4rs.firstGrammerSelectedUUID.value == obj.id || Ev4rs.secondGrammerSelectedUUID.value == obj.id
                  || Ev4rs.grammerSelectedUUIDs.value.contains(obj.id)) 
                  ? Cv4rs.themeColor3
                  : obj.backgroundColor ?? Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
              )
            ),
          onPressed: () async {
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
            case 1: 
              setState(() {
                final board = findBoardById((obj.openUUID ?? ''), boards);
                if (board != null) {
                  openBoard(board);
                }
                Ev4rs.grammerSelectingAction2(obj, root);
              });
              break;
            case 2:
              setState(() {
                final board = findBoardById((obj.openUUID ?? ''), boards);
                if (board != null) {
                  openBoard(board);
                }
                Ev4rs.grammerSelectingAction2(obj, root);
              });
              await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
              break;
            case 3:
               setState(() {
                final board = findBoardById((obj.openUUID ?? ''), boards);
                if (board != null) {
                  openBoard(board);
                }
                Ev4rs.grammerSelectingAction2(obj, root);
              });
                if (Bv4rs.folderSpeakOnSelect != 1) {
                await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
              }
              break;
            }
          },
          child: () {
            switch((obj.matchFormat ?? true) ? Bv4rs.buttonFormat : obj.format) {
              case 1: 
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  (obj.symbol != null) ?
                  Flexible(flex: 4, child: 
                  Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0), 
                  child:
                  theSymbol,
                  ),
                  ) : SizedBox.shrink(),
                  Expanded(flex: 7, child: 
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                  theLabel,
                  ),
                  ),
                ],
              );
              case 2: 
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Expanded(flex: 7, child: 
                  Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0), child:
                  theLabel,
                  ),),
                  (obj.symbol != null) ?
                  Flexible(flex: 4, child: 
                  Padding(padding: EdgeInsets.fromLTRB(obj.padding ?? 2.0, obj.padding ?? 2.0, obj.padding ?? 2.0, (obj.padding ?? 2.0) + 2.0), 
                  child:
                    theSymbol,
                  ),
                  ) : SizedBox.shrink(),
              ],
              );
              case 3: 
                return (obj.symbol != null) ? Padding(
                  padding: EdgeInsets.all(obj.padding ?? 2.0), child:
                  theSymbol,
                ) : SizedBox.shrink();
              case 4:
                return Column( children: [
                  Expanded(child: 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0), child:
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

  class BuildEditableGrammerPlacholder extends StatelessWidget{
      final Root root;
      final GrammerObjects obj;
      final TTSInterface synth;

      const BuildEditableGrammerPlacholder({super.key, required this.obj, required this.synth, required this.root});

      @override
      Widget build(BuildContext context) {

        //
        //button
        //
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              elevation: 0,
              backgroundColor: (Ev4rs.firstGrammerSelectedUUID.value == obj.id || Ev4rs.secondGrammerSelectedUUID.value == obj.id
                  || Ev4rs.grammerSelectedUUIDs.value.contains(obj.id)) 
                  ? Cv4rs.themeColor3
                  : obj.backgroundColor ?? Colors.transparent,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, 
              )
            ),
          onPressed: () async {
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
            case 1:
              Ev4rs.grammerSelectingAction2(obj, root);
              break;
            case 2:
              Ev4rs.grammerSelectingAction2(obj, root);
              await V4rs.speakOnSelect(obj.label ?? '', V4rs.selectedLanguage.value, synth);
              break;
            case 3:
              Ev4rs.grammerSelectingAction2(obj, root);
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

//
//nav row
//

class EditableNavButton extends StatefulWidget {

  final NavObjects obj;
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

  //constructs the button 
  const EditableNavButton ({
    super.key,
    required this.obj,
    this.symbol = 'assets/interface_icons/interface_icons/iPlaceholder.png',
    required this.tts,
    required this.openBoard,
    required this.boards,
    required this.findBoardById,
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
    required this.padding,
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
        State<EditableNavButton> createState() => _EditableNavButton();
}

class _EditableNavButton extends State<EditableNavButton> {
  late Future<Root> rootFuture;
    late Root root;

     @override
      void initState(){
        Ev4rs.rootReady = false;
        super.initState();
        rootFuture = V4rs.loadRootData();

        Ev4rs.reloadJson.addListener(_handleReload);
      }

      @override
      void dispose(){
        Ev4rs.reloadJson.removeListener(_handleReload);
        super.dispose();
      }

      void _handleReload() {
        setState(() {
          rootFuture = V4rs.loadRootData();
        });
      }


  //defines the button 
  @override
  Widget build(BuildContext context) {
    

  final NavObjects obj = widget.obj;
  final String label = widget.label;
  final TTSInterface tts = widget.tts;
  final void Function(BoardObjects board) openBoard = widget.openBoard;
  final List<BoardObjects> boards = widget.boards;
  final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById = widget.findBoardById;

  final String linkToUUID = widget.linkToUUID;

  final bool show = widget.show;
  final bool matchFormat = widget.matchFormat;
  final int format = widget.format;

  final String pos = widget.pos;
  final bool matchPOS = widget.matchPOS;
  final Color backgroundColor = widget.backgroundColor;

  final bool matchBorder = widget.matchBorder;
  final double borderWeight = widget.borderWeight;
  final Color borderColor = widget.borderColor;

  final bool matchFont = widget.matchFont;

  final double padding = widget.padding;
  final bool matchOverlayColor = widget.matchOverlayColor;
  final Color overlayColor = widget.overlayColor;
  final double symbolSaturation = widget.symbolSaturation;
  final double symbolContrast = widget.symbolContrast;
  final bool invertSymbolColors = widget.invertSymbolColors;
  final bool matchSymbolContrast = widget.matchSymbolContrast;
  final bool matchSymbolInvert = widget.matchSymbolInvert;
  final bool matchSymbolSaturation = widget.matchSymbolSaturation;

  final bool matchSpeakOS = widget.matchSpeakOS;
  final int speakOS = widget.speakOS;
  final String alternateLabel = widget.alternateLabel;

  final TextStyle labelStyle = widget.labelStyle;
    
    Widget image = LoadImage.fromSymbol(obj.symbol);

  return FutureBuilder<Root>(
            future: rootFuture, 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                root = snapshot.data!;
                Ev4rs.rootReady = true;
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data found'));
              }
            }
    return Visibility (
      visible: (Bv4rs.showNavRow == 2) ? false : true,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child:
      Opacity(opacity: show ? 1 : 0.4, child:
    ElevatedButton(
        onPressed: () {
        switch (matchSpeakOS ? Bv4rs.navRowSpeakOnSelect : speakOS) {
          case 1:
              Ev4rs.navSelectingAction2(obj, root);
              final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
              }
              
            break;
          case 2:
              Ev4rs.navSelectingAction2(obj, root);
             final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
              }
            
            V4rs.speakOnSelect(label, V4rs.selectedLanguage.value, tts);
            break;
          case 3:
           Ev4rs.navSelectingAction2(obj, root);
           final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
              }
            V4rs.speakOnSelect(alternateLabel, V4rs.selectedLanguage.value, tts);
            break;
          }},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          backgroundColor: (Ev4rs.firstNavSelectedUUID.value == obj.id 
                  || Ev4rs.secondNavSelectedUUID.value == obj.id
                  || Ev4rs.navSelectedUUIDs.value.contains(obj.id) 
                  || (Ev4rs.selectedBoardUUID.value == obj.linkToUUID && Ev4rs.boardEditor.value == true)) 
          ? matchBorder ? Cv4rs.posToBorderColor(pos) : borderColor
          : matchPOS ? Cv4rs.posToColor(pos) : backgroundColor, 
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
              children: [

                //image
                Expanded( child:
                Padding(
                  padding: EdgeInsets.all(padding),
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
                  padding: EdgeInsets.all(padding),
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
                  padding: EdgeInsets.all(padding),
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
    ),  
      ),
      );
            }
            );
  }
}






