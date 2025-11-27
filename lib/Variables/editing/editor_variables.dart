import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Variables/fonts.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

class Ev4rs {

  //
  //display controls
  //

    static ValueNotifier<bool> showEditor = ValueNotifier(false);

    static ValueNotifier<bool> isSaving = ValueNotifier(false);

    static ValueNotifier<bool> isButtonExpanded = ValueNotifier(false);

    static ValueNotifier<bool> showSelectionMenu = ValueNotifier(false); //show options for tap expander

    static ValueNotifier<bool> editAButton = ValueNotifier(false); //button editor

    static ValueNotifier<bool> editASubFolder = ValueNotifier(false); // sub folder editor

    static ValueNotifier<bool> editAGrammerButton = ValueNotifier(false); // grammer button editor

    static ValueNotifier<bool> editANavButton = ValueNotifier(false); // nav button editor

    static ValueNotifier<bool> isExporting = ValueNotifier(false); //export window

    static ValueNotifier<bool> isPrinting = ValueNotifier(false); //print window

    static ValueNotifier<bool> boardEditor = ValueNotifier(false); //board editing, edit board

    static ValueNotifier<bool> grammerRowEditor = ValueNotifier(false); //grammer editing, edit grammer

    static ValueNotifier<bool> overlayEditor = ValueNotifier(false); //overlay editing, edit overlay, language overlay editor

    static ValueNotifier<bool> showAddBoard = ValueNotifier<bool>(false); //create board

    //sync label and message 
    static ValueNotifier<bool> matchLabel = ValueNotifier<bool>(true);

  //
  //holding 
  //

    //===: boards +
    static ValueNotifier<BoardObjects?> selectedBoard = ValueNotifier(null); 
    static ValueNotifier<String> selectedBoardUUID = ValueNotifier('');

    static ValueNotifier<GrammerObjects?> selectedGrammerRow = ValueNotifier(null);
    static String selectedGrammerRowUUID = "";

    //=====: selections
    static ValueNotifier<BoardObjects?> selectedButton = ValueNotifier(null);

    static String selectedUUID = "";

    static ValueNotifier<List<String>> selectedUUIDs = ValueNotifier([]);

    static ValueNotifier<String> firstSelectedUUID = ValueNotifier('');
    static ValueNotifier<String> secondSelectedUUID = ValueNotifier('');

    static bool selectingAction1(BoardObjects obj) {
      Ev4rs.setPlacholderValues(obj);
      editAButton.value = true;
      if (tapAndSwap) {
        //clear other button type selections
        firstSubFolderSelectedUUID.value = '';
        secondSubFolderSelectedUUID.value = '';
        firstGrammerSelectedUUID.value = '';
        secondGrammerSelectedUUID.value = '';
        firstNavSelectedUUID.value = '';
        secondNavSelectedUUID.value = '';

        //remove if already selected
        if (firstSelectedUUID.value == obj.id) {
          firstSelectedUUID.value = '';
        } else if (secondSelectedUUID.value == obj.id){
          secondSelectedUUID.value = '';
        
        //select
        } else if (firstSelectedUUID.value.isEmpty) {
          firstSelectedUUID.value = obj.id;
        } else if (secondSelectedUUID.value.isEmpty){
          secondSelectedUUID.value = obj.id;
        } 
        return true;

      } else if (selectMultiple.value){
        //clear other button type selections
        subFolderSelectedUUIDs.value = [];
        grammerSelectedUUIDs.value = [];

        //remove is already selected
        if (selectedUUIDs.value.contains(obj.id)) {
          selectedUUIDs.value.remove(obj.id);

        //select
        } else {
          selectedUUIDs.value.add(obj.id);
        }
        return true;

      } else {
        return false;
      }

    }

    static void selectingAction2(BoardObjects obj, Root root) {
        editAGrammerButton.value = false;
        editASubFolder.value = false;
        editAButton.value = true;
        selectingAction1(obj);
        selectedButton.value = obj;
        selectedUUID = obj.id; 

        if (obj.type == 3 || obj.type == 2 && tapAndSwap == false){
          var linkedBoard = findBoardById(root.boards, obj.linkToUUID ?? '');
          var linkedGrammer = linkedBoard != null 
              ? findGrammerById(root.grammerRow, linkedBoard.useGrammerRow ?? '') 
              : null;

          if (Ev4rs.boardEditor.value){
            boardSelecting(linkedBoard, linkedGrammer, root.grammerRow);
          }
        }
    }


    //====: sub folder selections
    static ValueNotifier<BoardObjects?> subFolderSelectedButton = ValueNotifier(null);

    static String subFolderSelectedUUID = "";

    static ValueNotifier<List<String>> subFolderSelectedUUIDs = ValueNotifier([]);

    static ValueNotifier<String> firstSubFolderSelectedUUID = ValueNotifier('');
    static ValueNotifier<String> secondSubFolderSelectedUUID = ValueNotifier('');

    static bool subFolderSelectingAction1(BoardObjects obj) {
      setSubFolderPlacholderValues(obj);

      //tap and swap
      if (tapAndSwap) {

        //clear other button type selections
        firstSelectedUUID.value = '';
        secondSelectedUUID.value = '';
        firstGrammerSelectedUUID.value = '';
        secondGrammerSelectedUUID.value = '';
        firstNavSelectedUUID.value = '';
        secondNavSelectedUUID.value = '';

        //clear when already selected
        if (firstSubFolderSelectedUUID.value == obj.id) {
          firstSubFolderSelectedUUID.value = '';
        } else if (secondSubFolderSelectedUUID.value == obj.id){
          secondSubFolderSelectedUUID.value = '';

        //select
        } else if (firstSubFolderSelectedUUID.value.isEmpty) {
          firstSubFolderSelectedUUID.value = obj.id;
        } else if (secondSelectedUUID.value.isEmpty){
          secondSubFolderSelectedUUID.value = obj.id;
        } 
        return true;
      
      //selecting multiple
      } else if (selectMultiple.value){

        //clear other button type selections
        selectedUUIDs.value = [];
        grammerSelectedUUIDs.value = [];

        //remove already selected
        if (subFolderSelectedUUIDs.value.contains(obj.id)) {
          subFolderSelectedUUIDs.value.remove(obj.id);

        //select
        } else {
          subFolderSelectedUUIDs.value.add(obj.id);
        }
        return true;

      } else {
        return false;
      }

    }

    static void subFolderSelectingAction2(BoardObjects obj, Root root) {
        subFolderSelectingAction1(obj);

        editAButton.value = false;
        editAGrammerButton.value = false;
        editASubFolder.value = true;
        
        subFolderSelectedButton.value = obj;
        subFolderSelectedUUID = obj.id; 

      var linkedBoard = findBoardById(root.boards, obj.linkToUUID ?? '');
      var linkedGrammer = linkedBoard != null 
          ? findGrammerById(root.grammerRow, linkedBoard.useGrammerRow ?? '') 
          : null;

      if (boardEditor.value){
        boardSelecting(linkedBoard, linkedGrammer, root.grammerRow);
      }
    }

    //=====: grammer button selections
    static ValueNotifier<GrammerObjects?> grammerSelectedButton = ValueNotifier(null);

    static String grammerSelectedUUID = "";

    static ValueNotifier<List<String>> grammerSelectedUUIDs = ValueNotifier([]);

    static ValueNotifier<String> firstGrammerSelectedUUID = ValueNotifier('');
    static ValueNotifier<String> secondGrammerSelectedUUID = ValueNotifier('');

    static bool grammerSelectingAction1(GrammerObjects obj) {
      setPlacholderValuesGrammerRow(obj);

      //tap and swap
      if (tapAndSwap) {

        //clear other button type selections
        firstSelectedUUID.value = '';
        secondSelectedUUID.value = '';

        firstSubFolderSelectedUUID.value = '';
        secondSubFolderSelectedUUID.value = '';

        firstNavSelectedUUID.value = '';
        secondNavSelectedUUID.value = '';

        //clear when already selected
        if (firstGrammerSelectedUUID.value == obj.id) {
          firstGrammerSelectedUUID.value = '';
        } else if (secondGrammerSelectedUUID.value == obj.id){
          secondGrammerSelectedUUID.value = '';

        //select
        } else if (firstGrammerSelectedUUID.value.isEmpty) {
          firstGrammerSelectedUUID.value = obj.id;
        } else if (secondGrammerSelectedUUID.value.isEmpty){
          secondGrammerSelectedUUID.value = obj.id;
        } 
        return true;
      
      //selecting multiple
      } else if (selectMultiple.value){

        //clear other button type selections
        selectedUUIDs.value = [];
        subFolderSelectedUUIDs.value = [];

        //remove already selected
        if (grammerSelectedUUIDs.value.contains(obj.id)) {
          grammerSelectedUUIDs.value.remove(obj.id);

        //select
        } else {
          grammerSelectedUUIDs.value.add(obj.id);
        }
        return true;

      } else {
        return false;
      }

    }

    static void grammerSelectingAction2(GrammerObjects obj, Root root) {
        grammerSelectingAction1(obj);

        editAButton.value = false;
        editASubFolder.value = false;
        editAGrammerButton.value = true;
        
        grammerSelectedButton.value = obj;
        grammerSelectedUUID = obj.id; 

        var linkedBoard = findBoardById(root.boards, obj.openUUID ?? '');
        var linkedGrammer = linkedBoard != null 
            ? findGrammerById(root.grammerRow, linkedBoard.useGrammerRow ?? '') 
            : null;

        if (Ev4rs.boardEditor.value) {
          editAButton.value = false;
          editAGrammerButton.value = false;
          editASubFolder.value = false;
          editANavButton.value = false;
          if (Ev4rs.grammerRowEditor.value){
            Ev4rs.selectedGrammerRow.value = linkedGrammer;
            Ev4rs.selectedGrammerRowUUID = linkedGrammer?.id ?? '';
          } else {
          Ev4rs.selectedBoard.value = linkedBoard;
          Ev4rs.selectedBoardUUID.value = linkedBoard?.id ?? '';
        }

        }
    }

    //=====: nav button selections
    static ValueNotifier<NavObjects?> navSelectedButton = ValueNotifier(null);

    static String navSelectedUUID = "";

    static ValueNotifier<List<String>> navSelectedUUIDs = ValueNotifier([]);

    static ValueNotifier<String> firstNavSelectedUUID = ValueNotifier('');
    static ValueNotifier<String> secondNavSelectedUUID = ValueNotifier('');

