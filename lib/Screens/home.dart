import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Screens/rows/message_row.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Variables/editing/save_indicator.dart';
import 'package:flutterkeysaac/Variables/export_variables.dart';
import 'package:flutterkeysaac/Variables/more_font_variables.dart';
import 'package:flutterkeysaac/Screens/settings.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  final TTSInterface synth;
  final int? highlightStart;
  final int? highlightLength;

  const Home({
    super.key,
    required this.synth,
    this.highlightStart,
    this.highlightLength,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  final GlobalKey _printKey = GlobalKey();

  Future<void> _waitForBoundaryReady(RenderRepaintBoundary boundary) async {
  int retries = 0;

  // Wait for up to 10 frames (~300ms)
  while (boundary.debugNeedsPaint && retries < 10) {
    await Future.delayed(const Duration(milliseconds: 30));
    await WidgetsBinding.instance.endOfFrame;
    retries++;
  }
}

  late Future<Root> rootFuture;
  Root? _root;

  int _currentBoardIndex = 0; 
  //this is based on the location in the indexed stack where the buttons are rendered, not by the json file
  
  final List<int> _boardHistory = [];

  @override
  void initState() {
    super.initState();
    rootFuture = V4rs.loadRootData();
  }

  void _openBoard(BoardObjects board) {
    final idx = _root!.boards.indexWhere((b) => b.id == board.id);
    if (idx != -1) {
      setState(() {
        _boardHistory.add(_currentBoardIndex);
        _currentBoardIndex = idx;
        V4rs.syncIndex = _currentBoardIndex;
        V4rs.thisBoard = board;
      });
    }
  }

  void _openBoardWithReturn(BoardObjects board) {
    final idx = _root!.boards.indexWhere((b) => b.id == board.id);
    if (idx != -1) {
      setState(() {
        _boardHistory.add(_currentBoardIndex);
        _currentBoardIndex = idx;
        V4rs.syncIndex = _currentBoardIndex;
        V4rs.thisBoard = board;
      });
      //listener defined
      void listener() {
          //listener triggered- remove and return
          V4rs.message.removeListener(listener);
          _goBackBoard(board);
        }
      // listener attached
      V4rs.message.addListener(listener);
    }
  }

  void _goBackBoard(BoardObjects board) {
    if (_boardHistory.isNotEmpty) {
      setState(() {
        _currentBoardIndex = _boardHistory.removeLast();
        V4rs.syncIndex = _currentBoardIndex;
        V4rs.thisBoard = board;
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
    final double defaultBoardHeight = screenSize.height * (4 / 6);
    final isLandscape = screenSize.width > screenSize.height;
    final safeScreenHeight = screenSize.height - media.padding.top;

    final double boardHeight = isLandscape && V4rs.keyboardheight > 0
        ? V4rs.keyboardheight
        : defaultBoardHeight;
    
    double availableFlex = safeScreenHeight - boardHeight;
    if (availableFlex < 0) availableFlex = 0;

    final double flexForMW = 10;
    final double flexNav = 8;
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
          if (_root != null){
            V4rs.thisBoard = _root!.boards[_currentBoardIndex];
          }

        return Stack(children: [
          if (V4rs.showSettings.value)
                Settings(
                  synth: widget.synth,
                  captureAllForPrint: captureAllForPrint,
                ),

          if (!V4rs.showSettings.value)
          Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Message row
                  SizedBox(
                    height: mwHeight,
                    child: Container(
                      color: Cv4rs.themeColor2,
                      child: MessageRow(
                        root: _root!,
                        synth: widget.synth,
                        highlightStart: widget.highlightStart,
                        highlightLength: widget.highlightLength,
                      ),
                    ),
                  ),

                  // Navigation row
                  SizedBox(
                    height: navHeight,
                    child: Container(
                      color: Cv4rs.themeColor3,
                      child: (Bv4rs.showNavRow == 2) 
                      ? SizedBox.expand() 
                      : Row(
                        children: [
                          for (var navObj in _root!.navRow)
                            Flexible(
                              child: navObj.buildWidget(
                                  widget.synth,
                                  _toggleStorage,
                                  _openBoard,
                                  _root!.boards,
                                  _findBoardById,
                                  navObj,
                                ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Grammar row
                  SizedBox(
                    height: grammerHeight,
                    child: Container(
                      color: Cv4rs.themeColor4,
                      child: (Bv4rs.showGrammerRow == 2) 
                      ? SizedBox.expand() 
                      : IndexedStack(
                        index: _currentBoardIndex,
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

                                return row.buildWidget(
                                  widget.synth,
                                  _openBoard,
                                  _root!.boards,
                                  _findBoardById,
                                );
                              },
                            ),
                        ],
                      )
                    ),
                  ), 

                  // Board row
                  SizedBox(
                    height: totalBoardHeight,
                    child: Container(
                      color: Cv4rs.themeColor4,
                      child: Center( child:
                      IndexedStack(
                        index: _currentBoardIndex,
                        children: [
                          for (var board in _root!.boards)
                              board.buildWidget(
                                board,
                                widget.synth,
                                () => _goBackBoard(board),
                                _openBoard,
                                _openBoardWithReturn,
                                _root!.boards,
                                _findBoardById,
                              ),
                        ],
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }

  Future<Uint8List?> captureForPrint(BoardObjects board) async {
    try {

    final media = MediaQuery.of(context);
    final screenSize = MediaQuery.of(context).size;
    final double defaultBoardHeight = screenSize.height * (4 / 6);
    final isLandscape = screenSize.width > screenSize.height;
    final safeScreenHeight = screenSize.height - media.padding.top;

    final double boardHeight = isLandscape && V4rs.keyboardheight > 0
        ? V4rs.keyboardheight
        : defaultBoardHeight;
    
    double availableFlex = safeScreenHeight - boardHeight;
    if (availableFlex < 0) availableFlex = 0;

    final double flexForMW = 10;
    final double flexNav = 8;
    final double flexForIndicator = (ExV4rs.includeMessageRow == 3) ? 10 : 6;
    final double paddingForIndicator = (ExV4rs.includeMessageRow == 3) ? 15 : 6;
    final double flexGrammer = 4;
    final double totalFlex 
        = flexForMW
        + flexNav
        + flexForIndicator 
        + flexGrammer;

    final double mwHeight = availableFlex * (flexForMW / totalFlex);
    final double indicatorHeight = availableFlex * (flexForIndicator / totalFlex);
    final double navHeight = (Bv4rs.showNavRow == 3) ? 0 : availableFlex * (flexNav / totalFlex);
    final double grammerHeight = (Bv4rs.showGrammerRow == 3) ? 0 : availableFlex * (flexGrammer / totalFlex);
    final double boardFlex = ((Bv4rs.showGrammerRow == 3) || (ExV4rs.includeGrammerRow != 3)
      ? availableFlex * (flexGrammer / totalFlex) 
      : 0) 
      + ((Bv4rs.showNavRow == 3) || (ExV4rs.includeNavRow != 3)
      ? availableFlex * (flexNav / totalFlex) 
      : 0);

    final double totalBoardHeight = boardHeight + boardFlex;
    final Completer<void> paintCompleter = Completer();

      // Build a temporary print widget off-screen
      final overlay = OverlayEntry(
  builder: (_) => Transform.translate(
    offset: Offset(screenSize.width, 0),
    child: RepaintBoundary(
      key: _printKey,
      child: FutureBuilder<Root>(
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
            if (_root != null){
              V4rs.thisBoard = _root!.boards[_currentBoardIndex];
            }
          if (!paintCompleter.isCompleted) {
      // Wait until this frame is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!paintCompleter.isCompleted) {
  paintCompleter.complete();
}
      });
    }

  

          return Stack(children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                bottom: false,
                child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Message row
                    if (ExV4rs.includeMessageRow == 1)
                    SizedBox(
                      height: mwHeight,
                      child: Container(
                        color: Cv4rs.themeColor2,
                        child: MessageRow(
                          root: _root!,
                          synth: widget.synth,
                          highlightStart: widget.highlightStart,
                          highlightLength: widget.highlightLength,
                        ),
                      ),
                    ),

                    if (ExV4rs.includeMessageRow == 2) 
                    SizedBox(
                      height: mwHeight,
                      child: Container(
                        color: Cv4rs.themeColor2,
                        )
                      ),

                    if (ExV4rs.includeMessageRow == 3) 
                    SizedBox.shrink(),

                    //Indicator 
                    if (ExV4rs.includeIndicatorRow)
                     SizedBox(
                      height: indicatorHeight,
                      child: Container(
                        color: Cv4rs.themeColor2,
                        child: Row(
                          children: [
                            Spacer(flex: 1),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Cv4rs.themeColor4,
                              ),
                              child: Padding(padding: EdgeInsetsGeometry.all(paddingForIndicator), child:
                              Text(
                                  ExV4rs.indicator1, 
                                  style: Fv4rs.buttonLabelStyle,
                                ),
                              ),
                            ),
                            Spacer(flex: 2),
                            Container(
                              decoration: BoxDecoration(
                                color: Cv4rs.themeColor4,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(padding: EdgeInsetsGeometry.all(paddingForIndicator), child:
                              Text(
                                  ExV4rs.indicator2, 
                                  style: Fv4rs.buttonLabelStyle,
                                  ),
                                ),
                            ),
                            Spacer(flex: 2),
                            Container(
                              decoration: BoxDecoration(
                                color: Cv4rs.themeColor4,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(padding: EdgeInsetsGeometry.all(paddingForIndicator), child:
                              Text(
                                  ExV4rs.indicator3, 
                                  style: Fv4rs.buttonLabelStyle,
                                  ),
                                ),
                            ),
                            Spacer(flex: 1),
                          ],
                        )
                      
                     ),
                    ),

                    // Navigation row
                    if (ExV4rs.includeNavRow == 1)
                    SizedBox(
                      height: navHeight,
                      child: Container(
                        color: Cv4rs.themeColor3,
                        child: (Bv4rs.showNavRow == 2) 
                        ? SizedBox.expand() 
                        : Row(
                          children: [
                            for (var navObj in _root!.navRow)
                              Flexible(
                                child: navObj.buildWidget(
                                    widget.synth,
                                    _toggleStorage,
                                    _openBoard,
                                    _root!.boards,
                                    _findBoardById,
                                    navObj,
                                  ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    if (ExV4rs.includeNavRow == 2)
                    SizedBox(
                      height: navHeight,
                      child: Container(
                        color: Cv4rs.themeColor3,
                        )
                      ),

                    if (ExV4rs.includeNavRow == 3)
                    SizedBox.shrink(),

                    // Grammar row
                    if (ExV4rs.includeGrammerRow == 1)
                    SizedBox(
                      height: grammerHeight,
                      child: Container(
                        color: Cv4rs.themeColor4,
                        child: (Bv4rs.showGrammerRow == 2) 
                        ? SizedBox.expand() 
                        : IndexedStack(
                          index: _currentBoardIndex,
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

                                  return row.buildWidget(
                                    widget.synth,
                                    _openBoard,
                                    _root!.boards,
                                    _findBoardById,
                                  );
                                },
                              ),
                          ],
                        )
                      ),
                    ), 
                    
                    if (ExV4rs.includeGrammerRow == 2)
                    SizedBox(
                      height: navHeight,
                      child: Container(
                        color: Cv4rs.themeColor3,
                        )
                      ),

                    if (ExV4rs.includeGrammerRow == 3)
                    SizedBox.shrink(),

                    // Board row
                    SizedBox(
                      height: totalBoardHeight,
                      child: Container(
                        color: Cv4rs.themeColor4,
                        child: Center( child:
                                board.buildWidget(
                                  board,
                                  widget.synth,
                                  () => _goBackBoard(board),
                                  _openBoard,
                                  _openBoardWithReturn,
                                  _root!.boards,
                                  _findBoardById,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
            
              ),
            ),
            Positioned(top: 0, left: 0, right: 0, child: SaveIndicator()),
          ]);
        
        },
        ),
      ),
      ),
        );
        ExV4rs.loadingPrint.value = true;
        Overlay.of(context, rootOverlay: true).insert(overlay);
        
        await paintCompleter.future;

       // Wait for up to 10 frames for any FutureBuilders to resolve images
        for (int i = 0; i < 10; i++) {
          await Future.delayed(const Duration(milliseconds: 20));  // ~1 frame
          await WidgetsBinding.instance.endOfFrame;
        }

        // Ensure boundary is ready
        RenderRepaintBoundary? boundary =
            _printKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

        if (boundary == null || boundary.debugNeedsPaint) {
          // Wait another frame if widget not yet painted
          await WidgetsBinding.instance.endOfFrame;

          boundary = _printKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
        }

        // If still null → bail
        if (boundary == null || boundary.debugNeedsPaint) {
          overlay.remove();
          throw Exception("Render boundary not ready for capture");
        }

        await _waitForBoundaryReady(boundary);

        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

        overlay.remove();
        ExV4rs.loadingPrint.value = false;
        return byteData?.buffer.asUint8List();
      } catch (e) {
        print("Error capturing print layout: $e");
        return null;
      }
    }

  Future<List<Uint8List>> captureAllForPrint() async {
    final List<Uint8List> pages = [];

    for (final board in _root!.boards) {

      final image = await captureForPrint(board);

      if (image != null) {
        pages.add(image);
      }
    }

    return pages;
  }
}
