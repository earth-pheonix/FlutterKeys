import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Screens/rows/message_row.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';

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
      });
      //listener defined
      void listener() {
          //listener triggered- remove and return
          V4rs.message.removeListener(listener);
          _goBackBoard();
        }
      // listener attached
      V4rs.message.addListener(listener);
    }
  }

  void _goBackBoard() {
    if (_boardHistory.isNotEmpty) {
      setState(() {
        _currentBoardIndex = _boardHistory.removeLast();
        V4rs.syncIndex = _currentBoardIndex;
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

    final double flexForMW = 8;
    final double flexNav = 6;
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

        return Scaffold(
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
                            _goBackBoard,
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
        );
      },
    );
  }
}