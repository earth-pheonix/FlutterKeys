import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editable_buttons.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';


class BoardObjects {
  String id;
  String? useGrammerRow;
  String? type1;
  String? title;
  bool? matchFormat;
  int? format;
  int? useSubFolders;
  int? rowCount;
  int? columnCount;

  List<BoardObjects> content;

  int? type; //1= button, 2= pocket folder, 3= folder, 4= typing key, 5 = sound tile, 6 grammer
  String? function;
  String? label;
  String? alternateLabel;
  String? message;
  String? audioClip;
  String? linkToLabel;
  String? linkToUUID;
  bool? returnAfterSelect;
  bool? show;

  bool? matchPOS;
  String? pos;
  Color? backgroundColor;

  bool? matchBorder;
  double? borderWeight;
  Color? borderColor;

  bool? matchFont;
  String? fontFamily;
  double? fontSize;
  double? fontWeight;
  bool? fontItalics;
  bool? fontUnderline;
  Color? fontColor;

  String? symbol;
  double? padding;
  bool? matchOverlayColor;
  Color? overlayColor;
  bool? matchSymbolSaturation;
  double? symbolSaturation;
  bool? matchSymbolContrast;
  double? symbolContrast;
  bool? matchInvertSymbol;
  bool? invertSymbol;

  bool? matchSpeakOS;
  int? speakOS;

  String? note;

  BoardObjects({
    required this.id,
    this.function,
    this.useGrammerRow,
    this.useSubFolders,
    this.type1,
    this.title,
    this.matchFormat,
    this.format,
    this.rowCount,
    this.columnCount,
    required this.content,
    this.type,
    this.alternateLabel,
    this.label,
    this.message,
    this.audioClip,
    this.linkToLabel,
    this.linkToUUID,
    this.returnAfterSelect,
    this.show,
    this.matchPOS,
    this.pos,
    this.backgroundColor,
    this.matchBorder,
    this.borderWeight,
    this.borderColor,
    this.matchFont,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.fontItalics,
    this.fontUnderline,
    this.fontColor,
    this.symbol,
    this.padding,
    this.matchOverlayColor,
    this.overlayColor,
    this.matchSymbolSaturation,
    this.symbolSaturation,
    this.matchSymbolContrast,
    this.symbolContrast,
    this.matchInvertSymbol,
    this.invertSymbol,
    this.matchSpeakOS,
    this.speakOS,
    this.note,
  });

  /// Factory constructor for JSON deserialization
  factory BoardObjects.fromJson(Map<String, dynamic> json) {
    try{
    return BoardObjects(
      id: json['id'] as String,
      function: json['function'] as String?,
      useGrammerRow: json['useGrammerRow'] as String?,
      useSubFolders: json['useSubFolders'] as int?,
      type1: json['type1'] as String?,
      title: json['title'] as String?,
      matchFormat: json['matchFormat'] as bool?,
      format: (json['format'] as num?)?.toInt(),
      rowCount: (json['rowCount'] as num?)?.toInt(),
      columnCount: (json['columnCount'] as num?)?.toInt(),
      content: (json['content'] as List<dynamic>?)
              ?.map((e) => BoardObjects.fromJson(e))
              .toList() ??
          [],
      type: (json['type'] as num?)?.toInt(),
      label: json['label'] as String?,
      alternateLabel: json['alternateLabel'] as String?,
      message: json['message'] as String?,
      audioClip: json['audioClip'] as String?,
      linkToLabel: json['linkToLabel'] as String?,
      linkToUUID: json['linkToUUID'] as String?,
      returnAfterSelect: json['returnAfterSelect'] as bool?,
      show: json['show'] as bool?,
      matchPOS: json['matchPOS'] as bool?,
      pos: json['pos'] as String?,
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'] as int)
          : null,
      matchBorder: json['matchBorder'] as bool?,
      borderWeight: (json['borderWeight'] as num?)?.toDouble(),
      borderColor: json['borderColor'] != null
          ? Color(json['borderColor'] as int)
          : null,
      matchFont: json['matchFont'] as bool?,
      fontFamily: json['fontFamily'] as String?,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: (json['fontWeight'] as num?)?.toDouble(),
      fontItalics: json['fontItalics'] as bool?,
      fontUnderline: json['fontUnderline'] as bool?,
      fontColor: json['fontColor'] != null
          ? Color(json['fontColor'] as int)
          : null,
      symbol: json['symbol'] as String?,
      padding: (json['padding'] as num?)?.toDouble(),
      matchOverlayColor: json['matchOverlayColor'] as bool?,
      overlayColor: json['overlayColor'] != null
          ? Color(json['overlayColor'] as int)
          : null,
      matchSymbolSaturation: json['matchSymbolSaturation'] as bool?,
      symbolSaturation: (json['symbolSaturation'] as num?)?.toDouble(),
      matchSymbolContrast: json['matchSymbolContrast'] as bool?,
      symbolContrast: (json['symbolContrast'] as num?)?.toDouble(),
      matchInvertSymbol: json['matchInvertSymbol'] as bool?,
      invertSymbol: json['invertSymbol'] as bool?,
      matchSpeakOS: json['matchSpeakOS'] as bool?,
      speakOS: json['speakOS'] as int?,
      note: json['note'] as String?,
    );
  }  catch (e, stack) {
    print('error in board: $e');
    print('Offending stack: $stack');
    V4rs.deleteLocalCopy();
    rethrow;
  }
}

