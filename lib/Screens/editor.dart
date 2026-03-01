import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/settings/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/editing/editing_board_buttons.dart';
import 'package:flutterkeysaac/Variables/editing/editing_boards_and.dart';
import 'package:flutterkeysaac/Variables/editing/editing_nav_and_grammer.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/system_tts/tts_interface.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/save_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart' as sherpa_onnx;

class Editor extends StatefulWidget {
  final TTSInterface synth;
  final int? highlightStart;
  final int? highlightLength;
  final Map<String, sherpa_onnx.OfflineTts?>? speakSelectSherpaOnnxSynth;
  final Future<void> Function() initForSS;
  final AudioPlayer playerForSS;

  const Editor({
    super.key,
    required this.synth,
    this.highlightStart,
    this.highlightLength,
    required this.speakSelectSherpaOnnxSynth,
    required this.initForSS,
    required this.playerForSS,
  });

  @override
  State<Editor> createState() => _Editor();
}

class _Editor extends State<Editor> with WidgetsBindingObserver {

  Rect? _selectionRect;
  Offset? _dragStart;

  bool listsAreEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  final GlobalKey _gestureDetectorKey = GlobalKey();

  void _updateSelection() {
    final rect = _selectionRect;
    if (rect == null) return;

    final gestureBox = _gestureDetectorKey.currentContext?.findRenderObject() as RenderBox?;
    if (gestureBox == null) {
      return;
    }

    // Convert local rect → global rect
    final topLeft = gestureBox.localToGlobal(rect.topLeft);
    final bottomRight = gestureBox.localToGlobal(rect.bottomRight);
    final globalRect = Rect.fromPoints(topLeft, bottomRight);

    final newSelection = <String>[];

    // copy to avoid concurrent modification
    final entries = Map<String, GlobalKey>.from(Ev4rs.buttonKeys);

    //only look at buttons on visible board
    final currentBoard = _root!.boards[ V4rs.syncIndex];
    final currentUuids = currentBoard.content.map((obj) => obj.id).toSet();

    
    for (final entry in entries.entries) {
      final uuid = entry.key;
      if (!currentUuids.contains(uuid)) continue; //skip UUIDS not on visible buttons

      final key = entry.value;

      final context = key.currentContext;
      if (context == null) {
        Ev4rs.buttonKeys.remove(uuid);
        continue;
      }

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) {
        continue;
      }
      final pos = renderBox.localToGlobal(Offset.zero);
      final size = renderBox.size;
      final buttonRect = Rect.fromLTWH(pos.dx, pos.dy, size.width, size.height);


      if (globalRect.overlaps(buttonRect)) {
        newSelection.add(uuid);
      }
    }