    static bool navSelectingAction1(NavObjects obj) {
      setNavPlacholderValues(obj);

      //tap and swap
      if (tapAndSwap) {

        //clear other button type selections
        firstSelectedUUID.value = '';
        secondSelectedUUID.value = '';

        firstSubFolderSelectedUUID.value = '';
        secondSubFolderSelectedUUID.value = '';

        firstGrammerSelectedUUID.value = '';
        secondGrammerSelectedUUID.value = '';

        //clear when already selected
        if (firstNavSelectedUUID.value == obj.id) {
          firstNavSelectedUUID.value = '';
        } else if (navSelectedUUID == obj.id){
          secondNavSelectedUUID.value = '';

        //select
        } else if (firstNavSelectedUUID.value.isEmpty) {
          firstNavSelectedUUID.value = obj.id;
        } else if (secondNavSelectedUUID.value.isEmpty){
          secondNavSelectedUUID.value = obj.id;
        } 
        return true;
      
      //selecting multiple
      } else if (selectMultiple.value){

        //clear other button type selections
        selectedUUIDs.value = [];
        grammerSelectedUUIDs.value = [];

        //remove already selected
        if (navSelectedUUIDs.value.contains(obj.id)) {
          navSelectedUUIDs.value.remove(obj.id);

        //select
        } else {
          navSelectedUUIDs.value.add(obj.id);
        }
        return true;

      } else {
        return false;
      }

    }

    static void navSelectingAction2(NavObjects obj, Root root) {

      navSelectingAction1(obj);
      editAButton.value = false;
      editAGrammerButton.value = false;
      editASubFolder.value = false;
      editANavButton.value = true;
      
      navSelectedButton.value = obj;
      navSelectedUUID = obj.id; 
      
      var linkedBoard = findBoardById(root.boards, obj.linkToUUID ?? '');
      
      if (linkedBoard != null) {
        var linkedGrammer = findGrammerById(root.grammerRow, linkedBoard.useGrammerRow ?? '');

        if (Ev4rs.boardEditor.value){
          boardSelecting(linkedBoard, linkedGrammer, root.grammerRow);
        }
      }
    }

    static void boardSelecting(BoardObjects? boardObj, GrammerObjects? grammerObj, List<GrammerObjects> grammerRows){
      if (boardObj != null && grammerObj!= null) {
        setPlacholderValuesBoard(grammerRows, boardObj);
      }

      editAButton.value = false;
      editAGrammerButton.value = false;
      editASubFolder.value = false;
      editANavButton.value = false;

      if (Ev4rs.grammerRowEditor.value){
        Ev4rs.selectedGrammerRow.value = grammerObj;
        Ev4rs.selectedGrammerRowUUID = grammerObj?.id ?? '';
      } else if (Ev4rs.selectedBoard.value == boardObj){
        Ev4rs.selectedBoard.value = null;
        Ev4rs.selectedBoardUUID.value = '';
      } else {
        Ev4rs.selectedBoard.value = boardObj;
        Ev4rs.selectedBoardUUID.value = boardObj?.id ?? '';
      }
    }
    

    static void editBoardsAction(Root root){
      
      if (Ev4rs.boardEditor.value == true){
        //open what is under
        final navButton = findNavByLinked(root.navRow, Ev4rs.selectedBoardUUID.value);
        Ev4rs.navSelectedUUID = navButton?.id ?? '';
        Ev4rs.navSelectedButton.value = navButton;
        if (navButton == null){

          final buttonsButton = findBoardByLinked(root.boards, Ev4rs.selectedBoardUUID.value);
          Ev4rs.selectedUUID = buttonsButton?.id ?? '';
          Ev4rs.selectedButton.value = buttonsButton;
          if (buttonsButton == null){

            final grammerButton = findGrammerByLinked(root.grammerRow, Ev4rs.selectedBoardUUID.value);
            Ev4rs.grammerSelectedUUID = grammerButton?.id ?? '';
            Ev4rs.grammerSelectedButton.value = grammerButton;
            if (grammerButton != null){
              editAGrammerButton.value = true;
            }

          } else {
            editAButton.value = true;
          }
        } else {
          editANavButton.value = true;
        }
      } 

      //board selection starting fresh
      Ev4rs.selectedBoardUUID.value = '';
      Ev4rs.selectedBoard.value = null;

      //toggle
      Ev4rs.boardEditor.value = !Ev4rs.boardEditor.value;
    }

 

    //=====: placholder values for editing

      //====: column 1
      static ValueNotifier<double> padding = ValueNotifier(0);

      static ValueNotifier<Color> overlay = ValueNotifier(Colors.transparent);
      static ValueNotifier<bool> invert = ValueNotifier(false);
      static ValueNotifier<double> contrast = ValueNotifier(1.0);
      static ValueNotifier<double> saturation = ValueNotifier(1.0);

      static ValueNotifier<bool> matchOverlay = ValueNotifier(true);
      static ValueNotifier<bool> matchInvert = ValueNotifier(true);
      static ValueNotifier<bool> matchContrast = ValueNotifier(true);
      static ValueNotifier<bool> matchSaturation = ValueNotifier(true);

      //===: colummn 2
      static ValueNotifier<String> message = ValueNotifier('');
      static ValueNotifier<String> label = ValueNotifier('');
      static ValueNotifier<String> alternateLabel = ValueNotifier('');

      static ValueNotifier<bool> matchSpeakOnSelect = ValueNotifier(true);
      static ValueNotifier<int> speakOnSelect = ValueNotifier(1);

      static TextStyle get labelStyle =>  
      TextStyle(
        color: fontColor.value,
        fontSize: fontSize.value,
        fontFamily: Fontsy.fontToFamily[fontFamily.value], 
        fontWeight: FontWeight.values[((fontWeight.value ~/ 100) - 1 ).clamp(0, 8)],
        fontStyle: fontItalics.value ? FontStyle.italic : FontStyle.normal,
        height: 1.5
      );
      
      static TextStyle get hintLabelStyle =>  
      TextStyle(
        color: Cv4rs.themeColor3,
        fontSize: fontSize.value,
        fontFamily: Fontsy.fontToFamily[fontFamily.value], 
        fontWeight: FontWeight.values[((fontWeight.value ~/ 100) - 1 ).clamp(0, 8)],
        fontStyle: fontItalics.value ? FontStyle.italic : FontStyle.normal,
        height: 1.5
      );

      static ValueNotifier<bool> matchFont = ValueNotifier(true);
      static ValueNotifier<double> fontSize = ValueNotifier(16);
      static ValueNotifier<double> fontWeight = ValueNotifier(400);
      static ValueNotifier<bool> fontItalics = ValueNotifier(false);
      static ValueNotifier<Color> fontColor = ValueNotifier(Cv4rs.themeColor1);
      static ValueNotifier<bool> fontUnderline = ValueNotifier(false);
      static ValueNotifier<String> fontFamily = ValueNotifier('Default');

      //====: column 3
      static ValueNotifier<bool> show = ValueNotifier(true);
      static ValueNotifier<bool> matchFormat = ValueNotifier(true);
      static ValueNotifier<int> format = ValueNotifier(1);
      static ValueNotifier<bool> matchBorder = ValueNotifier(true);
      static ValueNotifier<double> borderWeight = ValueNotifier(1.5);
      static ValueNotifier<Color> borderColor = ValueNotifier(Cv4rs.themeColor1);
      static ValueNotifier<bool> matchBackground = ValueNotifier(true);
      static ValueNotifier<Color> backgroundColor = ValueNotifier(Cv4rs.themeColor1);

      //===: column 4
      static ValueNotifier<String> pos = ValueNotifier('noun');
      static ValueNotifier<int> buttonType = ValueNotifier(1);
      static ValueNotifier<String> subFolderType = ValueNotifier('subFolderButton');
      static ValueNotifier<String> grammerType = ValueNotifier('button');
      static ValueNotifier<String> link = ValueNotifier('');
      static ValueNotifier<String> linkLabel = ValueNotifier('');
      static ValueNotifier<bool> returnAfterSelect = ValueNotifier(false);
      static ValueNotifier<String> grammerFunction = ValueNotifier('placholder');
      static ValueNotifier<String> notes = ValueNotifier('');

      static var everyImage = <String>[];
      static var everyMp3 = <String>[];


    //=====: func to set above values 

      static void setPlacholderValues(BoardObjects obj_){
        // column 1
          padding.value = obj_.padding ?? 0;
          contrast.value = obj_.symbolContrast ?? 1.0;
          saturation.value = obj_.symbolSaturation ?? 1.0;
          invert.value = obj_.invertSymbol ?? false;
          overlay.value = obj_.overlayColor ?? Colors.transparent;
          matchContrast.value = obj_.matchSymbolContrast ?? true;
          matchInvert.value = obj_.matchInvertSymbol ?? true;
          matchSaturation.value = obj_.matchSymbolSaturation ?? true;
          matchOverlay.value = obj_.matchOverlayColor ?? true;
          
        // column 2
          label.value = obj_.label ?? '';
          message.value = obj_.message ?? '';
          //sets match/symc label and message
          if (label.value.trim() == message.value.trim()){
            matchLabel.value = true;
          } else{
            matchLabel.value = false;
          }
          matchSpeakOnSelect.value = obj_.matchSpeakOS ?? true;
          speakOnSelect.value = obj_.speakOS ?? 1;
          matchFont.value = obj_.matchFont ?? true;
          fontFamily.value = obj_.fontFamily ?? 'default';
          fontColor.value = obj_.fontColor ?? Cv4rs.themeColor1;
          fontSize.value = obj_.fontSize ?? 16;
          fontWeight.value = obj_.fontWeight ?? 400;
          fontItalics.value = obj_.fontItalics ?? false;
          fontUnderline.value = obj_.fontUnderline ?? false;

        // column 3
          show.value = obj_.show ?? true;
          matchFormat.value = obj_.matchFormat ?? true;
          format.value = obj_.format ?? 1;

          matchBorder.value = obj_.matchBorder ?? true;
          borderWeight.value = obj_.borderWeight ?? 1.5;
          borderColor.value = obj_.borderColor ?? Cv4rs.posToBorderColor(obj_.pos ?? 'Extra 2');

          matchBackground.value = obj_.matchPOS ?? true;
          backgroundColor.value = obj_.backgroundColor ?? Cv4rs.posToColor(obj_.pos ?? 'Extra 2');

        // column 4
          pos.value = obj_.pos ?? 'Extra 2';
          grammerFunction.value = obj_.function ?? 'placholder';
          buttonType.value = obj_.type ?? 1;
          link.value = obj_.linkToUUID ?? '';
          linkLabel.value = obj_.linkToLabel ?? '';
          notes.value = obj_.note ?? '';
      }

