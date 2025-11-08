
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/editing/editable_buttons.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/tts/tts_interface.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';

class Root {
  final List<NavObjects> navRow;
  final List<GrammerObjects> grammerRow;
  final List <BoardObjects> boards;

  Root({
    required this.navRow,
    required this.grammerRow,
    required this.boards
  });

  factory Root.fromJson(Map<String, dynamic> json) {
    return Root(
      navRow: (json['navRow'] as List)
        .map((e) => NavObjects.fromJson(e))
        .toList(),
      grammerRow: (json['grammerRow'] as List)
        .map((e) => GrammerObjects.fromJson(e))
        .toList(),
      boards: (json['boards'] as List)
        .map((e) => BoardObjects.fromJson(e))
        .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return{
      'navRow': navRow.map((e) => e.toJson()).toList(),
      'grammerRow': grammerRow.map((e) => e.toJson()).toList(),
      'boards': boards.map((e) => e.toJson()).toList(),
    };
  }
}

class NavObjects {
  final int? rows;
  int? buttonsPerRow;

  final String id;
  String type;

  String? label;
  String? openLabel;
  String? closedLabel;
  String? linkToLabel;
  String? linkToUUID;

  bool? show;
  int? showOr;
  bool? matchFormat;
  int? format;

  bool? matchPOS;
  String? pos;
  Color? backgroundColor;
  Color? backgroundColorOpen;
  Color? backgroundColorClosed;
  bool? matchBorder;
  double? borderWeight;
  Color? borderColor;
  Color? borderColorOpen;
  Color? borderColorClosed;

  bool? matchFont;
  String? fontFamily;
  double? fontSize;
  int? fontWeight;
  bool? fontItalics;
  bool? fontUnderline;
  Color? fontColor;

  String? symbol;
  String? symbolOpen;
  String? symbolClosed;
  double? padding;

  bool? matchOverlayColor;
  Color? overlayColor;

  double? symbolSaturation;
  bool? matchSymbolSaturation;

  double? symbolContrast;
  bool? matchSymbolContrast;

  bool? invertSymbol;
  bool? matchInvertSymbol;
  
  bool? matchSpeakOS;
  int? speakOS;
  String? alternateLabel;
  String? note;