  /// Converts object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'useGrammerRow': useGrammerRow,
      'function': function,
      'useSubFolders': useSubFolders,
      'type1': type1,
      'title': title,
      'matchFormat': matchFormat,
      'format': format,
      'rowCount': rowCount,
      'columnCount': columnCount,
      'content': content.map((e) => e.toJson()).toList(),
      'type': type,
      'label': label,
      'alternateLabel': alternateLabel,
      'message': message,
      'audioClip': audioClip,
      'linkToLabel': linkToLabel,
      'linkToUUID': linkToUUID,
      'returnAfterSelect': returnAfterSelect,
      'show': show,
      'matchPOS': matchPOS,
      'pos': pos,
      'backgroundColor': backgroundColor?.toARGB32(),
      'matchBorder': matchBorder,
      'borderWeight': borderWeight,
      'borderColor': borderColor?.toARGB32(),
      'matchFont': matchFont,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'fontItalics': fontItalics,
      'fontUnderline': fontUnderline,
      'fontColor': fontColor?.toARGB32(),
      'symbol': symbol,
      'padding': padding,
      'matchOverlayColor': matchOverlayColor,
      'overlayColor': overlayColor?.toARGB32(),
      'matchSymbolSaturation': matchSymbolSaturation,
      'symbolSaturation': symbolSaturation,
      'matchSymbolContrast': matchSymbolContrast,
      'symbolContrast': symbolContrast,
      'matchInvertSymbol': matchInvertSymbol,
      'invertSymbol': invertSymbol,
      'matchSpeakOS': matchSpeakOS,
      'speakOS': speakOS,
      'note': note,
    };
  }
}

extension BoardsDisplay on BoardObjects {