      static void setSubFolderPlacholderValues(BoardObjects obj_){
        // column 1
          padding.value = obj_.padding ?? 0;
          contrast.value = obj_.symbolContrast ?? 1.0;
          saturation.value = obj_.symbolSaturation ?? 1.0;
          invert.value = obj_.invertSymbol ?? false;
          overlay.value = obj_.overlayColor ?? Colors.transparent;
          matchContrast.value = obj_.matchSymbolContrast ?? true;
          matchInvert.value = obj_.matchInvertSymbol ?? true;
          matchSaturation.value = obj_.matchSymbolSaturation ?? true;
          matchOverlay.value = obj_.matchOverlayColor ?? true;
          
        // column 2
          label.value = obj_.label ?? '';
          alternateLabel.value = obj_.alternateLabel ?? '';
          matchSpeakOnSelect.value = obj_.matchSpeakOS ?? true;
          speakOnSelect.value = obj_.speakOS ?? 1;
          matchFont.value = obj_.matchFont ?? true;
          fontFamily.value = obj_.fontFamily ?? 'default';
          fontColor.value = obj_.fontColor ?? Cv4rs.themeColor1;
          fontSize.value = obj_.fontSize ?? 16;
          fontWeight.value = obj_.fontWeight ?? 400;
          fontItalics.value = obj_.fontItalics ?? false;
          fontUnderline.value = obj_.fontUnderline ?? false;

        // column 3
          show.value = obj_.show ?? true;
          matchFormat.value = obj_.matchFormat ?? true;
          format.value = obj_.format ?? 1;

          matchBorder.value = obj_.matchBorder ?? true;
          borderWeight.value = obj_.borderWeight ?? 1.5;
          borderColor.value = obj_.borderColor ?? Cv4rs.posToBorderColor(obj_.pos ?? 'Extra 2');

          matchBackground.value = obj_.matchPOS ?? true;
          backgroundColor.value = obj_.backgroundColor ?? Cv4rs.posToColor(obj_.pos ?? 'Extra 2');

        // column 4
          pos.value = obj_.pos ?? 'Extra 2';
          subFolderType.value = obj_.type1 ?? 'subFolderButton';
          link.value = obj_.linkToUUID ?? '';
          linkLabel.value = obj_.linkToLabel ?? '';
          notes.value = obj_.note ?? '';
      }

      static void setGrammerPlacholderValues(GrammerObjects obj_){
        // column 1
          padding.value = obj_.padding ?? 0;
          contrast.value = obj_.symbolContrast ?? 1.0;
          saturation.value = obj_.symbolSaturation ?? 1.0;
          invert.value = obj_.invertSymbol ?? false;
          overlay.value = obj_.overlayColor ?? Colors.transparent;
          matchContrast.value = obj_.matchSymbolContrast ?? true;
          matchInvert.value = obj_.matchInvertSymbol ?? true;
          matchSaturation.value = obj_.matchSymbolSaturation ?? true;
          matchOverlay.value = obj_.matchOverlayColor ?? true;
          
        // column 2
          label.value = obj_.label ?? '';
          matchSpeakOnSelect.value = obj_.matchSpeakOS ?? true;
          speakOnSelect.value = obj_.speakOS ?? 1;
          matchFont.value = obj_.matchFont ?? true;
          fontFamily.value = obj_.fontFamily ?? 'default';
          fontColor.value = obj_.fontColor ?? Cv4rs.themeColor1;
          fontSize.value = obj_.fontSize ?? 16;
          fontWeight.value = obj_.fontWeight ?? 400;
          fontItalics.value = obj_.fontItalics ?? false;
          fontUnderline.value = obj_.fontUnderline ?? false;

        // column 3
          matchFormat.value = obj_.matchFormat ?? true;
          format.value = obj_.format ?? 1;

          backgroundColor.value = obj_.backgroundColor ?? Cv4rs.themeColor4;

        // column 4
          grammerFunction.value = obj_.function ?? 'placholder';
          grammerType.value = obj_.type ?? "button";
          link.value = obj_.openUUID ?? '';
          notes.value = obj_.note ?? '';
      }

      static void setNavPlacholderValues(NavObjects obj_){
        // column 1
          padding.value = obj_.padding ?? 5;
          contrast.value = obj_.symbolContrast ?? 1.0;
          saturation.value = obj_.symbolSaturation ?? 1.0;
          invert.value = obj_.invertSymbol ?? false;
          overlay.value = obj_.overlayColor ?? Colors.transparent;
          matchContrast.value = obj_.matchSymbolContrast ?? true;
          matchInvert.value = obj_.matchInvertSymbol ?? true;
          matchSaturation.value = obj_.matchSymbolSaturation ?? true;
          matchOverlay.value = obj_.matchOverlayColor ?? true;
          
        // column 2
          label.value = obj_.label ?? '';
          alternateLabel.value = obj_.alternateLabel ?? '';
          matchSpeakOnSelect.value = obj_.matchSpeakOS ?? true;
          speakOnSelect.value = obj_.speakOS ?? 1;
          matchFont.value = obj_.matchFont ?? true;
          fontFamily.value = obj_.fontFamily ?? 'default';
          fontColor.value = obj_.fontColor ?? Cv4rs.themeColor1;
          fontSize.value = obj_.fontSize ?? 16;
          fontWeight.value = (obj_.fontWeight ?? 400).toDouble();
          fontItalics.value = obj_.fontItalics ?? false;
          fontUnderline.value = obj_.fontUnderline ?? false;

        // column 3
          show.value = obj_.show ?? true;
          matchFormat.value = obj_.matchFormat ?? true;
          format.value = obj_.format ?? 1;

          matchBorder.value = obj_.matchBorder ?? true;
          borderWeight.value = obj_.borderWeight ?? 1.5;
          borderColor.value = obj_.borderColor ?? Cv4rs.posToBorderColor(obj_.pos ?? 'Extra 2');

          matchBackground.value = obj_.matchPOS ?? true;
          backgroundColor.value = obj_.backgroundColor ?? Cv4rs.posToColor(obj_.pos ?? 'Extra 2');

        // column 4
          pos.value = obj_.pos ?? 'Extra 2';
          link.value = obj_.linkToUUID ?? '';
          linkLabel.value = obj_.linkToLabel ?? '';
          notes.value = obj_.note ?? '';
      }

  
    //===: board editor + 
      static ValueNotifier<String> title = ValueNotifier("");
      static ValueNotifier<String> usedGrammerRowUUID = ValueNotifier("");
       static ValueNotifier<String> useGrammerRowTitle = ValueNotifier("");
      static ValueNotifier<int> useSubFolders = ValueNotifier(1);
      static String languageOfOverlay = "";

      static void setPlacholderValuesBoard(List<GrammerObjects> grammar, BoardObjects obj_){
        title.value = obj_.title ?? '';
        usedGrammerRowUUID.value = obj_.useGrammerRow ?? '';
        useGrammerRowTitle.value = findGrammerTitleById(grammar, usedGrammerRowUUID.value) ?? '';
        useSubFolders.value = obj_.useSubFolders ?? 1;
      }

      static void setPlacholderValuesGrammerRow(GrammerObjects obj_){
        title.value = obj_.title ?? '';
      }



  //
  //back
  //
  static void closeEditorAction(){
    Ev4rs.showEditor.value = false;
    Ev4rs.isButtonExpanded.value = false;

    Ev4rs.tapAndSwap = false;
    Ev4rs.selectMultiple.value = false;
    Ev4rs.dragSelectMultiple.value = false;

    Ev4rs.navSelectedUUID = '';
    Ev4rs.grammerSelectedUUID = '';
    Ev4rs.subFolderSelectedUUID = '';
    Ev4rs.selectedUUID = '';

    Ev4rs.navSelectedButton.value = null;
    Ev4rs.grammerSelectedButton.value = null;
    Ev4rs.subFolderSelectedButton.value = null;
    Ev4rs.selectedButton.value = null;
    
    Ev4rs.navSelectedUUIDs.value = [];
    Ev4rs.grammerSelectedUUIDs.value = [];
    Ev4rs.subFolderSelectedUUIDs.value = [];
    Ev4rs.selectedUUIDs.value = [];

    Ev4rs.boardEditor.value = false;
    Ev4rs.selectedBoardUUID.value = '';
  }

  //
  //undo and Redo
  //

    static final List<Map<String, dynamic>> jsonHistory = [];
    static int jsonHistoryIndex = -1;

    static ValueNotifier<bool> isUndoing = ValueNotifier(false);
    static ValueNotifier<bool> isRedoing = ValueNotifier(false);


    static void updateJsonHistory(Root root){
      //when undoing (idnex is less than the history - 1)
      if (jsonHistoryIndex < jsonHistory.length -1) {
        jsonHistory.removeRange(jsonHistoryIndex + 1, jsonHistory.length);
      }

      jsonHistory.add(root.toJson());

      //index should be 1 less than history
      jsonHistoryIndex = jsonHistory.length - 1;
    } 

    static Root? undoJsonEdit() {
      //if there is something to undo
      if (jsonHistoryIndex > 0) {
        jsonHistoryIndex--;
        return Root.fromJson(jsonHistory[jsonHistoryIndex]);
      }
      //else do nothing
      return null; 
    }

    //final undo func
    static void undoAction(Root root){
      isUndoing.value = true;
      final restored = undoJsonEdit();

      if (restored != null) {
          root = restored;
          undoSave(restored);
      } 
      Future.delayed(const Duration(milliseconds: 300), () {
        isUndoing.value = false;
      });
    }

    static Root? redoJsonEdit() {
      //if there is something to redo
      if (jsonHistoryIndex < jsonHistory.length - 1) {
        jsonHistoryIndex++;
        return Root.fromJson(jsonHistory[jsonHistoryIndex]);
      }
      //else do nothing
      return null;
    }

    static void redoAction(Root root){
      isRedoing.value = true;
      final restored = redoJsonEdit();
      
      if (restored != null) {
          root = restored;
          undoSave(restored);
      }
      Future.delayed(const Duration(milliseconds: 300), () {
        isRedoing.value = false;
      });
    }

  //
  //tap expander
  //

    //=====: tap and swap

      static bool tapAndSwap = false;

      //find object and path to object
      static Map<String, dynamic>? findParentListAndIndex(
            List<BoardObjects> list, String uuid) {
          for (int i = 0; i < list.length; i++) {
            if (list[i].id == uuid) {
              return {'parentList': list, 'index': i};
            }

            final childResult = findParentListAndIndex(list[i].content, uuid);
            if (childResult != null) return childResult;
          }
          return null;
        }

      static Map<String, dynamic>? grammerFindParentListAndIndex(
        List<GrammerObjects> list, String uuid) {
          for (int i = 0; i < list.length; i++) {
            if (list[i].id == uuid) {
              return {'parentList': list, 'index': i};
            }

            final childResult = grammerFindParentListAndIndex(list[i].content, uuid);
            if (childResult != null) return childResult;
          }
          return null;
      }