  List<NavObjects> content;

NavObjects({
  this.rows,
  this.buttonsPerRow,

  required this.id,
  required this.type,

  this.label,
  this.openLabel,
  this.closedLabel,
  this.linkToLabel,
  this.linkToUUID,

  this.show,
  this.showOr,
  this.matchFormat,
  this.format,

  this.matchPOS,
  this.pos,
  this.backgroundColor,
  this.backgroundColorOpen,
  this.backgroundColorClosed,
  this.matchBorder,
  this.borderWeight,
  this.borderColor,
  this.borderColorOpen,
  this.borderColorClosed,

  this.matchFont,
  this.fontFamily,
  this.fontSize,
  this.fontWeight,
  this.fontItalics,
  this.fontUnderline,
  this.fontColor,

  this.symbol,
  this.symbolOpen,
  this.symbolClosed,
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
  this.alternateLabel,
  this.note,

  required this.content,
});

factory NavObjects.fromJson(Map<String, dynamic> json) {
  try {
  return NavObjects(
    rows: (json['rows'] as num?)?.toInt(),
    buttonsPerRow: (json['buttonsPerRow'] as num?)?.toInt(),

    id: json['id'] as String,
    type: json['type'] as String,

    label: json['label'] as String?,
    openLabel: json['openLabel'] as String?,
    closedLabel: json['closedLabel'] as String?,
    linkToLabel: json['linkToLabel'] as String?,
    linkToUUID: json['linkToUUID'] as String?,

    show: json['show'] as bool?,
    showOr: (json['showOr'] as num?)?.toInt(),
    matchFormat: json['matchFormat'] as bool?,
    format: (json['format'] as num?)?.toInt(),

    matchPOS: json['matchPOS'] as bool?,
    pos: json['pos'] as String?,
    backgroundColor: json['backgroundColor'] != null ? Color(json['backgroundColor'] as int) : null, 
    backgroundColorOpen: json['backgroundColorOpen'] != null ? Color(json['backgroundColorOpen'] as int) : null,
    backgroundColorClosed: json ['backgroundColorClosed'] != null ? Color(json['backgroundColorClosed'] as int) : null,
    matchBorder: json['matchBorder'] as bool?,
    borderWeight: (json['borderWeight'] as num?)?.toDouble(),
    borderColor: json['borderColor'] != null ? Color(json['borderColor'] as int) : null,
    borderColorOpen: json['borderColorOpen'] != null ? Color(json['borderColorOpen'] as int) : null,
    borderColorClosed: json['borderColorClosed'] != null ? Color(json['borderColorClosed'] as int) : null,

    matchFont: json['matchFont'] as bool?,
    fontFamily: json['fontFamily'] as String?,
    fontSize: (json['fontSize'] as num?)?.toDouble(),
    fontWeight: (json['fontWeight'] as num?)?.toInt(),
    fontItalics: json['fontItalics'] as bool?,
    fontUnderline: json['fontUnderline'] as bool?,
    fontColor: json['fontColor'] != null ? Color(json['fontColor'] as int) : null,

    symbol: (json['symbol'] as String?)?.isNotEmpty == true 
    ? json['symbol'] 
    : 'assets/interface_icons/interface_icons/iPlaceholder.png',
    symbolOpen: (json['symbolOpen'] as String?)?.isNotEmpty == true 
    ? json['symbolOpen'] 
    : 'assets/interface_icons/interface_icons/iPlaceholder.png',
    symbolClosed: (json['symbolClosed'] as String?)?.isNotEmpty == true 
    ? json['symbolClosed'] 
    : 'assets/interface_icons/interface_icons/iPlaceholder.png',
    padding: (json['padding'] as num?)?.toDouble(),
    matchOverlayColor: json['matchOverlayColor'] as bool?,
    overlayColor: json['overlayColor'] != null ? Color(json['overlayColor'] as int) : null,
    matchSymbolSaturation: json['matchSymbolSaturation'] as bool?,
    symbolSaturation: (json['symbolSaturation'] as num?)?.toDouble(),
    matchSymbolContrast: json['matchSymbolContrast'] as bool?,
    symbolContrast: (json['symbolContrast'] as num?)?.toDouble(),
    matchInvertSymbol: json['matchInvertSymbol'] as bool?,
    invertSymbol: json['invertSymbol'] as bool?,

    matchSpeakOS: json['matchSpeakOS'] as bool?,
    speakOS: (json['speakOS'] as num?)?.toInt(),
    alternateLabel: json['alternateLabel'] as String?,
    note: json['note'] as String?,

    content: (json['content'] != null)
        ? (json['content'] as List)
            .map((e) => NavObjects.fromJson(e as Map<String, dynamic>))
            .toList()
        : [],
  );
  } catch (e) {
    print('error in NavObjects: $e');
    rethrow;
  }
}

  Map<String, dynamic> toJson() {
    return {
      'rows': rows,
      'buttonsPerRow': buttonsPerRow,

      'id': id,
      'type': type,

      'label': label,
      'openLabel': openLabel,
      'closedLabel': closedLabel,
      'linkToLabel': linkToLabel,
      'linkToUUID': linkToUUID,

      'show': show,
      'showOr': showOr,
      'matchFormat': matchFormat,
      'format': format,

      'matchPOS': matchPOS,
      'pos': pos,
      'backgroundColor': backgroundColor?.toARGB32(),
      'backgroundColorOpen': backgroundColorOpen?.toARGB32(),
      'backgroundColorClosed': backgroundColorClosed?.toARGB32(),
      'matchBorder': matchBorder,
      'borderWeight': borderWeight,
      'borderColor': borderColor?.toARGB32(),
      'borderColorOpen': borderColorOpen?.toARGB32(),
      'borderColorClosed': borderColorClosed?.toARGB32(),

      'matchFont': matchFont,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'fontWeight': fontWeight,
      'fontItalics': fontItalics,
      'fontUnderline': fontUnderline,
      'fontColor': fontColor?.toARGB32(),
      'symbol': symbol,
      'symbolOpen': symbolOpen,
      'symbolClosed': symbolClosed,
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
      'alternateLabel': alternateLabel,
      'note': note,

      'content': content.map((e) => e.toJson()).toList(),
    };
  }
}

extension NavRowDisplay on NavObjects {