  Widget buildWidget(
    BoardObjects obj,
    TTSInterface synth, 
    void Function() goBack, 
    void Function(BoardObjects) openBoard, 
    void Function(BoardObjects) openBoardWithReturn, 
    List<BoardObjects> boards, 
    BoardObjects? Function(String uuid, List<BoardObjects> boards) 
    findBoardById) {
      
    switch (format) {
      case 1:
        int index = (V4rs.useSubFoldersAsBool(obj.useSubFolders ?? 3)) ? 0 : 5; // keep track of where we are in content[]

        return Column(
          children: [
            // === Row 0 === 
            if (V4rs.useSubFoldersAsBool(obj.useSubFolders ?? 3))
            Flexible(
              flex: 34,
              child: 
            Column( children: [
             Spacer(flex: 2),
             Expanded(
              flex: 26,
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 1),
                Expanded(flex: 24, child: BuildSubFolder(obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, openBoardWithReturn: openBoardWithReturn, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2), // Special 1
                Expanded(flex: 36, child: BuildSubFolder(obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, openBoardWithReturn: openBoardWithReturn, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2), // Subfolder
                Expanded(flex: 36, child: BuildSubFolder(obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, openBoardWithReturn: openBoardWithReturn, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2),
                Expanded(flex: 36, child: BuildSubFolder(obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, openBoardWithReturn: openBoardWithReturn, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2),
                Expanded(flex: 24, child: BuildSubFolder(obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, openBoardWithReturn: openBoardWithReturn, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 1), // Special 2
              ],
            ),
             ),
             Spacer(flex: 6),
            ]),
            ),
            

            // === Row 1 === 
            Expanded(
              flex: 36,
              child: 
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSpacer(1), // half spacer
                for (int i = 0; i < 11; i++) ...[
                  Expanded(flex: 10, child: buildBoardObjectWidget(content[index++], synth, openBoard, openBoardWithReturn, boards, findBoardById)),
                  if (i < 10) buildSpacer(2), //full Spacer
                ],
                buildSpacer(1), // half spacer
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
                buildSpacer(21), // special first spacer
                for (int i = 0; i < 10; i++) ...[
                  Expanded(flex: 36, child: buildBoardObjectWidget(content[index++], synth, openBoard, openBoardWithReturn, boards, findBoardById)),
                if (i < 9)
                  buildSpacer((i == 8) ? 21 : 7), // if is 7 or 8 do the first 
                ],
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
                buildSpacer(6), // special first spacer
                for (int i = 0; i < 11; i++) ...[
                 Expanded(flex: 47, child: buildBoardObjectWidget(content[index++], synth, openBoard, openBoardWithReturn, boards, findBoardById)),
                  if (i < 10)
                    buildSpacer((i == 9) ? 19 : 11), //if 8 do the first
                ],
                buildSpacer(15), // last spacer
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
                buildSpacer(2), // special first
                for (int i = 0; i < 10; i++) ...[
                  Expanded(flex: 24, child: (
                    buildBoardObjectWidget(content[index++], synth, openBoard, openBoardWithReturn, boards, findBoardById)
                    )),
                  if (i < 9)
                    buildSpacer((i >= 7) ? 20 : 6), // last 3 spacers special
                ],
                buildSpacer(9), // special last
              ],
            ),
            ),
             Spacer(flex: 17),
          ],
        );

      //grid
      case 2:
        return const SizedBox.shrink(); 
      
      //alternating
      case 3:
        return const SizedBox.shrink(); 
      
      //fallback
      default:
        return const SizedBox.shrink();
    }
  }

    Widget buildSpacer(int flex) => Expanded(flex: flex, child: const SizedBox());
    Widget buildBoardObjectWidget(
      BoardObjects obj,
      TTSInterface synth,
      void Function(BoardObjects) openBoard,
      void Function(BoardObjects) openBoardWithReturn,
      List<BoardObjects> boards,
      BoardObjects? Function(String, List<BoardObjects>) findBoardById,
    ) {
      switch (obj.type) { // type = 1, 2, 3, 4, 5, 6
        case 1: //button
          return BuildButton(obj: obj, synth: synth);
        case 2: //pocketFolder
          return BuildPocketFolder(
            obj: obj,
            synth: synth,
            openBoard: openBoard,
            openBoardWithReturn: openBoardWithReturn,
            boards: boards,
            findBoardById: findBoardById,
          );
        case 3: //folder
          return BuildFolder(obj: obj, synth: synth, openBoard: openBoard, openBoardWithReturn: openBoardWithReturn, boards: boards, findBoardById: findBoardById);
        case 4: //audioTile
          return BuildAudioTile(obj: obj, synth: synth);
        case 5: //typingKey
          return BuildTypingKey(obj: obj, synth: synth);
        case 6:
          return BuildButtonGrammer(obj: obj, synth: synth);
        default:
          return const SizedBox.shrink(); // fallback
      }
    }