      static Map<String, dynamic>? navFindParentListAndIndex(
        List<NavObjects> list, String uuid) {
          for (int i = 0; i < list.length; i++) {
            if (list[i].id == uuid) {
              return {'parentList': list, 'index': i};
            }

            final childResult = navFindParentListAndIndex(list[i].content, uuid);
            if (childResult != null) return childResult;
          }
          return null;
      }

      
      // Swap objects
      static bool swapObj(List<BoardObjects> boards, String uuid1, String uuid2) {
        final info1 = findParentListAndIndex(boards, uuid1);
        final info2 = findParentListAndIndex(boards, uuid2);

        if (info1 == null || info2 == null) {
          return false;
        }

        final parent1 = info1['parentList'] as List<BoardObjects>;
        final index1 = info1['index'] as int;

        final parent2 = info2['parentList'] as List<BoardObjects>;
        final index2 = info2['index'] as int;

        final temp = parent1[index1];
        parent1[index1] = parent2[index2];
        parent2[index2] = temp;

        return true;
      }

      static bool swapGrammerObj(List<GrammerObjects> rows, String uuid1, String uuid2) {
        final info1 = grammerFindParentListAndIndex(rows, uuid1);
        final info2 = grammerFindParentListAndIndex(rows, uuid2);

        if (info1 == null || info2 == null) {
          return false;
        }

        final parent1 = info1['parentList'] as List<GrammerObjects>;
        final index1 = info1['index'] as int;

        final parent2 = info2['parentList'] as List<GrammerObjects>;
        final index2 = info2['index'] as int;

        final temp = parent1[index1];
        parent1[index1] = parent2[index2];
        parent2[index2] = temp;

        return true;
      }

      static bool swapNavObj(List<NavObjects> nav, String uuid1, String uuid2) {
        final info1 = navFindParentListAndIndex(nav, uuid1);
        final info2 = navFindParentListAndIndex(nav, uuid2);

        if (info1 == null || info2 == null) {
          return false;
        }

        final parent1 = info1['parentList'] as List<NavObjects>;
        final index1 = info1['index'] as int;

        final parent2 = info2['parentList'] as List<NavObjects>;
        final index2 = info2['index'] as int;

        final temp = parent1[index1];
        parent1[index1] = parent2[index2];
        parent2[index2] = temp;

        return true;
      }

      //final tap and swap func
      static void tapAndSwapAction(Root root) async {

        //when no other tap actions are true
        if (dragSelectMultiple.value == false && selectMultiple.value == false) {

          //if have 2 button elements to swap
          if (firstSelectedUUID.value.isNotEmpty && secondSelectedUUID.value.isNotEmpty){
            //swap, save, reset
            swapObj(root.boards, firstSelectedUUID.value, secondSelectedUUID.value);
            await saveJson(root);
            firstSelectedUUID.value = '';
            secondSelectedUUID.value = '';
          
          //if have sub folder elements to swap
          } else if (firstSubFolderSelectedUUID.value.isNotEmpty && secondSubFolderSelectedUUID.value.isNotEmpty) {
            swapObj(root.boards, firstSubFolderSelectedUUID.value, secondSubFolderSelectedUUID.value);
            await saveJson(root);
            firstSubFolderSelectedUUID.value = '';
            secondSubFolderSelectedUUID.value = '';

          //grammer swapping
          } else if (firstGrammerSelectedUUID.value.isNotEmpty && secondGrammerSelectedUUID.value.isNotEmpty){
            swapGrammerObj(root.grammerRow, firstGrammerSelectedUUID.value, secondGrammerSelectedUUID.value);
            await saveJson(root);
            firstGrammerSelectedUUID.value = '';
            secondGrammerSelectedUUID.value = '';
          
          //nav swapping
          } else if (firstNavSelectedUUID.value.isNotEmpty && secondNavSelectedUUID.value.isNotEmpty){
            swapNavObj(root.navRow, firstNavSelectedUUID.value, secondNavSelectedUUID.value);
            await saveJson(root);
            firstNavSelectedUUID.value = '';
            secondNavSelectedUUID.value = '';

          //when not swapping
          } else { 

            //but something selected
            if (firstSelectedUUID.value.isNotEmpty || secondSelectedUUID.value.isNotEmpty
              || firstSubFolderSelectedUUID.value.isNotEmpty || secondSubFolderSelectedUUID.value.isNotEmpty
              || firstGrammerSelectedUUID.value.isNotEmpty || secondGrammerSelectedUUID.value.isNotEmpty
              || firstNavSelectedUUID.value.isNotEmpty || secondNavSelectedUUID.value.isNotEmpty) {
              //block action

            //otherwise
            } else {
              //toggle
              tapAndSwap = !tapAndSwap;
            }
          }

        //when drag select multiple is true 
        } else if (dragSelectMultiple.value == true){
          //off, reset, loop
          dragSelectMultiple.value = false;
          selectedUUIDs.value == [];
          buttonKeys.clear();
          tapAndSwapAction(root);

        //when select multiple is true
        } else if (selectMultiple.value == true) {
          //off, reset, loop
          selectMultiple.value = false;
          selectedUUIDs.value = [];
          tapAndSwapAction(root);
        }
        
      }

    
    //=====: drag select multiple

      static  ValueNotifier<bool> dragSelectMultiple = ValueNotifier(false);
      static final Map<String, GlobalKey> buttonKeys = {};

      //final drag select multiple func
      static void dragSelectMultipleAction(Root root) async {

        //when no other tap actions are true
        if (selectMultiple.value == false && tapAndSwap == false) {
          //toggle + reset values
          dragSelectMultiple.value = !dragSelectMultiple.value;
          selectedUUIDs.value = [];
          buttonKeys.clear();

        //when select multiple is true
        } else if (selectMultiple.value == true) {
          //off, reset, loop
          selectMultiple.value = false;
          selectedUUIDs.value = [];
          dragSelectMultipleAction(root);

        //when tap and swap is true
        } else if (tapAndSwap == true) {
          //block action
        }
      }


    //=====: tap select multiple

      static ValueNotifier<bool> selectMultiple = ValueNotifier(false);

      //final tap select func
      static void selectMultipleAction(Root root) async {

        //when no other tap actions are true
        if (tapAndSwap == false && dragSelectMultiple.value == false) {
          //turn on/off and reset selections
          selectMultiple.value = !selectMultiple.value;
          selectedUUIDs.value = [];
          grammerSelectedUUIDs.value = [];
          navSelectedUUIDs.value = [];
          subFolderSelectedUUIDs.value = [];

        //when drag select multiple is true
        } else if (dragSelectMultiple.value == true){ 
          //turn off, reset, loop
          dragSelectMultiple.value = false;
          selectedUUIDs.value = [];
          buttonKeys.clear();
          selectMultipleAction(root);

        //when tap swap is true
        } else if (tapAndSwap == true) {
          //block
        }
      }

    
    //=====: invert selection

      static ValueNotifier<bool> invertSelections = ValueNotifier(false);

      static void invertSelected(Root root){
        final currentBoard = root.boards[V4rs.syncIndex];
        final currentUuids = currentBoard.content
          .where((obj) => obj.type1 == null) //add if button
          .map((obj) => obj.id)
          .toSet();
        final currentSelection = selectedUUIDs.value;
        final theInvertSelection = currentUuids.difference(currentSelection.toSet());
        selectedUUIDs.value = theInvertSelection.toList();
        selectedUUID = selectedUUIDs.value.first;
      }

      static void invertSelectedSubFolders(Root root){
        final currentBoard = root.boards[V4rs.syncIndex];
        final currentUuids = currentBoard.content
          .where((obj) => obj.type1 != null) //add if sub folder/ back button
          .map((obj) => obj.id)
          .toSet();
        final currentSelection = subFolderSelectedUUIDs.value;
        final theInvertSelection = currentUuids.difference(currentSelection.toSet());
        subFolderSelectedUUIDs.value = theInvertSelection.toList();
        subFolderSelectedUUID = subFolderSelectedUUIDs.value.first;
      }

      static void invertSelectedGrammer(Root root){
        final currentRow = root.grammerRow[V4rs.syncIndex];
        final currentUuids = currentRow.content
          .map((obj) => obj.id)
          .toSet();
        final currentSelection = grammerSelectedUUIDs.value;
        final theInvertSelection = currentUuids.difference(currentSelection.toSet());
        grammerSelectedUUIDs.value = theInvertSelection.toList();
        grammerSelectedUUID = grammerSelectedUUIDs.value.first;
      }


      static void invertSelectedNav(Root root){
        final currentRow = root.navRow;
        final currentUuids = currentRow
          .expand((navObj) => navObj.content.map((obj) => obj.id))
          .toSet();
        final currentSelection = navSelectedUUIDs.value;
        final theInvertSelection = currentUuids.difference(currentSelection.toSet());
        navSelectedUUIDs.value = theInvertSelection.toList();
        navSelectedUUID = navSelectedUUIDs.value.first;
      }

      //final invert func
      static void invertSelectionAction(Root root) async {

        //when tap and swap is false & seledted uuids isn't empty
        if ((tapAndSwap && sortSelectAZ.value) == false 
        
        //for buttons and sub folders
          && (selectedUUIDs.value.isNotEmpty || subFolderSelectedUUIDs.value.isNotEmpty)) {

          //on, invert, off
          invertSelections.value = true;
          Future.delayed(const Duration(milliseconds: 200), () {
           
            //butons
            if (selectedUUIDs.value.isNotEmpty) {
              invertSelected(root);
              invertSelections.value = false;

            //sub folders
            } else if (subFolderSelectedUUIDs.value.isNotEmpty) {
              invertSelections.value = false;
              invertSelectedSubFolders(root);
            }
          });
        
        //for grammer buttons
        } else if (grammerSelectedUUIDs.value.isNotEmpty){
          //on, invert, off
          invertSelections.value = true;
          Future.delayed(const Duration(milliseconds: 200), () {
            if (grammerSelectedUUIDs.value.isNotEmpty) {
              invertSelectedGrammer(root);
              invertSelections.value = false;
            }
          });

        //for nav buttons
        } else if (navSelectedUUIDs.value.isNotEmpty){
          //on, invert, off
          invertSelections.value = true;
          Future.delayed(const Duration(milliseconds: 200), () {
              invertSelectedNav(root);
              invertSelections.value = false;
            }
          );

        //otherwise
        } else {
          //do nothing
          invertSelections.value = true;
          Future.delayed(const Duration(milliseconds: 300), () {
          invertSelections.value = false;
          });
        }
      }
  
    
    //=====: sort A-Z

      static ValueNotifier<bool> sortSelectAZ = ValueNotifier(false);