    final oldSelection = Ev4rs.selectedUUIDs.value;
    if (!listsAreEqual(newSelection, oldSelection)) {
      Ev4rs.selectedUUIDs.value = newSelection;
      Ev4rs.selectedUUID = newSelection.first;
    } 
  }

  late Future<Root> rootFuture;
  Root? _root;

  final List<int> _boardHistory = [];

  void saveField(Root root, String objUUID, String field, dynamic value) {
    if (_root == null) return;
    Ev4rs.updateBoardField(root, objUUID, field, value);
    setState(() {});
  }
  void saveNavField(Root root, String objUUID, String field, dynamic value) {
    if (_root == null) return;
    Ev4rs.updateNavField(root, objUUID, field, value);
    setState(() {});
  }
  void saveGrammerField(Root root, String objUUID, String field, dynamic value) {
    if (_root == null) return;
    Ev4rs.updateGrammerField(root, objUUID, field, value);
    setState(() {});
  }

  void multiSaveField(Root root, List<String> objUUIDs, String field, dynamic value) {
    if (_root == null) return;
    Ev4rs.updateMultiBoardField(root, objUUIDs, field, value);
    setState(() {});
  }

  void multiSaveNavField(Root root, List<String> objUUIDs, String field, dynamic value) {
    if (_root == null) return;
    Ev4rs.updateMultiNavField(root, objUUIDs, field, value);
    setState(() {});
  }

  void multiSaveGrammerField(Root root, List<String> objUUIDs, String field, dynamic value) {
    if (_root == null) return;
    Ev4rs.updateMultiGrammerField(root, objUUIDs, field, value);
    setState(() {});
  }

  @override
  void initState() {
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

  final ValueNotifier<int> currentIndex = ValueNotifier(0);

  void _openBoard(BoardObjects board) {
    

    final idx = _root!.boards.indexWhere((b) => b.id == board.id);
    if (idx != -1) {
      setState(() {
        _boardHistory.add( V4rs.syncIndex);
         V4rs.syncIndex = idx;
         currentIndex.value = currentIndex.value + 1;
      });
    }
  }

  void _goBackBoard() {
    if (_boardHistory.isNotEmpty) {
      setState(() {
         V4rs.syncIndex = _boardHistory.removeLast();
      });
    }
  }

  BoardObjects? _findBoardById(String uuid, List<BoardObjects> boards) {
    for (var b in boards) {
      if (b.id == uuid) return b;
    }
    return null;
  }

  void _toggleStorage() {
    setState(() {
      if (V4rs.isStoringOpen) {
        V4rs.isStoringOpen = false;
        V4rs.storedMessage = V4rs.message.value;
        V4rs.message.value = '';
        V4rs.saveIsStoringOpen(V4rs.isStoringOpen);
        V4rs.saveStoredMessage(V4rs.storedMessage);
      } else {
        V4rs.isStoringOpen = true;
        V4rs.message.value = V4rs.message.value + V4rs.storedMessage;
        V4rs.storedMessage = '';
        V4rs.saveIsStoringOpen(V4rs.isStoringOpen);
        V4rs.saveStoredMessage(V4rs.storedMessage);
      }
    });
  }


  @override
  Widget build(BuildContext context) {


    final media = MediaQuery.of(context);
    final screenSize = MediaQuery.of(context).size;
    final double defaultBoardHeight = screenSize.height * (7 / 12);
    final safeScreenHeight = screenSize.height - media.padding.top;
    final view = View.of(context);
    final physcialWidth = view.physicalSize.width / view.devicePixelRatio;
    final physicalHeight = view.physicalSize.height / view.devicePixelRatio;
    final isShrunk = (physcialWidth > (screenSize.width - 10)) 
        || ((physicalHeight > (screenSize.height - 10)));

    V4rs.isLandscape = screenSize.width > screenSize.height;
    V4rs.xSmallModeWidth = (screenSize.width <= 500);
    V4rs.xSmallModeHeight = (screenSize.height <= 600);
    V4rs.xSmallMode = V4rs.xSmallModeHeight || V4rs.xSmallModeWidth;
    V4rs.smallEditorMode = (screenSize.width <= 900);
  
    final double boardHeight = (V4rs.isLandscape) && (V4rs.keyboardheight > 0) && (!isShrunk)
        ? V4rs.keyboardheight
        : defaultBoardHeight;
    
    double availableFlex = safeScreenHeight - boardHeight;
    if (availableFlex < 0) availableFlex = 0;

    final double flexForMW = V4rs.xSmallMode ? 12 : 10;
    final double flexNav = V4rs.xSmallMode ? 6 : 8;
    final double flexGrammer = 4;
    final double totalFlex = flexGrammer + flexNav + flexForMW;

    final double mwHeight = availableFlex * (flexForMW / totalFlex);
    final double navHeight = (Bv4rs.showNavRow == 3) ? 0 : availableFlex * (flexNav / totalFlex);
    final double grammerHeight = (Bv4rs.showGrammerRow == 3) ? 0 : availableFlex * (flexGrammer / totalFlex);
    final double boardFlex = ((Bv4rs.showGrammerRow == 3) 
      ? availableFlex * (flexGrammer / totalFlex) 
      : 0) 
      + ((Bv4rs.showNavRow == 3) 
      ? availableFlex * (flexNav / totalFlex) 
      : 0);

    final double totalBoardHeight = boardHeight + boardFlex;
 

    Widget navListener(Widget returning) {
      return ValueListenableBuilder(
        valueListenable: CombinedValueNotifier(
          Ev4rs.navSelectedUUIDs,
          Ev4rs.firstNavSelectedUUID,
          Ev4rs.secondNavSelectedUUID,
          Ev4rs.selectedUUIDs,
          Ev4rs.grammerSelectedUUIDs,
          Ev4rs.firstGrammerSelectedUUID,
          Ev4rs.secondGrammerSelectedUUID,
          Ev4rs.selectedBoardUUID,
          null,
        ),
        builder: (context, values, _) {
          return returning;
        },
      );
    }
    
    return FutureBuilder<Root>(
      future: rootFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
         _root = snapshot.data!;
        }
        
        if (_root == null) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data found'));
          }
        }

        Widget lastEditor = SingleChildScrollView( 
          child: BaseEditor(root: _root!,)
        );

        Widget buildEditor(){
          Widget editor;

          //board editor
          if (Ev4rs.boardEditor.value == true){
            if (Ev4rs.grammerRowEditor.value == true){
              editor = SingleChildScrollView( 
              child: GrammerRowEditor(saveField: saveGrammerField, openBoard: _openBoard, root: _root!, goBack: _goBackBoard,)
            );
            } else {
            editor = SingleChildScrollView( 
              child: BoardEditor(saveField: saveField, openBoard: _openBoard, root: _root!, goBack: _goBackBoard,)
            );
            }
          }

          //edit a button
          else if (Ev4rs.editAButton.value == true && Ev4rs.selectedButton.value != null){
            editor = SingleChildScrollView(child: 
              (Ev4rs.selectedUUIDs.value.isNotEmpty) 
              ? MultiButtonEditor(saveField: multiSaveField,root: _root!, obj: Ev4rs.selectedButton.value!) 
              : ButtonEditor(saveField: saveField, root: _root!, obj: Ev4rs.selectedButton.value!)
            );
          } 

          //edit a sub folder
          else if (Ev4rs.editASubFolder.value == true && Ev4rs.subFolderSelectedButton.value != null){ 
            editor = SingleChildScrollView( 
              child: (Ev4rs.subFolderSelectedUUIDs.value.isNotEmpty) 
              ? MultiSubFolderEditor(saveField: multiSaveField, root: _root!, obj: Ev4rs.subFolderSelectedButton.value!) 
              : SubFolderEditor(saveField: saveField, root: _root!, obj: Ev4rs.subFolderSelectedButton.value!)
            );
          } 

          //edit a grammer button
          else if (Ev4rs.editAGrammerButton.value == true && Ev4rs.grammerSelectedButton.value != null){ 
            editor = SingleChildScrollView( 
              child: (Ev4rs.grammerSelectedUUIDs.value.isNotEmpty) 
              ? MultiGrammerEditor(saveField: multiSaveGrammerField, root: _root!, obj: Ev4rs.grammerSelectedButton.value!) 
              : GrammerEditor(saveField: saveGrammerField, root: _root!, obj: Ev4rs.grammerSelectedButton.value!)
            );
          } 

          //edit a nav button
          else if (Ev4rs.editANavButton.value == true && Ev4rs.navSelectedButton.value != null){
            editor = SingleChildScrollView( 
              child: (Ev4rs.navSelectedUUIDs.value.isNotEmpty) 
              ? MultiNavButtonEditor(saveField: multiSaveNavField, root: _root!, obj: Ev4rs.navSelectedButton.value!) 
              : NavButtonEditor(saveField: saveNavField, root: _root!, obj: Ev4rs.navSelectedButton.value!)
            );
          } 
          
          //show previous (last editor is initialized as base so if no last will be base)
          else {
            editor = lastEditor;
          }

          lastEditor = editor;

          return editor;
        }


        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            bottom: false,
            child: 
              ValueListenableBuilder<bool>(
                valueListenable: Ev4rs.isButtonExpanded, 
                builder: (context, isButtonExpanded, _) {
                
                if (!Ev4rs.isButtonExpanded.value) {
                return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                      // 
                      //editor window row
                      //
                        Stack(
                          children: [
                            SizedBox(
                              height: mwHeight,
                              child: Container(
                                color: Cv4rs.themeColor2,
                                child: ValueListenableBuilder(
                                valueListenable: CombinedValueNotifier(
                                    Ev4rs.editAButton, Ev4rs.editASubFolder, Ev4rs.subFolderSelectedUUIDs, 
                                    Ev4rs.selectedUUIDs, Ev4rs.selectedButton, Ev4rs.subFolderSelectedButton, 
                                    Ev4rs.invertSelections, Ev4rs.boardEditor, Ev4rs.navSelectedButton
                                  ), 
                                  builder: (context, values, _) {

                                return ValueListenableBuilder(
                                valueListenable: CombinedValueNotifier(
                                    Ev4rs.editAGrammerButton, Ev4rs.grammerSelectedUUIDs, Ev4rs.grammerSelectedButton, 

                                    Ev4rs.selectedUUIDs, Ev4rs.selectedButton, Ev4rs.subFolderSelectedButton, 
                                    Ev4rs.invertSelections, Ev4rs.grammerRowEditor, null
                                  ), 
                                  builder: (context, values, _) {
                                    return buildEditor();
                                  },
                                );
                                },
                                ),
                              ),
                            ),
                            SaveIndicator(),
                          ]
                        ),
                        // Navigation row
                        SizedBox(
                              height: navHeight,
                              child: Container(
                                color: Cv4rs.themeColor3,
                                child: (Bv4rs.showNavRow == 2) 
                                ? SizedBox.expand() 
                                : IndexedStack(index: 0, children: [
                                  ValueListenableBuilder(
                                    valueListenable: Ev4rs.navSelectedUUIDs,
                                    builder: (context, values, _) {
                                    return Row(
                                    children: [
                                      for (var navObj in _root!.navRow)
                                        Flexible(
                                          child: navListener(
                                            navObj.buildEditableWidget(
                                              _root!,
                                              widget.synth,
                                              navObj,
                                              _toggleStorage,
                                              _openBoard,
                                              _root!.boards,
                                              _findBoardById,
                                              widget.speakSelectSherpaOnnxSynth,
                                              widget.initForSS,
                                              widget.playerForSS,
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                    }
                                  ),
                                ]),
                              ),
                            ),
                        // Grammar row
                        ValueListenableBuilder(
                                        valueListenable:
                                      CombinedValueNotifier(
                                        Ev4rs.grammerSelectedUUIDs, Ev4rs.firstGrammerSelectedUUID, 
                                        Ev4rs.secondGrammerSelectedUUID, Ev4rs.selectedUUIDs, 
                                        
                                        Ev4rs.grammerSelectedUUIDs, Ev4rs.firstGrammerSelectedUUID, 
                                        Ev4rs.secondGrammerSelectedUUID, null, null ),
                                        builder: (context, values, _) {
                        return SizedBox(
                          height: grammerHeight,
                          child: Container(
                            color: Cv4rs.themeColor4,
                            child: (Bv4rs.showGrammerRow == 2) 
                            ? SizedBox.expand() 
                            : IndexedStack(
                              index:  V4rs.syncIndex,
                              children: [
                                for (var board in _root!.boards)
                                  Builder(
                                    builder: (context) {
                                      GrammerObjects? row;
                                        try {
                                          row = _root!.grammerRow.firstWhere(
                                            (row) => row.id == board.useGrammerRow,
                                          );
                                        } catch (_) {
                                          row = null;
                                        }

                                      if (row == null) {
                                        return const SizedBox.shrink(); // nothing if missing
                                      }
                                      return row.buildEditableWidget(
                                        widget.synth,
                                        _root!,
                                        _openBoard,
                                        _root!.boards,
                                        _findBoardById,
                                        widget.speakSelectSherpaOnnxSynth,
                                        widget.initForSS,
                                        widget.playerForSS,
                                      );
                                    },
                                  ),
                              ],
                            )
                          ),
                        );
                                        }
                                        ),
                        // Board row
                        ValueListenableBuilder(
                        valueListenable: CombinedValueNotifier(
                            Ev4rs.selectedUUIDs, Ev4rs.subFolderSelectedUUIDs, Ev4rs.firstSubFolderSelectedUUID, 
                            Ev4rs.secondSubFolderSelectedUUID, Ev4rs.firstSelectedUUID, Ev4rs.secondSelectedUUID, 
                            Ev4rs.dragSelectMultiple, currentIndex, 
                            CombinedValueNotifier(
                              Ev4rs.grammerSelectedUUIDs, Ev4rs.firstGrammerSelectedUUID, Ev4rs.secondGrammerSelectedUUID, 

                              Ev4rs.secondSubFolderSelectedUUID, Ev4rs.firstSelectedUUID, Ev4rs.secondSelectedUUID, 
                              Ev4rs.dragSelectMultiple, null, null
                            ),
                          ), 
                        builder: (context, values, _) {
                          return (!Ev4rs.dragSelectMultiple.value) ?
                            SizedBox(
                              height: totalBoardHeight,
                              child: Container(
                                color: Cv4rs.themeColor4,
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: IndexedStack(
                                          index:  V4rs.syncIndex,
                                          children: [
                                            for (var board in _root!.boards)
                                              board.buildEditWidget(
                                                board,
                                                widget.synth,
                                                _root!,
                                                _goBackBoard,
                                                _openBoard,
                                                _openBoard,
                                                _root!.boards,
                                                _findBoardById,

                                        widget.speakSelectSherpaOnnxSynth,
                                        widget.initForSS,
                                        widget.playerForSS,
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (_selectionRect != null)
                                        Positioned.fromRect(
                                          rect: _selectionRect!,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue.withValues(alpha: 0.2),
                                              border: Border.all(color: Colors.blue, width: 2),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                              ),
                            )
                            : SizedBox(
                              height: totalBoardHeight,
                              child: Container(
                                color: Cv4rs.themeColor4,
                                child: GestureDetector(
                                  key: _gestureDetectorKey,
                                  
                                  onPanStart: (details) {
                                    setState(() {
                                      _dragStart = details.localPosition;
                                      _selectionRect = null;
                                    });
                                  },
                                  onPanUpdate: (details) {
                                    setState(() {
                                      _selectionRect = Rect.fromPoints(_dragStart!, details.localPosition);
                                      _updateSelection();
                                      Ev4rs.selectedUUID = Ev4rs.selectedUUIDs.value.first;
                                    });
                                  },
                                  onPanEnd: (_) {
                                    setState(() {
                                      _dragStart = null;
                                      _selectionRect = null;
                                    });
                                  },
                                  child: 
                                      Center(
                                        child: IndexedStack(
                                          index:  V4rs.syncIndex,
                                          children: [
                                            for (var board in _root!.boards)
                                              board.buildEditWidget(
                                                board,
                                                widget.synth,
                                                _root!,
                                                _goBackBoard,
                                                _openBoard,
                                                _openBoard,
                                                _root!.boards,
                                                _findBoardById,

                                        widget.speakSelectSherpaOnnxSynth,
                                        widget.initForSS,
                                        widget.playerForSS,
                                              ),
                                          ],
                                        ),
                                      ),
                                ),
                              ),
                            );
                                  }
                            )
                      ],
                    );
                    
                } 

                //
                //Expanded View
                //
                else {
                  return Container(
                    height: screenSize.height,
                    width: screenSize.width,
                      color: Cv4rs.themeColor2,
                      child:
                        ValueListenableBuilder<bool>(
                            valueListenable: Ev4rs.editAButton,
                            builder: (context, isEditing, _) {

                        return ValueListenableBuilder<bool>(
                            valueListenable: Ev4rs.editASubFolder,
                            builder: (context, isEditingSubFolder, _) {

                        return ValueListenableBuilder<BoardObjects?>(
                          valueListenable: Ev4rs.selectedButton,
                          builder: (context, whatIsSelected, _) {

                        return ValueListenableBuilder<bool>(
                            valueListenable: Ev4rs.editAGrammerButton,
                            builder: (context, isEditingSubFolder, _) {
                              
                              return ValueListenableBuilder<BoardObjects?>(
                                valueListenable: Ev4rs.subFolderSelectedButton,
                                builder: (context, whatIsSelected, _) {
                                  return buildEditor();
                                }
                              );
                            }
                        );
                              },
                             );
                            }
                           );
                            }
                          )
                          );//
                        }
                      }
                 
                    ),
          ),
        );
      },
    );
  
  }

}