  Widget buildEditWidget(
    BoardObjects obj,
    TTSInterface synth, 
    Root root,
    void Function() goBack, 
    void Function(BoardObjects) openBoard, 
    void Function(BoardObjects) openBoardWithReturn,
    List<BoardObjects> boards, 
    BoardObjects? Function(String uuid, List<BoardObjects> boards) 
    findBoardById) {
      
    switch (format) {
      case 1:
        int index = (V4rs.useSubFoldersAsBool(obj.useSubFolders ?? 3)) ? 0 : 5;  // keep track of where we are in content[]
        
        return Column(
          children: [
            // === Row 0 === 
             if (V4rs.useSubFoldersAsBool(obj.useSubFolders ?? 3))
             Flexible(
              flex: 34,
              child: 
            Column( children: [
             Spacer(flex: 2),
             Expanded(
              flex: 26,
              child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 1),
                Expanded(flex: 24, child: BuildEditableSubFolder(root: root, obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2), // Special 1
                Expanded(flex: 36, child: BuildEditableSubFolder(root: root, obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2), // Subfolder
                Expanded(flex: 36, child: BuildEditableSubFolder(root: root, obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard,  boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2),
                Expanded(flex: 36, child: BuildEditableSubFolder(root: root, obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 2),
                Expanded(flex: 24, child: BuildEditableSubFolder(root: root, obj: content[index++], synth: synth, goBack: goBack, openBoard: openBoard, boards: boards, findBoardById: findBoardById,)),
                Spacer(flex: 1), // Special 2
              ],
            ),
             ),
            Spacer(flex: 6),
          ]),
             ),

            // === Row 1 === 
            Expanded(
              flex: 36,
              child: 
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSpacer(1), // half spacer
                for (int i = 0; i < 11; i++) ...[
                  Expanded(
                     
                    flex: 10, 
                    child: buildBoardEditObjectWidget(content[index++], root, synth, openBoard, boards, findBoardById)),
                  if (i < 10) buildSpacer(2), //full Spacer
                ],
                buildSpacer(1), // half spacer
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
                buildSpacer(21), // special first spacer
                for (int i = 0; i < 10; i++) ...[
                  Expanded(
                    flex: 36, 
                    child: buildBoardEditObjectWidget(content[index++], root, synth, openBoard, boards, findBoardById)),
                if (i < 9)
                  buildSpacer((i == 8) ? 21 : 7), // if is 7 or 8 do the first 
                ],
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
                buildSpacer(6), // special first spacer
                for (int i = 0; i < 11; i++) ...[
                 Expanded(
                  
                  flex: 47, 
                  child: buildBoardEditObjectWidget(content[index++], root, synth, openBoard, boards, findBoardById)),
                  if (i < 10)
                    buildSpacer((i == 9) ? 19 : 11), //if 8 do the first
                ],
                buildSpacer(15), // last spacer
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
                buildSpacer(2), // special first
                for (int i = 0; i < 10; i++) ...[
                  Expanded(
                    
                    flex: 24, 
                    child: (
                    buildBoardEditObjectWidget(content[index++], root, synth, openBoard, boards, findBoardById)
                    )),
                  if (i < 9)
                    buildSpacer((i >= 7) ? 20 : 6), // last 3 spacers special
                ],
                buildSpacer(9), // special last
              ],
            ),
            ),
             Spacer(flex: 17),
          ],
        );

      //grid
      case 2:
        return const SizedBox.shrink(); 
      
      //alternating
      case 3:
        return const SizedBox.shrink(); 
      
      //fallback
      default:
        return const SizedBox.shrink();
    }
  }
  
    Widget buildBoardEditObjectWidget(
      BoardObjects obj,
      Root root,
      TTSInterface synth,
      void Function(BoardObjects) openBoard,
      List<BoardObjects> boards,
      BoardObjects? Function(String, List<BoardObjects>) findBoardById,
    ) {
      final key = GlobalKey();
      Ev4rs.buttonKeys[obj.id] = key;

      Widget child;
      switch (obj.type) { // type = 1, 2, 3, 4, 5
        case 1: //button
          child = BuildEditableButton(obj: obj, synth: synth, root: root);
        case 2: //pocketFolder
           child = BuildEditablePocketFolder(
            obj: obj,
            synth: synth,
            openBoard: openBoard,
            boards: boards,
            findBoardById: findBoardById,
            root: root,
          );
        case 3: //folder
           child = BuildEditableFolder(obj: obj, synth: synth, openBoard: openBoard, boards: boards, findBoardById: findBoardById, root: root);
        case 4: //audioTile
           child = BuildEditableAudioTile(obj: obj, synth: synth, root: root);
        case 5: //typingKey
           child = BuildEditableTypingKey(obj: obj, synth: synth, root: root);
        case 6:
           child = BuildEditableButtonGrammer(obj: obj, synth: synth, root: root);
        default:
           child = const SizedBox.shrink(); // fallback
      }

      return Container(
        key: key,
        child: child,
      );
    }

}

extension BoardObjectsClone on BoardObjects {
  BoardObjects clone() => BoardObjects.fromJson(toJson());
}