      static void sortSelectedAz(Root root) {
        final currentBoard = root.boards[V4rs.syncIndex];
        final selected = selectedUUIDs.value.toSet();

        // Split into selected vs non-selected
        final selectedObjs = <BoardObjects>[];
        final nonSelectedObjs = <BoardObjects>[];

        //assign objcects to selected vs non selected
        for (final obj in currentBoard.content) {
          if (selected.contains(obj.id)) {
            selectedObjs.add(obj);
          } else {
            nonSelectedObjs.add(obj);
          }
        }

        // Sort objects alphebetically
        selectedObjs.sort((a, b) => (a.label ?? '').toLowerCase().compareTo((b.label ?? '').toLowerCase()));

        // Merge sorted selected and non selected 
        int selIndex = 0;
        for (int i = 0; i < currentBoard.content.length; i++) {
          if (selected.contains(currentBoard.content[i].id)) {
            currentBoard.content[i] = selectedObjs[selIndex++];
          }
        }
      }

      static void sortSubFolderSelectedAz(Root root) {
        final currentBoard = root.boards[V4rs.syncIndex];
        final selected = subFolderSelectedUUIDs.value.toSet();

        // Split into selected vs non-selected
        final selectedObjs = <BoardObjects>[];
        final nonSelectedObjs = <BoardObjects>[];

        //assign objcects to selected vs non selected
        for (final obj in currentBoard.content) {
          if (selected.contains(obj.id)) {
            selectedObjs.add(obj);
          } else {
            nonSelectedObjs.add(obj);
          }
        }

        // Sort objects alphebetically
        selectedObjs.sort((a, b) => (a.label ?? '').toLowerCase().compareTo((b.label ?? '').toLowerCase()));

        // Merge sorted selected and non selected 
        int selIndex = 0;
        for (int i = 0; i < currentBoard.content.length; i++) {
          if (selected.contains(currentBoard.content[i].id)) {
            currentBoard.content[i] = selectedObjs[selIndex++];
          }
        }
      }

      static void sortGrammerSelectedAz(Root root) {
        final currentBoard = root.grammerRow[V4rs.syncIndex];
        final selected = grammerSelectedUUIDs.value.toSet();

        // Split into selected vs non-selected
        final selectedObjs = <GrammerObjects>[];
        final nonSelectedObjs = <GrammerObjects>[];

        //assign objcects to selected vs non selected
        for (final obj in currentBoard.content) {
          if (selected.contains(obj.id)) {
            selectedObjs.add(obj);
          } else {
            nonSelectedObjs.add(obj);
          }
        }

        // Sort objects alphebetically
        selectedObjs.sort((a, b) => (a.label ?? '').toLowerCase().compareTo((b.label ?? '').toLowerCase()));

        // Merge sorted selected and non selected 
        int selIndex = 0;
        for (int i = 0; i < currentBoard.content.length; i++) {
          if (selected.contains(currentBoard.content[i].id)) {
            currentBoard.content[i] = selectedObjs[selIndex++];
          }
        }
      }

      static void sortNavSelectedAz(Root root) {
        final selected = navSelectedUUIDs.value.toSet();

        for (final navContainer in root.navRow) {
          // Defensive check in case of null content
          if (navContainer.content.isEmpty) continue;

          // Split content into selected and non-selected
          final selectedObjs = <NavObjects>[];
          final nonSelectedObjs = <NavObjects>[];

          for (final obj in navContainer.content) {
            if (selected.contains(obj.id)) {
              selectedObjs.add(obj);
            } else {
              nonSelectedObjs.add(obj);
            }
          }

          // Sort only selected ones alphabetically
          selectedObjs.sort((a, b) =>
              (a.label ?? '').toLowerCase().compareTo((b.label ?? '').toLowerCase()));

          // Merge back into the original order:
          // keep positions of non-selected, replace selecteds in place
          int selIndex = 0;
          for (int i = 0; i < navContainer.content.length; i++) {
            if (selected.contains(navContainer.content[i].id) && selIndex < selectedObjs.length) {
              navContainer.content[i] = selectedObjs[selIndex++];
            }
          }
        }
      }

      //final sort a-z func
      static void sortSelectedAzAction(Root root) async {

        //when tap and swap is false & seledted uuids isn't empty
        if ((tapAndSwap && invertSelections.value) == false 
          && (selectedUUIDs.value.isNotEmpty || subFolderSelectedUUIDs.value.isNotEmpty 
          || grammerSelectedUUIDs.value.isNotEmpty || navSelectedUUIDs.value.isNotEmpty)) {

          //on, invert, off
          sortSelectAZ.value = true;
          Future.delayed(const Duration(milliseconds: 200), () async {
            
            //buttons
            if (selectedUUIDs.value.isNotEmpty) {
            sortSelectedAz(root);
            
            //sub folders
            } else if (subFolderSelectedUUIDs.value.isNotEmpty) {
              sortSubFolderSelectedAz(root);

            //grammer
            } else if (grammerSelectedUUIDs.value.isNotEmpty){
              sortGrammerSelectedAz(root);
            
            //nav
            } else if (navSelectedUUIDs.value.isNotEmpty){
              sortNavSelectedAz(root);
            }

            await saveJson(root);
            reloadJson.value = !reloadJson.value;
            sortSelectAZ.value = false;
          });

        //otherwise
        } else {
          //do nothing
          sortSelectAZ.value = true;
          Future.delayed(const Duration(milliseconds: 300), () {
            sortSelectAZ.value = false;
          });
        }
      }
      

  //
  //Pickers
  //

    //====: image picker

