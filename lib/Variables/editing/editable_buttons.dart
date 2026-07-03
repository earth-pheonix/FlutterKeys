
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/fonts/font_options.dart';
import 'package:flutterkeysaac/Variables/fonts/font_variables.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/grammer_variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;
import 'dart:async';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_boards.dart';

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

          //
          //button
          //
          return ValueListenableBuilder(
            valueListenable: Ev4rs.selectedUUIDs, 
            builder: (context, selected, _){
              return Opacity(
                opacity: (obj.show ?? true) ? 1.0 : 0.4, 
                child: BoardButtonStyle(
                  obj: obj,
                  editable: true,
                  onPressed: () {
                    setState(() {
                      Ev4rs.selectingAction2(obj, widget.root);
                    });
                  },
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
        final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
        final Future<void> Function() initForSS;
        final AudioPlayer playerForSS;

        const BuildEditablePocketFolder({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.openBoard, 
          required this.boards,
          required this.findBoardById,
          required this.root,
          required this.speakSelectSherpaOnnxSynth,
          required this.initForSS,
          required this.playerForSS,
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
                      openBoard(board);
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
        child: BoardButtonStyle(
          obj: obj,
          editable: true,
          onPressed: () async {
            if (altAccessActive) {
              await doTapAction(obj);
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
        final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
        final Future<void> Function() initForSS;
        final AudioPlayer playerForSS;

        const BuildEditableTypingKey({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.root,
          required this.speakSelectSherpaOnnxSynth,
          required this.initForSS,
          required this.playerForSS,
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
        child: BoardButtonStyle(
          obj: obj,
          editable: true,
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
        child: BoardButtonStyle(
          obj: obj,
          editable: true,
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
        final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
        final Future<void> Function() initForSS;
        final AudioPlayer playerForSS;


        const BuildEditableFolder({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.openBoard, 
          required this.boards,
          required this.findBoardById,
          required this.root,
          required this.speakSelectSherpaOnnxSynth,
          required this.initForSS,
          required this.playerForSS,
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
          
          //tap action
              Future<void> doTapAction(
                BoardObjects obj,
                TTSInterface synth,
                ) async { 
                  switch ((obj.matchSpeakOS ?? true) ? Bv4rs.folderSpeakOnSelect : obj.speakOS) {
                  case 1:
                  Ev4rs.selectingAction2(obj, widget.root);
                    break;
                  case 2:
                  Ev4rs.selectingAction2(obj, widget.root);
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
                  Ev4rs.selectingAction2(obj, widget.root);
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
        child: BoardButtonStyle(
          obj: obj,
          editable: true,
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


    class BuildEditableVolumeButton extends StatefulWidget{
        final Root root;
        final BoardObjects obj;
        final TTSInterface synth;
        final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
        final Future<void> Function() initForSS;
        final AudioPlayer playerForSS;


        const BuildEditableVolumeButton({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.root,
          required this.speakSelectSherpaOnnxSynth,
          required this.initForSS,
          required this.playerForSS,
          });
        
        @override
        State<BuildEditableVolumeButton> createState() => _BuildEditableVolumeButtonState();
    }

    class _BuildEditableVolumeButtonState extends State<BuildEditableVolumeButton> {
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
                  switch ((obj.matchSpeakOS ?? true) ? Bv4rs.folderSpeakOnSelect : obj.speakOS) {
                  case 1:
                  Ev4rs.selectingAction2(obj, widget.root);
                    break;
                  case 2:
                  Ev4rs.selectingAction2(obj, widget.root);
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
                  Ev4rs.selectingAction2(obj, widget.root);
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
        child: BoardButtonStyle(
          obj: obj,
          editable: true,
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
                  right: 2,
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
                      (obj.type == 7) 
                        ? Image.asset('assets/interface_icons/interface_icons/iDownTriangle.png')
                        : Image.asset('assets/interface_icons/interface_icons/iUpTriangle.png'),
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
        final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
        final Future<void> Function() initForSS;
        final AudioPlayer playerForSS;

        const BuildEditableButtonGrammer({
          super.key, 
          required this.obj, 
          required this.synth,
          required this.root,
          required this.speakSelectSherpaOnnxSynth,
          required this.initForSS,
          required this.playerForSS,
          });
        
        @override
        State<BuildEditableButtonGrammer> createState() => _BuildEditableButtonGrammerState();

    }

    class _BuildEditableButtonGrammerState extends State<BuildEditableButtonGrammer>{

        @override
        Widget build(BuildContext context) {
          final obj = widget.obj;
          final synth = widget.synth;

          return LayoutBuilder(builder: (context, constraints) {
          double side = constraints.maxHeight * 0.2;
          double top = constraints.maxWidth * 0.2;

          //
          //button
          //
          return Stack(children: [ 
          Positioned.fill(child: 
          BoardButtonStyle(
            obj: obj,
            editable: true,
            onPressed: () async {
              setState(() async {
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
              case 1:
                Ev4rs.selectingAction2(obj, widget.root);
                break;
              case 2:
                Ev4rs.selectingAction2(obj, widget.root);
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
                Ev4rs.selectingAction2(obj, widget.root);
                await V4rs.speakOnSelect(
                  Gv4rs.lastWord, 
                  V4rs.selectedLanguage.value, 
                  synth,
                  widget.speakSelectSherpaOnnxSynth,
                  widget.initForSS,
                  widget.playerForSS,
                );
                break;
              }
              });
            },
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
                            Gv4rs.grammerFunctions(obj.function ?? '');
                            await V4rs.speakOnSelect(
                              Gv4rs.lastWord, 
                              V4rs.selectedLanguage.value, 
                              synth,
                              widget.speakSelectSherpaOnnxSynth,
                              widget.initForSS,
                              widget.playerForSS,
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
        final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
        final Future<void> Function() initForSS;
        final AudioPlayer playerForSS;

        const BuildEditableSubFolder({
          super.key, 
          required this.root,
          required this.obj, 
          required this.synth,
          required this.goBack,
          required this.openBoard, 
          required this.boards,
          required this.findBoardById,
          required this.speakSelectSherpaOnnxSynth,
          required this.initForSS,
          required this.playerForSS,
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

          //navigation  
          String linkTo = obj.linkToUUID ?? '';

          //
          //back button
          //
          if (obj.type1 == 'backButton'){
            return BoardButtonStyle(
              editable: true,
              isSubFolder: true,
              editSubFolderPress: (){ 
              setState(() {
                Ev4rs.subFolderSelectingAction2(obj, widget.root);
              });
            },
              obj: obj,
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
                goBack();
                  await V4rs.speakOnSelect(
                    obj.alternateLabel ?? '', 
                    V4rs.selectedLanguage.value, 
                    synth,
                    widget.speakSelectSherpaOnnxSynth,
                    widget.initForSS,
                    widget.playerForSS,
                  );
                  break;
                }
                }
              },  
            );
          } 

          //
          //sub folders + more
          //
          return BoardButtonStyle(
            editable: true,
            isSubFolder: true,
            obj: obj,
            editSubFolderPress: (){ 
              setState(() {
                Ev4rs.subFolderSelectingAction2(obj, widget.root);
              });
            }, 
            onPressed: () async {
                if (Ev4rs.subFolderSelectingAction1(obj)){
                  Ev4rs.subFolderSelectingAction1(obj);
                } else{
              switch ((obj.matchSpeakOS ?? true) ? Bv4rs.subFolderSpeakOnSelect : obj.speakOS) {
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
                      
                        openBoard(board);
                  }
                  await V4rs.speakOnSelect(
                    obj.alternateLabel ?? '', 
                    V4rs.selectedLanguage.value, 
                    synth,
                    widget.speakSelectSherpaOnnxSynth,
                    widget.initForSS,
                    widget.playerForSS,
                  );
                  break;
                }
                }
              },    
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
      final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
      final Future<void> Function() initForSS;
      final AudioPlayer playerForSS;

      const BuildEditableGrammerButton({
        super.key, 
        required this.obj, 
        required this.synth, 
        required this.root,
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
          editable: true,
          onPressed: () async {
            switch ((obj.matchSpeakOS ?? true) ? Bv4rs.grammerRowSpeakOnSelect : obj.speakOS) {
            case 1:
              Ev4rs.grammerSelectingAction2(obj, root);
              break;
            case 2:
              Ev4rs.grammerSelectingAction2(obj, root);
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
              Ev4rs.grammerSelectingAction2(obj, root);
              break;
            }
          },
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
      final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
      final Future<void> Function() initForSS;
      final AudioPlayer playerForSS;

    

      const BuildEditableGrammerFolder({
        super.key, 
        required this.obj, 
        required this.synth,
        required this.openBoard, 
        required this.boards,
        required this.findBoardById,
        required this.root,
        required this.speakSelectSherpaOnnxSynth,
        required this.initForSS,
        required this.playerForSS,
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

        //
        //button
        //
        return GrammerButtonStyle(
          obj: obj,
          editable: true,
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
               setState(() {
                final board = findBoardById((obj.openUUID ?? ''), boards);
                if (board != null) {
                  openBoard(board);
                }
                Ev4rs.grammerSelectingAction2(obj, root);
              });
                if (Bv4rs.folderSpeakOnSelect != 1) {
                await V4rs.speakOnSelect(
                  obj.label ?? '', 
                  V4rs.selectedLanguage.value, 
                  synth,
                  widget.speakSelectSherpaOnnxSynth,
                  widget.initForSS,
                  widget.playerForSS,
                );
              }
              break;
            }
          },
        );
      }
    }

  class BuildEditableGrammerPlacholder extends StatelessWidget{
      final Root root;
      final GrammerObjects obj;
      final TTSInterface synth;
      final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
      final Future<void> Function() initForSS;
      final AudioPlayer playerForSS;

      const BuildEditableGrammerPlacholder({
        super.key, 
        required this.obj, 
        required this.synth, 
        required this.root,
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
  final Root root;
  final NavObjects obj;
  final String label;
  final String symbol;
  final TTSInterface tts;
  final void Function(BoardObjects board) openBoard;
  final List<BoardObjects> boards;
  final BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

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
    required this.root,
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
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,

  });

        @override
        State<EditableNavButton> createState() => _EditableNavButton();
}

class _EditableNavButton extends State<EditableNavButton> {
  Widget navEditButton(void Function() onPressed) {
        return Padding(
            padding: EdgeInsetsGeometry.all(V4rs.paddingValue(5)), 
            child: ButtonStyle1(
              glow: true,
              padding: 2,
              imagePath: 'assets/interface_icons/interface_icons/iEdit.png', 
              onPressed: onPressed,
            ),  
        );
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

  return Visibility (
      visible: (Bv4rs.showNavRow == 2) ? false : true,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child:
      Opacity(opacity: show ? 1 : 0.4, child:
    ElevatedButton(
        onPressed: () {setState(() {
        switch (matchSpeakOS ? Bv4rs.navRowSpeakOnSelect : speakOS) {
          case 1:
              final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
              }
              
            break;
          case 2:
             final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
              }
            
            V4rs.speakOnSelect(
              label, 
              V4rs.selectedLanguage.value, 
              tts,
              widget.speakSelectSherpaOnnxSynth,
              widget.initForSS,
              widget.playerForSS,
            );
            break;
          case 3:
           final board = findBoardById(linkToUUID, boards);
              if (board != null) {
                openBoard(board);
              }
            V4rs.speakOnSelect(
              alternateLabel, 
              V4rs.selectedLanguage.value, 
              tts,
              widget.speakSelectSherpaOnnxSynth,
              widget.initForSS,
              widget.playerForSS,
            );
            break;
          }
        });
        },
        
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: V4rs.paddingValue(5), vertical: V4rs.paddingValue(2)),
          backgroundColor: (Ev4rs.firstNavSelectedUUID.value == obj.id 
                  || Ev4rs.secondNavSelectedUUID.value == obj.id
                  || Ev4rs.navSelectedUUIDs.value.contains(obj.id) 
                ) 
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                //image
                Flexible( 
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(
                      (V4rs.paddingValue(padding)-2 > 0)
                      ? V4rs.paddingValue(padding)-2
                      : V4rs.paddingValue(padding)
                    ),
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
                Flexible(
                  flex: 3,
                  child: 
                Text(
                  label, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                  textAlign: TextAlign.center, 
                ),
                ),
                Flexible(
                  flex: 4,
                  child: navEditButton(() {
                    setState(() {
                      Ev4rs.navSelectingAction2(obj, widget.root);
                    });
                  })
                )
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
                Expanded(child:
                  Text(
                    label, 
                    maxLines: 1,  
                    style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, 
                    overflow: TextOverflow.ellipsis, 
                    textAlign: TextAlign.center, 
                  ),
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
                 Expanded(
                  child: navEditButton(() {
                    setState(() {
                      Ev4rs.navSelectingAction2(obj, widget.root);
                    });
                  })
                )
              ]
            );
          
          //
          //image only
          //

          case 3:
            return Column(children: [
              Expanded(child: Padding(
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
            )),
              Expanded(
                  child: navEditButton(() {
                    setState(() {
                      Ev4rs.navSelectingAction2(obj, widget.root);
                    });
                  })
                )
           ],
          );

         
          //
          //text only
          //
          
          case 4:
            return Column(children: [ Expanded( child:
            Text(
                  label, maxLines: 3,  style: matchFont ? Fv4rs.navRowLabelStyle : labelStyle, textAlign: TextAlign.center,   overflow: TextOverflow.ellipsis, 
            ),
            ),

            Expanded(
                  child: navEditButton(() {
                    setState(() {
                      Ev4rs.navSelectingAction2(obj, widget.root);
                    });
                  })
                )
            ]
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
}