  Widget _buildRow(
  TTSInterface synth, 
  VoidCallback toggleStorage, 
  void Function(BoardObjects) openBoard, 
  List<BoardObjects> boards, 
  BoardObjects? Function(String uuid, List<BoardObjects> boards) 
  findBoardById) {

    final perRow = buttonsPerRow ?? content.length;

    //ignore special and storage (history, pinned, storage)
    final buttons = content.where((c) => c.type == 'navButton').toList();
    final storageChest = content.where((c) => c.type == 'storage').toList(); 
    final specialButtons = content.where((c) => c.type == 'specialNavButton').toList(); 

    final chunked = <List<NavObjects>>[];
    for (var i = 0; i < buttons.length; i += perRow) {
      chunked.add(
        buttons.sublist(i, (i + perRow).clamp(0, buttons.length))
      );
    }
    
    final maxRows = rows ?? chunked.length;
    final visibleRows = chunked.take(maxRows).toList();

    return Row (
      children: [
        //first half nav buttons
        Expanded(
          flex: 9,
          child: Column(
            children: [
              for (var row in visibleRows)
              Expanded(child: 
              Padding(padding: EdgeInsetsGeometry.all(6), child:
              Row(
                children : [
                for (var item in row.sublist(0, (row.length / 2).ceil())) 
                  Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), 
                    child:  item.buildWidget(synth, toggleStorage, openBoard, boards, findBoardById,))),
                for (var i = 0; i < (perRow / 2 ).ceil() - (row.length / 2).ceil(); i++)
                 Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), child: SizedBox())),  // empty slot
              ])
              ),
              )
             ]
            ),
         ),
        (Bv4rs.showCenterButtons != 3) ?
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 1),
                // first half of special buttons
                for (var btn in specialButtons.sublist(0, specialButtons.length ~/ 2))
                  Expanded(
                    flex: 11,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: btn.buildWidget(synth, toggleStorage, openBoard, boards, findBoardById,),
                    ),
                  ),
                // storageChest
                Expanded(
                  flex: 13,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: Column(
                      children: [
                        for (var chest in storageChest)
                          Expanded(child: chest.buildWidget(synth, toggleStorage, openBoard, boards, findBoardById,)),
                      ],
                    ),
                  ),
                ),
                // second half of special buttons
                for (var btn in specialButtons.sublist(specialButtons.length ~/ 2))
                  Expanded(
                    flex: 11,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: btn.buildWidget(synth, toggleStorage, openBoard, boards, findBoardById,),
                    ),
                  ),
                  Spacer(flex: 1)
              ],
            ),
          ),
        )
        : SizedBox.shrink(),
        //second half nav buttons
        Expanded(
          flex: 9,
          child: Column(
            children: [
              for (var row in visibleRows)
              Expanded( child:
              Padding(padding: EdgeInsetsGeometry.all(7), child:
              Row(
                children : [
                for (var item in row.sublist((row.length / 2).ceil(), row.length)) 
                  Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), 
                    child: item.buildWidget(synth, toggleStorage, openBoard, boards, findBoardById,))),
                for (var i = 0; i < (perRow / 2).floor() - (row.length / 2).floor(); i++)
                  Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), child: SizedBox())),  // empty slot
              ]),
              ),
              )
             ]
            ),
        ), 
      ],
    );
  }
  Widget _buildEditableRow(
  TTSInterface synth, 
  VoidCallback toggleStorage, 
  void Function(BoardObjects) openBoard, 
  List<BoardObjects> boards, 
  BoardObjects? Function(String uuid, List<BoardObjects> boards) 
  findBoardById) {

    final perRow = buttonsPerRow ?? content.length;

    //ignore special and storage (history, pinned, storage)
    final buttons = content.where((c) => c.type == 'navButton').toList();
    final storageChest = content.where((c) => c.type == 'storage').toList(); 
    final specialButtons = content.where((c) => c.type == 'specialNavButton').toList(); 

    final chunked = <List<NavObjects>>[];
    for (var i = 0; i < buttons.length; i += perRow) {
      chunked.add(
        buttons.sublist(i, (i + perRow).clamp(0, buttons.length))
      );
    }
    
    final maxRows = rows ?? chunked.length;
    final visibleRows = chunked.take(maxRows).toList();

    return Row (
      children: [
        //first half nav buttons
        Expanded(
          flex: 9,
          child: Column(
            children: [
              for (var row in visibleRows)
              Expanded(child: 
              Padding(padding: EdgeInsetsGeometry.all(6), child:
              Row(
                children : [
                for (var item in row.sublist(0, (row.length / 2).ceil())) 
                  Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), 
                    child:  item.buildEditableWidget(synth, item, toggleStorage, openBoard, boards, findBoardById,))),
                for (var i = 0; i < (perRow / 2 ).ceil() - (row.length / 2).ceil(); i++)
                 Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), child: SizedBox())),  // empty slot
              ])
              ),
              )
             ]
            ),
         ),
        (Bv4rs.showCenterButtons != 3) ?
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.all(7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 1),
                // first half of special buttons
                for (var btn in specialButtons.sublist(0, specialButtons.length ~/ 2))
                  Expanded(
                    flex: 11,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: btn.buildEditableWidget(synth, btn, toggleStorage, openBoard, boards, findBoardById,),
                    ),
                  ),
                // storageChest
                Expanded(
                  flex: 13,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: Column(
                      children: [
                        for (var chest in storageChest)
                          Expanded(child: chest.buildEditableWidget(synth, chest, toggleStorage, openBoard, boards, findBoardById,)),
                      ],
                    ),
                  ),
                ),
                // second half of special buttons
                for (var btn in specialButtons.sublist(specialButtons.length ~/ 2))
                  Expanded(
                    flex: 11,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: btn.buildEditableWidget(synth, btn, toggleStorage, openBoard, boards, findBoardById,),
                    ),
                  ),
                  Spacer(flex: 1)
              ],
            ),
          ),
        )
        : SizedBox.shrink(),
        //second half nav buttons
        Expanded(
          flex: 9,
          child: Column(
            children: [
              for (var row in visibleRows)
              Expanded( child:
              Padding(padding: EdgeInsetsGeometry.all(7), child:
              Row(
                children : [
                for (var item in row.sublist((row.length / 2).ceil(), row.length)) 
                  Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), 
                    child: item.buildEditableWidget(synth, item, toggleStorage, openBoard, boards, findBoardById,))),
                for (var i = 0; i < (perRow / 2).floor() - (row.length / 2).floor(); i++)
                  Expanded(child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 3), child: SizedBox())),  // empty slot
              ]),
              ),
              )
             ]
            ),
        ), 
      ],
    );
  }


  Widget buildWidget(TTSInterface synth, VoidCallback toggleStorage, void Function(BoardObjects) openBoard, List<BoardObjects> boards, BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById) {
    switch(type) {
      case 'row': 
        return _buildRow(synth, toggleStorage, openBoard, boards, findBoardById,);
      case 'navButton':
        return _buildNavButton(synth, openBoard, boards, findBoardById,);
      case "specialNavButton":
        return _buildSpecialNavButton(synth);
      case "storage":
        return _buildStorageChest(synth, toggleStorage);
      default:
        return const SizedBox.shrink();
    }
  }


  Widget buildEditableWidget(TTSInterface synth, NavObjects obj, VoidCallback toggleStorage, void Function(BoardObjects) openBoard, List<BoardObjects> boards, BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById) {
    switch(type) {
      case 'row': 
        return _buildEditableRow(synth, toggleStorage, openBoard, boards, findBoardById,);
      case 'navButton':
        return _buildEditableNavButton(synth, obj, openBoard, boards, findBoardById,);
      case "specialNavButton":
        return _buildSpecialNavButton(synth);
      case "storage":
        return _buildStorageChest(synth, toggleStorage);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNavButton(TTSInterface synth, void Function(BoardObjects) openBoard, List<BoardObjects> boards, BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById) {
   return NavButtonStyle(
    tts: synth,
    openBoard: openBoard,
    boards: boards,
    findBoardById: findBoardById,
    linkToUUID: linkToUUID ?? '',
    linkToLabel: linkToLabel ?? '',
    label: label ?? '',
    show: show ?? true,
    matchFormat: matchFormat ?? true,
    format: format ?? 1,
    matchPOS: matchPOS ?? true,
    pos: pos ?? 'Extra 1',
    backgroundColor: backgroundColor ?? Colors.deepPurple,
    matchBorder: matchBorder ?? true,
    borderWeight: borderWeight ?? 3.5,
    borderColor: borderColor ?? Colors.amber,
    matchFont: matchFont ?? true,
    fontFamily: fontFamily ?? '',
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? 400,
    fontItalics: fontItalics ?? false,
    fontUnderline: fontUnderline ?? false,
    fontColor: fontColor ?? Colors.black,
    symbol: symbol ?? 'assets/interface_icons/interface_icons/iPlaceholder.png',
    padding: padding ?? 5,

    matchOverlayColor: matchOverlayColor ?? true,
    overlayColor: overlayColor ?? Colors.black,
    matchSymbolSaturation: matchSymbolSaturation ?? true,
    symbolSaturation: symbolSaturation ?? 0.5,
    matchSymbolContrast: matchSymbolContrast ?? true,
    symbolContrast: symbolContrast ?? 0.5,
    matchSymbolInvert: matchInvertSymbol ?? true,
    invertSymbolColors: invertSymbol ?? false,

    matchSpeakOS: matchSpeakOS ?? false,
    speakOS: speakOS ?? 1,
    alternateLabel: alternateLabel ?? '',
   );
  }
  
  Widget _buildSpecialNavButton(TTSInterface synth) {
    return (Bv4rs.showCenterButtons != 2) ? SpecialNavButtonStyle(
      onPressed: () {}, 
      tts: synth,
      label: label ?? '',
      showOr: showOr ?? 1,
      matchFormat: matchFormat ?? true,
      format: format ?? 1,
      matchPOS: matchPOS ?? true,
      pos: pos ?? 'Extra 1',
      backgroundColor: backgroundColor ?? Colors.deepPurple,
      matchBorder: matchBorder ?? true,
      borderWeight: borderWeight ?? 3.5,
      borderColor: borderColor ?? Colors.amber,
      matchFont: matchFont ?? true,
      fontFamily: fontFamily ?? '',
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? 400,
      fontItalics: fontItalics ?? false,
      fontUnderline: fontUnderline ?? false,
      fontColor: fontColor ?? Colors.black,
      symbol: symbol ?? 'assets/interface_icons/interface_icons/iPlaceholder.png',
      padding: padding ?? 5,
      matchOverlayColor: matchOverlayColor ?? true,
      overlayColor: overlayColor ?? Colors.black,
      symbolSaturation: symbolSaturation ?? 0.5,
      symbolContrast: symbolContrast ?? 0.5,
      invertSymbolColors: invertSymbol ?? false,
      matchSpeakOS: matchSpeakOS ?? false,
      speakOS: speakOS ?? 1,
      alternateLabel: alternateLabel ?? '',
      )
    : SizedBox.shrink();
  }
  
  Widget _buildStorageChest(TTSInterface synth, VoidCallback toggleStorage) {
    if (V4rs.isStoringOpen) {
    switch(matchFormat){
      case true: 
        return (Bv4rs.showCenterButtons != 2) ? StorageButtonStyle(
          onPressed: toggleStorage,
          tts: synth,
          label: openLabel ?? '', 
          showOr: showOr ?? 1,
          matchFormat: matchFormat ?? true,
          format: format ?? 1,
          matchPOS: matchPOS ?? true,
          pos: pos ?? 'Extra 1',
          backgroundColor: backgroundColorClosed ?? Colors.deepPurple,
          matchBorder: matchBorder ?? true,
          borderWeight: borderWeight ?? 3.5,
          borderColor: borderColorClosed ?? Colors.amber,
          matchFont: matchFont ?? true,
          fontFamily: fontFamily ?? '',
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? 400,
          fontItalics: fontItalics ?? false,
          fontUnderline: fontUnderline ?? false,
          fontColor: fontColor ?? Colors.black,
          symbol: symbolOpen ?? 'assets/interface_icons/interface_icons/iPlaceholder.png',
          padding: padding ?? 10,
          matchOverlayColor: matchOverlayColor ?? true,
          matchSymbolContrast: matchSymbolContrast ?? true,
          matchSymbolInvert: matchInvertSymbol ?? true,
          matchSymbolSaturation: matchSymbolSaturation ?? true,
          overlayColor: overlayColor ?? Colors.black,
          symbolSaturation: symbolSaturation ?? 0.5,
          symbolContrast: symbolContrast ?? 0.5,
          invertSymbolColors: invertSymbol ?? false,
          matchSpeakOS: matchSpeakOS ?? false,
          speakOS: speakOS ?? 1,
          alternateLabel: alternateLabel ?? '',
          )
        : SizedBox.shrink();
      case false:
        return (showOr != 3) ? StorageButtonStyle( onPressed: toggleStorage,
          tts: synth,
          label: openLabel ?? '',
          showOr: showOr ?? 1,
          matchFormat: matchFormat ?? true,
          format: format ?? 1,
          matchPOS: matchPOS ?? true,
          pos: pos ?? 'Extra 1',
          backgroundColor: backgroundColorClosed ?? Colors.deepPurple,
          matchBorder: matchBorder ?? true,
          borderWeight: borderWeight ?? 3.5,
          borderColor: borderColorClosed ?? Colors.amber,
          matchFont: matchFont ?? true,
          fontFamily: fontFamily ?? '',
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? 400,
          fontItalics: fontItalics ?? false,
          fontUnderline: fontUnderline ?? false,
          fontColor: fontColor ?? Colors.black,
          symbol: symbolOpen ?? 'assets/interface_icons/interface_icons/iPlaceholder.png',
          padding: padding ?? 10,
          matchOverlayColor: matchOverlayColor ?? true,
          overlayColor: overlayColor ?? Colors.black,
          symbolSaturation: symbolSaturation ?? 0.5,
          symbolContrast: symbolContrast ?? 0.5,
          invertSymbolColors: invertSymbol ?? false,
          matchSpeakOS: matchSpeakOS ?? false,
          speakOS: speakOS ?? 1,
          alternateLabel: alternateLabel ?? '',)
        : SizedBox.shrink();
      default: 
        return StorageButtonStyle( onPressed: toggleStorage,
          tts: synth,
          label: openLabel ?? '',
          showOr: showOr ?? 1,
          matchFormat: matchFormat ?? true,
          format: format ?? 1,
          matchPOS: matchPOS ?? true,
          pos: pos ?? 'Extra 1',
          backgroundColor: backgroundColorClosed ?? Colors.deepPurple,
          matchBorder: matchBorder ?? true,
          borderWeight: borderWeight ?? 3.5,
          borderColor: borderColorClosed ?? Colors.amber,
          matchFont: matchFont ?? true,
          fontFamily: fontFamily ?? '',
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? 400,
          fontItalics: fontItalics ?? false,
          fontUnderline: fontUnderline ?? false,
          fontColor: fontColor ?? Colors.black,
          symbol: symbolOpen ?? 'assets/interface_icons/interface_icons/iPlaceholder.png',
          padding: padding ?? 10,
          matchOverlayColor: matchOverlayColor ?? true,
          overlayColor: overlayColor ?? Colors.black,
          symbolSaturation: symbolSaturation ?? 0.5,
          symbolContrast: symbolContrast ?? 0.5,
          invertSymbolColors: invertSymbol ?? false,
          matchSpeakOS: matchSpeakOS ?? false,
          speakOS: speakOS ?? 1,
          alternateLabel: alternateLabel ?? '',);
    }
    } else { 
      switch(matchFormat){
      case true: 
        return (Bv4rs.showCenterButtons != 2) ? StorageButtonStyle(
          onPressed: toggleStorage,
          tts: synth,
          label: closedLabel?? '',
          showOr: showOr ?? 1,
          matchFormat: matchFormat ?? true,
          format: format ?? 1,
          matchPOS: matchPOS ?? true,
          pos: pos ?? 'Extra 1',
          backgroundColor: backgroundColorOpen ?? Colors.deepPurple,
          matchBorder: matchBorder ?? true,
          borderWeight: borderWeight ?? 3.5,
          borderColor: borderColorOpen ?? Colors.amber,
          matchFont: matchFont ?? true,
          fontFamily: fontFamily ?? '',
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? 400,
          fontItalics: fontItalics ?? false,
          fontUnderline: fontUnderline ?? false,
          fontColor: fontColor ?? Colors.black,
          symbol: symbolClosed ??  'assets/interface_icons/interface_icons/iPlaceholder.png',
          padding: padding ?? 10,
          matchOverlayColor: matchOverlayColor ?? true,
          overlayColor: overlayColor ?? Colors.black,
          symbolSaturation: symbolSaturation ?? 0.5,
          symbolContrast: symbolContrast ?? 0.5,
          invertSymbolColors: invertSymbol ?? false,
          matchSpeakOS: matchSpeakOS ?? false,
          speakOS: speakOS ?? 1,
          alternateLabel: alternateLabel ?? '',
          )
        : SizedBox.shrink();
      case false:
        return (showOr != 3) ? StorageButtonStyle( onPressed: toggleStorage,
          tts: synth,
          label: closedLabel ?? '',
          showOr: showOr ?? 1,
          matchFormat: matchFormat ?? true,
          format: format ?? 1,
          matchPOS: matchPOS ?? true,
          pos: pos ?? 'Extra 1',
          backgroundColor: backgroundColorClosed ?? Colors.deepPurple,
          matchBorder: matchBorder ?? true,
          borderWeight: borderWeight ?? 3.5,
          borderColor: borderColorClosed ?? Colors.amber,
          matchFont: matchFont ?? true,
          fontFamily: fontFamily ?? '',
          fontSize: fontSize ?? 14,
          fontWeight: fontWeight ?? 400,
          fontItalics: fontItalics ?? false,
          fontUnderline: fontUnderline ?? false,
          fontColor: fontColor ?? Colors.black,
          symbol: symbolClosed ??  'assets/interface_icons/interface_icons/iPlaceholder.png',
          padding: padding ?? 10,
          matchOverlayColor: matchOverlayColor ?? true,
          overlayColor: overlayColor ?? Colors.black,
          symbolSaturation: symbolSaturation ?? 0.5,
          symbolContrast: symbolContrast ?? 0.5,
          invertSymbolColors: invertSymbol ?? false,
          matchSpeakOS: matchSpeakOS ?? false,
          speakOS: speakOS ?? 1,
          alternateLabel: alternateLabel ?? '',) 
        : SizedBox.shrink();
      default: 
        return const SizedBox.shrink();
    }
    }
  }

  Widget _buildEditableNavButton(TTSInterface synth, NavObjects obj, void Function(BoardObjects) openBoard, List<BoardObjects> boards, BoardObjects? Function(String uuid, List<BoardObjects> boards) findBoardById) {
   return EditableNavButton(
    tts: synth,
    obj: obj,
    openBoard: openBoard,
    boards: boards,
    findBoardById: findBoardById,
    linkToUUID: linkToUUID ?? '',
    linkToLabel: linkToLabel ?? '',
    label: label ?? '',
    show: show ?? true,
    matchFormat: matchFormat ?? true,
    format: format ?? 1,
    matchPOS: matchPOS ?? true,
    pos: pos ?? 'Extra 1',
    backgroundColor: backgroundColor ?? Colors.deepPurple,
    matchBorder: matchBorder ?? true,
    borderWeight: borderWeight ?? 3.5,
    borderColor: borderColor ?? Colors.amber,
    matchFont: matchFont ?? true,
    fontFamily: fontFamily ?? '',
    fontSize: fontSize ?? 14,
    fontWeight: fontWeight ?? 400,
    fontItalics: fontItalics ?? false,
    fontUnderline: fontUnderline ?? false,
    fontColor: fontColor ?? Colors.black,
    symbol: symbol ?? 'assets/interface_icons/interface_icons/iPlaceholder.png',
    padding: padding ?? 5,

    matchOverlayColor: matchOverlayColor ?? true,
    overlayColor: overlayColor ?? Colors.black,
    matchSymbolSaturation: matchSymbolSaturation ?? true,
    symbolSaturation: symbolSaturation ?? 0.5,
    matchSymbolContrast: matchSymbolContrast ?? true,
    symbolContrast: symbolContrast ?? 0.5,
    matchSymbolInvert: matchInvertSymbol ?? true,
    invertSymbolColors: invertSymbol ?? false,
    matchSpeakOS: matchSpeakOS ?? false,
    speakOS: speakOS ?? 1,
    alternateLabel: alternateLabel ?? '',
   );
  }
  
}

//