      static Future<void> pickImage(final void Function(Root root, String objUUID, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
        final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

        if (chosenImage != null) {
          final savedPath = await saveImageToAppDir(chosenImage);
    
          everyImage = getAllImages(root) + [savedPath];
          saveField(root, selectedUUID, "symbol", savedPath);        
          await saveJson(root);
          }
      }

      static Future<void> multiPickImage(final void Function(Root root, List<String> objUUIDs, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
      final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

      if (chosenImage != null) {
        final savedPath = await saveImageToAppDir(chosenImage);

        everyImage = getAllImages(root) + [savedPath];
        saveField(root, selectedUUIDs.value, "symbol", savedPath);        
        await saveJson(root);
        }
      }

      static Future<void> pickSubFolderImage(final void Function(Root root, String objUUID, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
        final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

        if (chosenImage != null) {
          final savedPath = await saveImageToAppDir(chosenImage);
    
          everyImage = getAllImages(root) + [savedPath];
          saveField(root, subFolderSelectedUUID, "symbol", savedPath);        
          await saveJson(root);
          }
      }

      static Future<void> multiSubFolderPickImage(final void Function(Root root, List<String> objUUIDs, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
      final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

      if (chosenImage != null) {
        final savedPath = await saveImageToAppDir(chosenImage);

        everyImage = getAllImages(root) + [savedPath];
        saveField(root, subFolderSelectedUUIDs.value, "symbol", savedPath);        
        await saveJson(root);
        }
      }

      static Future<void> grammerPickImage(final void Function(Root root, String objUUID, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
      final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

      if (chosenImage != null) {
        final savedPath = await saveImageToAppDir(chosenImage);

        everyImage = getAllImages(root) + [savedPath];
        saveField(root, grammerSelectedUUID, "symbol", savedPath);        
        await saveJson(root);
        }
      }

      static Future<void> navPickImage(final void Function(Root root, String objUUID, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
      final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

      if (chosenImage != null) {
        final savedPath = await saveImageToAppDir(chosenImage);

        everyImage = getAllImages(root) + [savedPath];
        saveField(root, navSelectedUUID, "symbol", savedPath);        
        await saveJson(root);
        }
      }

      static Future<void> multiGrammerPickImage(final void Function(Root root, List<String> objUUIDs, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
      final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

      if (chosenImage != null) {
        final savedPath = await saveImageToAppDir(chosenImage);

        everyImage = getAllImages(root) + [savedPath];
        saveField(root, grammerSelectedUUIDs.value, "symbol", savedPath);      
        await saveJson(root);
        }
      }

      static Future<void> multiNavPickImage(final void Function(Root root, List<String> objUUIDs, String field, dynamic value) saveField, Root root, ImagePicker picker) async {
      final XFile? chosenImage = await picker.pickImage(source: ImageSource.gallery);

      if (chosenImage != null) {
        final savedPath = await saveImageToAppDir(chosenImage);

        everyImage = getAllImages(root) + [savedPath];
        saveField(root, navSelectedUUIDs.value, "symbol", savedPath);        
        await saveJson(root);
        }
      }

      static Future<String> saveImageToAppDir(XFile image) async {
        //grabbing documents directory 
        final dir = await getApplicationDocumentsDirectory();

        //making a new path
        final imagesDir = Directory(p.join(dir.path, 'my_images'));

        //making sure the sub folder exists
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        // making sure file name is unqiue
        final imageName = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(image.path)}';
        
        // new path
        final newPath = p.join(
          imagesDir.path,
          imageName,
        );

        await image.saveTo(newPath);

        //checking for saved
        final exists = File(newPath);
        if (!await exists.exists()) {
          throw Exception('Failed to copy image to $newPath');
        } else {
        }

        //returning the path 
        return p.join('my_images', imageName);
      }
      
      //get a list of the images for cleanup
      static List<String> getAllImages(Root root) {

          List<String> images = [];


          void collectSymbols(BoardObjects obj) {
            if (obj.symbol != null) images.add(obj.symbol!);

            for (var child in obj.content) {
              collectSymbols(child); // recurse
            }
          }
          void collectGrammerSymbols(GrammerObjects obj) {
            if (obj.symbol != null) images.add(obj.symbol!);

            for (var child in obj.content) {
              collectGrammerSymbols(child); // recurse
            }
          }
          void collectNavSymbols(NavObjects obj) {
            if (obj.symbol != null) images.add(obj.symbol!);

            for (var child in obj.content) {
              collectNavSymbols(child); // recurse
            }
          }


          for (var board in root.boards) {
            collectSymbols(board);
          }
          for (var row in root.grammerRow) {
            collectGrammerSymbols(row);
          }
          for (var nav in root.navRow) {
            collectNavSymbols(nav);
          }


          return images;
        }

      //cleanup
      static Future<void> cleanupUnusedImages(List<String> keepPaths) async {
        //keep paths defines what is being used 

        final dir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory(p.join(dir.path, 'my_images'));

        if (!await imagesDir.exists()) return;

        // only look inside my_images
        final normalizedKeepPaths = <String>{};
        for (final path in keepPaths) {
          if (path.startsWith('my_images/')) {
            // make absolute
            normalizedKeepPaths.add(p.join(dir.path, path));
          } else if (path.startsWith('/')) {
            //already absolute
            normalizedKeepPaths.add(path);
          } else {
            //not in my_images so ignore
          }
        }

        // go through my_images and delete unused
        for (final entity in imagesDir.listSync()) {
          if (entity is File) {
            if (!normalizedKeepPaths.contains(entity.path)) {
              try {
                await entity.delete();
              } catch (e) {
                SnackBar(content: Text('Error cleaning unused image: ${entity.path}'));
              }
            }
          }
        }
      }
      

    //=====: mp3 picker

      static Future<void> pickMP3(Root root) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null && result.files.single.path != null) {
        final chosenMP3 = File(result.files.single.path!);

        final savedPath = await saveMP3ToAppDir(chosenMP3);

        everyMp3 = everyMp3 + [savedPath];
        updateBoardField(root, selectedUUID, "audioClip", savedPath); 
              
        await saveJson(root);
      }
    }

      static Future<void> multiPickMP3(Root root) async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null && result.files.single.path != null) {
        final chosenMP3 = File(result.files.single.path!);

        final savedPath = await saveMP3ToAppDir(chosenMP3);

        everyMp3 = everyMp3 + [savedPath];
        updateMultiBoardField(root, selectedUUIDs.value, "audioClip", savedPath); 
              
        await saveJson(root);
      }
    }

      static Future<String> saveMP3ToAppDir(File mp3File) async {
        //grabbing documents directory 
        final dir = await getApplicationDocumentsDirectory();

        //making a new path
        final audioDir = Directory(p.join(dir.path, 'my_sounds'));

        //making sure the sub folder exists
        if (!await audioDir.exists()) {
          await audioDir.create(recursive: true);
        }

        // making sure file name is unqiue
        final mp3 = '${DateTime.now().millisecondsSinceEpoch}_${p.basename(mp3File.path)}';
        
        // new path
        final newPath = p.join(
          audioDir.path,
          mp3,
        );

        await mp3File.copy(newPath);

        //checking for saved
        final exists = File(newPath);
        if (!await exists.exists()) {
          throw Exception('Failed to copy file to $newPath');
        } else {
        }

        //returning the path 
        return p.join('my_sounds', mp3);
      }
      
      //list of audio files for cleanup
      static List<String> getAllMp3(Root root) {

          List<String> sound = [];

          void collectSymbols(BoardObjects obj) {
            if (obj.audioClip != null) sound.add(obj.audioClip!);

            for (var child in obj.content) {
              collectSymbols(child); // recurse
            }
          }

          for (var board in root.boards) {
            collectSymbols(board);
          }

          return sound;
        }
      
      //cleanup
      static Future<void> cleanupUnusedmp3(List<String> keepPaths) async {
        //grabbing documents directory & images sub folder to look through
        final dir = await getApplicationDocumentsDirectory();
        final audioDir = Directory(p.join(dir.path, 'my_audio'));

        //saftey check
        if (!await audioDir.exists()) return;

        final normalizedKeepPaths = <String>{};
        for (final path in keepPaths) {
          if (path.startsWith('my_audio/')) {
            // make absolute
            normalizedKeepPaths.add(p.join(dir.path, path));
          } else if (path.startsWith('/')) {
            //already absolute
            normalizedKeepPaths.add(path);
          } else {
            //not in my_audio so ignore
          }
        }
        //listing files and deleting unused ones
        final files = audioDir.listSync();
        for (final entity in files) {
          if (entity is File) {
            if (!normalizedKeepPaths.contains(entity.path)) {
              try {
                await entity.delete();
              } catch (e) {
                SnackBar(content: Text('Error cleaning unused file: ${entity.path}'));
              }
            }
          }
        }
      }
  

  

  //
  //json interfacing
  //

    static bool rootReady = false;
    static ValueNotifier<bool> reloadJson = ValueNotifier(false);

    //find object via uuid
    static BoardObjects? findBoardById(List<BoardObjects> boards, String uuid) {
      for (final board in boards) {
        if (board.id == uuid) {
          return board;
        }
        final found = findBoardById(board.content, uuid);
        if (found != null) return found;
      }
      return null;
    }
    //find obj via linked 
     static BoardObjects? findBoardByLinked(List<BoardObjects> boards, String uuid) {
      for (final board in boards) {
        if (board.linkToUUID == uuid) {
          return board;
        }
        final found = findBoardByLinked(board.content, uuid);
        if (found != null) return found;
      }
      return null;
    }

    //find grammer via uuid
    static GrammerObjects? findGrammerById(List<GrammerObjects> grammer, String uuid) {
      for (final grammer in grammer) {
        if (grammer.id == uuid) {
          return grammer;
        }
        final found = findGrammerById(grammer.content, uuid);
        if (found != null) return found;
      }
      return null;
    }

     static GrammerObjects? findGrammerByLinked(List<GrammerObjects> grammer, String uuid) {
      for (final grammer in grammer) {
        if (grammer.openUUID == uuid) {
          return grammer;
        }
        final found = findGrammerByLinked(grammer.content, uuid);
        if (found != null) return found;
      }
      return null;
    }

    static String? findGrammerTitleById(List<GrammerObjects> grammer, String uuid) {
      for (final grammer in grammer) {
        if (grammer.id == uuid) {
          return grammer.label;
        }
        final found = findGrammerById(grammer.content, uuid);
        if (found != null) return grammer.label;
      }
      return null;
    }

    //find nav via uuid
    static NavObjects? findNavById(List<NavObjects> nav, String uuid) {
      for (final nav in nav) {
        if (nav.id == uuid) {
          return nav;
        }
        final found = findNavById(nav.content, uuid);
        if (found != null) return found;
      }
      return null;
    }
    //find nav via linked to uuid
    static NavObjects? findNavByLinked(List<NavObjects> nav, String linkedUuid) {
      for (final n in nav) {
        if (n.linkToUUID == linkedUuid) {
          return n;
        }
        final found = findNavByLinked(n.content, linkedUuid);
        if (found != null) return found;
      }
      return null;
    }

    //compare multi select values for match or no match
    static bool compareObjFields(List<BoardObjects> boards, Function(BoardObjects) field) {
      
      final uuids = selectedUUIDs.value.isNotEmpty
        ? selectedUUIDs.value
        : subFolderSelectedUUIDs.value;
      
      //turn UUIDS to objects
      final selectedBoards = uuids
          .map((uuid) => findBoardById(boards, uuid))
          .whereType<BoardObjects>() // filters out nulls
          .toList();

      //saftey
      if (selectedBoards.isEmpty) {
        SnackBar(content: Text('error'),);
        return false;
      }

      //get field
      final selectedField = field(selectedBoards.first);

      //take selected objs and for every obj, check if its field value = selected field
      //if it does means all objects are the same- returns true, else returns false
      return selectedBoards.every((b) => field(b) == selectedField);
    }

    //compare multi grammer select values for match or no match
    static bool compareGrammerObjFields(List<GrammerObjects> objects, Function(GrammerObjects) field) {
      
      final uuids = grammerSelectedUUIDs.value;
      
      //turn UUIDS to objects
      final selectedRows = uuids
          .map((uuid) => findGrammerById(objects, uuid))
          .whereType<GrammerObjects>() // filters out nulls
          .toList();

      //saftey
      if (selectedRows.isEmpty) {
        SnackBar(content: Text('error'),);
        return false;
      }

      //get field
      final selectedField = field(selectedRows.first);

      //take selected objs and for every obj, check if its field value = selected field
      //if it does means all objects are the same- returns true, else returns false
      return selectedRows.every((b) => field(b) == selectedField);
    }

    //compare multi nav select values for match or no match
    static bool compareNavObjFields(List<NavObjects> objects, Function(NavObjects) field) {
      
      final uuids = navSelectedUUIDs.value;
      
      //turn UUIDS to objects
      final selectedRows = uuids
          .map((uuid) => findNavById(objects, uuid))
          .whereType<NavObjects>() // filters out nulls
          .toList();

      //saftey
      if (selectedRows.isEmpty) {
        SnackBar(content: Text('error'),);
        return false;
      }

      //get field
      final selectedField = field(selectedRows.first);

      //take selected objs and for every obj, check if its field value = selected field
      //if it does means all objects are the same- returns true, else returns false
      return selectedRows.every((b) => field(b) == selectedField);
    }

    //get a list of boards
    static List<BoardObjects> getBoards(List<BoardObjects> objects){
      final List<BoardObjects> allBoards = [];

      void traverse(BoardObjects obj){
        if (obj.type1 == 'board' ){
          allBoards.add(obj);
        }
        for (var child in obj.content){
          traverse(child);
        }
      }
      for(var obj in objects){
        traverse(obj);
      }
      return allBoards;
    }

    //get a list of grammer rows
    static List<GrammerObjects> getGrammerRows(List<GrammerObjects> objects){
      final List<GrammerObjects> allGrammerRows = [];

      void traverse(GrammerObjects obj){
        if (obj.type == 'row' ){
          allGrammerRows.add(obj);
        }
        for (var child in obj.content){
          traverse(child);
        }
      }
      for(var obj in objects){
        traverse(obj);
      }
      return allGrammerRows;
    }

    //update json append json edit json
      //single
        static bool updateBoardField(Root root, String uuid, String fieldName, dynamic newValue) {
          final board = findBoardById(root.boards, uuid);
          if (board == null) return false;

          switch (fieldName) {

            //
            //column 1 - (symbol, padding, symbol color edits)
            //

            case 'symbol':
              board.symbol = newValue as String?;
              break;
            case 'padding':
              board.padding = newValue as double?;
              break;
            case 'matchOverlayColor':
              board.matchOverlayColor = newValue as bool?;
              break;
            case 'overlayColor':
              if (newValue is int) {
                board.overlayColor = Color(newValue);
              } else if (newValue is Color) {
                board.overlayColor = newValue;
              } else {
                board.overlayColor = null;
              }
              break;
            case 'matchSymbolSaturation':
              board.matchSymbolSaturation = newValue as bool?;
              break;
            case 'symbolSaturation':
              board.symbolSaturation = newValue as double?;
              break;
            case 'matchSymbolContrast':
              board.matchSymbolContrast = newValue as bool?;
              break;
            case 'symbolContrast': 
              board.symbolContrast = newValue as double?;
              break;
            case 'matchInvertSymbol':
              board.matchInvertSymbol = newValue as bool?;
              break;
            case 'invertSymbol':
              board.invertSymbol = newValue as bool?;
              break;

            //
            //column 2 - (label, message, speakOS)
            //

            case 'label':
              board.label = newValue as String?;
              break;
            case 'alternateLabel':
              board.alternateLabel = newValue as String?;
              break;
            case 'message':
              board.message = newValue as String?;
              break;
            case 'matchSpeakOS':
              board.matchSpeakOS = newValue as bool?;
              break;
            case 'speakOS':
              board.speakOS = newValue as int?;
              break;
            case 'matchFont':
              board.matchFont = newValue as bool?;
              break;
            case 'fontSize':
              board.fontSize = newValue as double?;
              break;
            case 'fontItalics':
              board.fontItalics = newValue as bool?;
              break;
            case 'fontUnderline':
              board.fontUnderline = newValue as bool?;
              break;
            case 'fontWeight':
              board.fontWeight = newValue as double?;
              break;
            case 'fontFamily':
              board.fontFamily = newValue as String?;
              break;
            case 'fontColor':
              if (newValue is int) {
                board.fontColor = Color(newValue);
              } else if (newValue is Color) {
                board.fontColor = newValue;
              } else {
                board.fontColor = null;
              }
              break;
            
            //
            //column 3 - (show, format,  border, background)
            //
            case 'show':
              board.show = newValue as bool?;
              break;
            case 'matchFormat':
              board.matchFormat = newValue as bool?;
              break;
            case 'format':
              board.format = newValue as int?;
              break;
            case 'matchBorder':
              board.matchBorder = newValue as bool?;
              break;
            case 'borderColor':
              if (newValue is int) {
                board.borderColor = Color(newValue);
              } else if (newValue is Color) {
                board.borderColor = newValue;
              } else {
                board.borderColor = null;
              }
              break;
            case 'borderWeight':
              board.borderWeight = newValue as double?;
              break;
            case 'matchPOS':
              board.matchPOS = newValue as bool?;
              break;
            case 'backgroundColor':
              if (newValue is int) {
                board.backgroundColor = Color(newValue);
              } else if (newValue is Color) {
                board.backgroundColor = newValue;
              } else {
                board.backgroundColor = null;
              }
              break;

            //
            //column 4 - (pos, type -> link, func, mp3, note)
            //
            case 'pos':
              board.pos = newValue as String?;
              break;
            case 'type':
              board.type = newValue as int?;
              break;
            case 'type1':
              board.type1 = newValue as String?;
              break;
            case 'linkToUUID':
              board.linkToUUID = newValue as String?;
              break;
            case 'linkToLabel':
              board.linkToLabel = newValue as String?;
              break;
            case 'returnAfterSelect':
              board.returnAfterSelect = newValue as bool?;
              break;
            case 'function':
              board.function = newValue as String?;
              break;
            case 'audioClip':
              board.audioClip = newValue as String?;
              break;
            case 'note':
              board.note = newValue as String?;
              break;
            
            //
            //board
            //
            case 'title':
              board.title = newValue as String?;
              break;
            case 'useGrammerRow': 
              board.useGrammerRow = newValue as String?;
              break;
            case 'useSubFolders':
              board.useSubFolders = newValue as int?;
              break;

            
            //
            //interfacing
            //
            default:
              return false; // field not found
          }
          return true;
        }

        static bool updateGrammerField(Root root, String uuid, String fieldName, dynamic newValue) {
          final row = findGrammerById(root.grammerRow, uuid);
          if (row == null) return false;

          switch (fieldName) {

            //
            //column 1 - (symbol, padding, symbol color edits)
            //

            case 'symbol':
              row.symbol = newValue as String?;
              break;
            case 'padding':
              row.padding = newValue as double?;
              break;
            case 'matchOverlayColor':
              row.matchOverlayColor = newValue as bool?;
              break;
            case 'overlayColor':
              if (newValue is int) {
                row.overlayColor = Color(newValue);
              } else if (newValue is Color) {
                row.overlayColor = newValue;
              } else {
                row.overlayColor = null;
              }
              break;
            case 'matchSymbolSaturation':
              row.matchSymbolSaturation = newValue as bool?;
              break;
            case 'symbolSaturation':
              row.symbolSaturation = newValue as double?;
              break;
            case 'matchSymbolContrast':
              row.matchSymbolContrast = newValue as bool?;
              break;
            case 'symbolContrast': 
              row.symbolContrast = newValue as double?;
              break;
            case 'matchInvertSymbol':
              row.matchInvertSymbol = newValue as bool?;
              break;
            case 'invertSymbol':
              row.invertSymbol = newValue as bool?;
              break;

            //
            //column 2 - (label, message, speakOS)
            //

            case 'label':
              row.label = newValue as String?;
              break;
            case 'matchSpeakOS':
              row.matchSpeakOS = newValue as bool?;
              break;
            case 'speakOS':
              row.speakOS = newValue as int?;
              break;
            case 'matchFont':
              row.matchFont = newValue as bool?;
              break;
            case 'fontSize':
              row.fontSize = newValue as double?;
              break;
            case 'fontItalics':
              row.fontItalics = newValue as bool?;
              break;
            case 'fontUnderline':
              row.fontUnderline = newValue as bool?;
              break;
            case 'fontWeight':
              row.fontWeight = newValue as double?;
              break;
            case 'fontFamily':
              row.fontFamily = newValue as String?;
              break;
            case 'fontColor':
              if (newValue is int) {
                row.fontColor = Color(newValue);
              } else if (newValue is Color) {
                row.fontColor = newValue;
              } else {
                row.fontColor = null;
              }
              break;
            
            //
            //column 3 - (show, format,  border, background)
            //
            case 'matchFormat':
              row.matchFormat = newValue as bool?;
              break;
            case 'format':
              row.format = newValue as int?;
              break;
            case 'backgroundColor':
              if (newValue is int) {
                row.backgroundColor = Color(newValue);
              } else if (newValue is Color) {
                row.backgroundColor = newValue;
              } else {
                row.backgroundColor = null;
              }
              break;

            //
            //column 4 - (pos, type -> link, func, mp3, note)
            //
            case 'type':
              row.type = newValue as String?;
              break;
            case 'function':
              row.function = newValue as String?;
              break;
            case 'note':
              row.note = newValue as String?;
              break;

            
            //
            //interfacing
            //
            default:
              return false; // field not found
          }
          return true;
        }

        static bool updateNavField(Root root, String uuid, String fieldName, dynamic newValue) {
          final row = findNavById(root.navRow, uuid);
          if (row == null) return false;

          switch (fieldName) {

            //
            //column 1 - (symbol, padding, symbol color edits)
            //

            case 'symbol':
              row.symbol = newValue as String?;
              break;
            case 'padding':
              row.padding = newValue as double?;
              break;
            case 'matchOverlayColor':
              row.matchOverlayColor = newValue as bool?;
              break;
            case 'overlayColor':
              if (newValue is int) {
                row.overlayColor = Color(newValue);
              } else if (newValue is Color) {
                row.overlayColor = newValue;
              } else {
                row.overlayColor = null;
              }
              break;
            case 'matchSymbolSaturation':
              row.matchSymbolSaturation = newValue as bool?;
              break;
            case 'symbolSaturation':
              row.symbolSaturation = newValue as double?;
              break;
            case 'matchSymbolContrast':
              row.matchSymbolContrast = newValue as bool?;
              break;
            case 'symbolContrast': 
              row.symbolContrast = newValue as double?;
              break;
            case 'matchInvertSymbol':
              row.matchInvertSymbol = newValue as bool?;
              break;
            case 'invertSymbol':
              row.invertSymbol = newValue as bool?;
              break;

            //
            //column 2 - (label, message, speakOS)
            //

            case 'label':
              row.label = newValue as String?;
              break;
            case 'alternateLabel':
              row.alternateLabel = newValue as String?;
              break;
            case 'matchSpeakOS':
              row.matchSpeakOS = newValue as bool?;
              break;
            case 'speakOS':
              row.speakOS = newValue as int?;
              break;
            case 'matchFont':
              row.matchFont = newValue as bool?;
              break;
            case 'fontSize':
              row.fontSize = newValue as double?;
              break;
            case 'fontItalics':
              row.fontItalics = newValue as bool?;
              break;
            case 'fontUnderline':
              row.fontUnderline = newValue as bool?;
              break;
            case 'fontWeight':
              row.fontWeight = newValue as int?;
              break;
            case 'fontFamily':
              row.fontFamily = newValue as String?;
              break;
            case 'fontColor':
              if (newValue is int) {
                row.fontColor = Color(newValue);
              } else if (newValue is Color) {
                row.fontColor = newValue;
              } else {
                row.fontColor = null;
              }
              break;
            
            //
            //column 3 - (show, format,  border, background)
            //
            case 'show': 
              row.show = newValue as bool?;
              break;
            case 'matchFormat':
              row.matchFormat = newValue as bool?;
              break;
            case 'format':
              row.format = newValue as int?;
              break;
            case 'matchBorder':
              row.matchBorder = newValue as bool?;
              break;
            case 'borderColor':
              if (newValue is int) {
                row.borderColor = Color(newValue);
              } else if (newValue is Color) {
                row.borderColor = newValue;
              } else {
                row.borderColor = null;
              }
              break;
            case 'borderWeight':
              row.borderWeight = newValue as double?;
              break;
             case 'matchPOS':
                row.matchPOS = newValue as bool?;
                break;
            case 'backgroundColor':
              if (newValue is int) {
                row.backgroundColor = Color(newValue);
              } else if (newValue is Color) {
                row.backgroundColor = newValue;
              } else {
                row.backgroundColor = null;
              }
              break;

            //
            //column 4 - (pos, type -> link, func, mp3, note)
            //
            case 'type':
              row.type = newValue as String;
              break;
            case 'pos':
              row.pos = newValue as String?;
              break;
            case 'linkToLabel':
              row.linkToLabel = newValue as String?;
              break;
            case 'linkToUUID':
              row.linkToUUID = newValue as String?;
              break;
            case 'note':
              row.note = newValue as String?;
              break;

            
            //
            //interfacing
            //
            default:
              return false; // field not found
          }
          return true;
        }

      //multi
        static bool updateMultiBoardField(Root root, List<String> uuids, String fieldName, dynamic newValue) {
          for (final obj in uuids){
            final board = findBoardById(root.boards, obj);
            if (board == null) return false;

            switch (fieldName) {

              //
              //column 1 - (symbol, padding, symbol color edits)
              //

              case 'symbol':
                board.symbol = newValue as String?;
                break;
              case 'padding':
                board.padding = newValue as double?;
                break;
              case 'matchOverlayColor':
                board.matchOverlayColor = newValue as bool?;
                break;
              case 'overlayColor':
                if (newValue is int) {
                  board.overlayColor = Color(newValue);
                } else if (newValue is Color) {
                  board.overlayColor = newValue;
                } else {
                  board.overlayColor = null;
                }
                break;
              case 'matchSymbolSaturation':
                board.matchSymbolSaturation = newValue as bool?;
                break;
              case 'symbolSaturation':
                board.symbolSaturation = newValue as double?;
                break;
              case 'matchSymbolContrast':
                board.matchSymbolContrast = newValue as bool?;
                break;
              case 'symbolContrast': 
                board.symbolContrast = newValue as double?;
                break;
              case 'matchInvertSymbol':
                board.matchInvertSymbol = newValue as bool?;
                break;
              case 'invertSymbol':
                board.invertSymbol = newValue as bool?;
                break;

              //
              //column 2 - (label, message, speakOS)
              //

              case 'label':
                board.label = newValue as String?;
                break;
              case 'message':
                board.message = newValue as String?;
                break;
              case 'matchSpeakOS':
                board.matchSpeakOS = newValue as bool?;
                break;
              case 'speakOS':
                board.speakOS = newValue as int?;
                break;
              case 'matchFont':
                board.matchFont = newValue as bool?;
                break;
              case 'fontSize':
                board.fontSize = newValue as double?;
                break;
              case 'fontItalics':
                board.fontItalics = newValue as bool?;
                break;
              case 'fontUnderline':
                board.fontUnderline = newValue as bool?;
                break;
              case 'fontWeight':
                board.fontWeight = newValue as double?;
                break;
              case 'fontFamily':
                board.fontFamily = newValue as String?;
                break;
              case 'fontColor':
                if (newValue is int) {
                  board.fontColor = Color(newValue);
                } else if (newValue is Color) {
                  board.fontColor = newValue;
                } else {
                  board.fontColor = null;
                }
                break;
              
              //
              //column 3 - (show, format,  border, background)
              //
              case 'show':
                board.show = newValue as bool?;
                break;
              case 'matchFormat':
                board.matchFormat = newValue as bool?;
                break;
              case 'format':
                board.format = newValue as int?;
                break;
              case 'matchBorder':
                board.matchBorder = newValue as bool?;
                break;
              case 'borderColor':
                if (newValue is int) {
                  board.borderColor = Color(newValue);
                } else if (newValue is Color) {
                  board.borderColor = newValue;
                } else {
                  board.borderColor = null;
                }
                break;
              case 'borderWeight':
                board.borderWeight = newValue as double?;
                break;
              case 'matchPOS':
                board.matchPOS = newValue as bool?;
                break;
              case 'backgroundColor':
                if (newValue is int) {
                  board.backgroundColor = Color(newValue);
                } else if (newValue is Color) {
                  board.backgroundColor = newValue;
                } else {
                  board.backgroundColor = null;
                }
                break;

              //
              //column 4 - (pos, type -> link, func, mp3, note)
              //
              
              case 'pos':
                board.pos = newValue as String?;
                break;
              case 'type':
                board.type = newValue as int?;
                break;
              case 'type1':
                board.type1 = newValue as String?;
                break;
              case 'linkToUUID':
                board.linkToUUID = newValue as String?;
                break;
              case 'linkToLabel':
                board.linkToLabel = newValue as String?;
                break;
              case 'returnAfterSelect':
                board.returnAfterSelect = newValue as bool?;
                break;
              case 'function':
                board.function = newValue as String?;
                break;
              case 'audioClip':
                board.audioClip = newValue as String?;
                break;
              case 'note':
                board.note = newValue as String?;
                break;

              
              //
              //interfacing
              //
              default:
                SnackBar(content: Text("$obj failed"));
                return false; // field not found
            }
          }
          return true; 
        }
        
        static bool updateMultiGrammerField(Root root, List<String> uuids, String fieldName, dynamic newValue) {
          for (final obj in uuids){
            final row = findGrammerById(root.grammerRow, obj);
            if (row == null) return false;

            switch (fieldName) {

              //
              //column 1 - (symbol, padding, symbol color edits)
              //

              case 'symbol':
                row.symbol = newValue as String?;
                break;
              case 'padding':
                row.padding = newValue as double?;
                break;
              case 'matchOverlayColor':
                row.matchOverlayColor = newValue as bool?;
                break;
              case 'overlayColor':
                if (newValue is int) {
                  row.overlayColor = Color(newValue);
                } else if (newValue is Color) {
                  row.overlayColor = newValue;
                } else {
                  row.overlayColor = null;
                }
                break;
              case 'matchSymbolSaturation':
                row.matchSymbolSaturation = newValue as bool?;
                break;
              case 'symbolSaturation':
                row.symbolSaturation = newValue as double?;
                break;
              case 'matchSymbolContrast':
                row.matchSymbolContrast = newValue as bool?;
                break;
              case 'symbolContrast': 
                row.symbolContrast = newValue as double?;
                break;
              case 'matchInvertSymbol':
                row.matchInvertSymbol = newValue as bool?;
                break;
              case 'invertSymbol':
                row.invertSymbol = newValue as bool?;
                break;

              //
              //column 2 - (label, message, speakOS)
              //

              case 'label':
                row.label = newValue as String?;
                break;
              case 'matchSpeakOS':
                row.matchSpeakOS = newValue as bool?;
                break;
              case 'speakOS':
                row.speakOS = newValue as int?;
                break;
              case 'matchFont':
                row.matchFont = newValue as bool?;
                break;
              case 'fontSize':
                row.fontSize = newValue as double?;
                break;
              case 'fontItalics':
                row.fontItalics = newValue as bool?;
                break;
              case 'fontUnderline':
                row.fontUnderline = newValue as bool?;
                break;
              case 'fontWeight':
                row.fontWeight = newValue as double?;
                break;
              case 'fontFamily':
                row.fontFamily = newValue as String?;
                break;
              case 'fontColor':
                if (newValue is int) {
                  row.fontColor = Color(newValue);
                } else if (newValue is Color) {
                  row.fontColor = newValue;
                } else {
                  row.fontColor = null;
                }
                break;
              
              //
              //column 3 - (show, format,  border, background)
              //
              case 'matchFormat':
                row.matchFormat = newValue as bool?;
                break;
              case 'format':
                row.format = newValue as int?;
                break;
              case 'backgroundColor':
                if (newValue is int) {
                  row.backgroundColor = Color(newValue);
                } else if (newValue is Color) {
                  row.backgroundColor = newValue;
                } else {
                  row.backgroundColor = null;
                }
                break;

              //
              //column 4 - (pos, type -> link, func, mp3, note)
              //
              case 'type':
                row.type = newValue as String?;
                break;
              case 'function':
                row.function = newValue as String?;
                break;
              case 'note':
                row.note = newValue as String?;
                break;

              
              //
              //interfacing
              //
              default:
                SnackBar(content: Text("$obj failed"));
                return false; // field not found
            }
          }
          return true; 
        }
        
        static bool updateMultiNavField(Root root, List<String> uuids, String fieldName, dynamic newValue) {
        for (final obj in uuids){

          final row = findNavById(root.navRow, obj);
          if (row == null) return false;

          switch (fieldName) {

            //
            //column 1 - (symbol, padding, symbol color edits)
            //

            case 'symbol':
              row.symbol = newValue as String?;
              break;
            case 'padding':
              row.padding = newValue as double?;
              break;
            case 'matchOverlayColor':
              row.matchOverlayColor = newValue as bool?;
              break;
            case 'overlayColor':
              if (newValue is int) {
                row.overlayColor = Color(newValue);
              } else if (newValue is Color) {
                row.overlayColor = newValue;
              } else {
                row.overlayColor = null;
              }
              break;
            case 'matchSymbolSaturation':
              row.matchSymbolSaturation = newValue as bool?;
              break;
            case 'symbolSaturation':
              row.symbolSaturation = newValue as double?;
              break;
            case 'matchSymbolContrast':
              row.matchSymbolContrast = newValue as bool?;
              break;
            case 'symbolContrast': 
              row.symbolContrast = newValue as double?;
              break;
            case 'matchInvertSymbol':
              row.matchInvertSymbol = newValue as bool?;
              break;
            case 'invertSymbol':
              row.invertSymbol = newValue as bool?;
              break;

            //
            //column 2 - (label, message, speakOS)
            //

            case 'label':
              row.label = newValue as String?;
              break;
            case 'alternateLabel':
              row.alternateLabel = newValue as String?;
              break;
            case 'matchSpeakOS':
              row.matchSpeakOS = newValue as bool?;
              break;
            case 'speakOS':
              row.speakOS = newValue as int?;
              break;
            case 'matchFont':
              row.matchFont = newValue as bool?;
              break;
            case 'fontSize':
              row.fontSize = newValue as double?;
              break;
            case 'fontItalics':
              row.fontItalics = newValue as bool?;
              break;
            case 'fontUnderline':
              row.fontUnderline = newValue as bool?;
              break;
            case 'fontWeight':
              row.fontWeight = newValue as int?;
              break;
            case 'fontFamily':
              row.fontFamily = newValue as String?;
              break;
            case 'fontColor':
              if (newValue is int) {
                row.fontColor = Color(newValue);
              } else if (newValue is Color) {
                row.fontColor = newValue;
              } else {
                row.fontColor = null;
              }
              break;
            
            //
            //column 3 - (show, format,  border, background)
            //
            case 'show':
              row.show = newValue as bool?;
              break;
            case 'matchFormat':
              row.matchFormat = newValue as bool?;
              break;
            case 'format':
              row.format = newValue as int?;
              break;
            case 'matchBorder':
              row.matchBorder = newValue as bool?;
              break;
            case 'borderColor':
              if (newValue is int) {
                row.borderColor = Color(newValue);
              } else if (newValue is Color) {
                row.borderColor = newValue;
              } else {
                row.borderColor = null;
              }
              break;
            case 'borderWeight':
              row.borderWeight = newValue as double?;
              break;
            case 'matchPOS':
                row.matchPOS = newValue as bool?;
                break;
            case 'backgroundColor':
              if (newValue is int) {
                row.backgroundColor = Color(newValue);
              } else if (newValue is Color) {
                row.backgroundColor = newValue;
              } else {
                row.backgroundColor = null;
              }
              break;

            //
            //column 4 - (pos, type -> link, func, mp3, note)
            //
            case 'type':
              row.type = newValue as String;
              break;
            case 'pos':
              row.pos = newValue as String?;
              break;
            case 'linkToLabel':
              row.linkToLabel = newValue as String?;
              break;
            case 'linkToUUID':
              row.linkToUUID = newValue as String?;
              break;
            case 'note':
              row.note = newValue as String?;
              break;

            
            //
            //interfacing
            //
            default:
              return false; // field not found
          }
        }
          return true;
        }

      //save json
        static Future<void> saveJson(Root root) async {
          isSaving.value = true;
          final file = V4rs.currentFile;
          final jsonString = jsonEncode(root.toJson());
          await file!.writeAsString(jsonString);
          updateJsonHistory(root);
          Future.delayed(const Duration(milliseconds: 500), () {
            isSaving.value = false;
          });
        }

      //undo save (used for redo and undo)
        static Future<void> undoSave(Root root) async {
          isSaving.value = true;final file = V4rs.currentFile;
          final jsonString = jsonEncode(root.toJson());
          await file!.writeAsString(jsonString);
          reloadJson.value = !reloadJson.value;
          Future.delayed(const Duration(milliseconds: 500), () {
            isSaving.value = false;
          });
        }

      //delete a board
        static bool deleteBoard(Root root, String uuid) {
          isSaving.value = true;
          final boardIndex = root.boards.indexWhere((b) => b.id == uuid);
          if (boardIndex == -1) return false;
          root.boards.removeAt(boardIndex);
          reloadJson.value = !reloadJson.value;
          Future.delayed(const Duration(milliseconds: 500), () {
            isSaving.value = false;
          });
          return true;
        }

   
}