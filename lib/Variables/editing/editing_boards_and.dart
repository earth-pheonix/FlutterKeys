import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Models/json_model_grammer.dart';
import 'package:flutterkeysaac/Variables/assorted_ui/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/settings/settings_variables.dart';
import 'package:flutterkeysaac/Variables/colors/color_variables.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Variables/editing/editing_board_buttons.dart';


   class BoardEditor extends StatefulWidget{
      final void Function(BoardObjects board) openBoard;
      final void Function() goBack;
      final void Function(Root root, String objUUID, String field, dynamic value) saveField;
      final Root root;

      const BoardEditor({
        required this.openBoard,
        required this.saveField,
        required this.root,
        required this.goBack,
        super.key,
      });

      @override
      State<BoardEditor> createState() => _BoardEditorState();
    }

   class _BoardEditorState extends State<BoardEditor>{
      late Root root;
      late Root templateRoot;
      late Future<Root> loadedTemplates;
      
      final ValueNotifier<String> templateUUID = ValueNotifier<String>('');
      String newBoardTitle = '';

      void copyTemplateBoardToRoot({
        required Root root, required Root templateRoot, 
        required String templateId, required String newTitle}) async {
        
        //find selected template
        final templateBoard = Ev4rs.findBoardById(templateRoot.boards, templateId);
        if (templateBoard == null) {
          throw Exception('Template board with id $templateId not found.');
        }

        //make copy
        final copied = templateBoard.clone();

        //replace id 
        final uuid = const Uuid();
        copied.id = uuid.v4();
        copied.title = newTitle;

        for (var button in copied.content) {
          if (button.type1 != 'board'){
            button.id = uuid.v4();
          }
        }

        // add to main file & open
        root.boards.add(copied);
        
        // create variables for wait
        final wait = Ev4rs.reloadJson.value;
        void listener() {
          if (Ev4rs.reloadJson.value != wait) {
            Ev4rs.reloadJson.removeListener(listener);

            // Wait until next frame so Editor has rebuilt with the new root
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              _handleReload();
              nowOpen(copied.id);
              Ev4rs.showAddBoard.value = false;
            });
          }
        }

        Ev4rs.reloadJson.addListener(listener);

        Ev4rs.saveJson(root);
        Ev4rs.reloadJson.value = !Ev4rs.reloadJson.value;
      }

      void nowOpen(String newUUID) {
        var newBoard = Ev4rs.findBoardById(root.boards, newUUID);
        var linkedGrammer = newBoard != null 
          ? Ev4rs.findGrammerById(root.grammerRow, newBoard.useGrammerRow ?? '') 
          : null;

        Ev4rs.boardSelecting(newBoard, linkedGrammer, root.grammerRow);
        if (newBoard != null) {
          widget.openBoard(newBoard);
        } 
      }
  

      @override
      void initState(){
        Ev4rs.rootReady = false;
        super.initState();
        root = widget.root;
        loadedTemplates = V4rs.loadJsonTemplates();

        loadedTemplates.then((value) {
          setState(() {
            templateRoot = value;
          });
        });

        Ev4rs.reloadJson.addListener(_handleReload);
      }

      @override
      void dispose(){
        Ev4rs.reloadJson.removeListener(_handleReload);
        super.dispose();
      }

      void _handleReload() {
        setState(() {
          root = widget.root;
        });
      }


      Widget addBoard(bool isLandscape) {

        var allBoards = Ev4rs.getBoards(root.boards);

        final mapOfBoardNames = {
          for (var board in allBoards) 
            if (board.title != null) 
              board.title!
        };

        bool compareToMap(String newTitle){
          //true = new title is unique
          //false = new title is not unique
          //takes map of the names and for every name checks if it = new title, goal is for it not to
          return mapOfBoardNames.every((n) => n != newTitle);
        }
        
        return FutureBuilder<Root> (
          future: loadedTemplates,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {

        var allTemplates = Ev4rs.getBoards(templateRoot.boards);

        // Get the current numeric weight, default to 400 if null
        final currentWeight = Sv4rs.settingslabelStyle.fontWeight?.index != null
            ? Sv4rs.settingslabelStyle.fontWeight!.index * 100 + 100
            : 400;

        // add 100
        final newWeightValue = currentWeight + 100;

        // Map to FontWeight.values safely
        final newFontWeight = FontWeight.values[
            ((newWeightValue ~/ 100) - 1).clamp(0, FontWeight.values.length - 1)
        ];

        final mapOfTemplates = {
          for (var board in allTemplates) 
            if (board.title != null) 
              board.title!: board.id,
        };

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if(!V4rs.xSmallModeWidth)
            Expanded(
              flex: 4,
              child: SizedBox()
            ),
            
            Expanded(
              flex: 8,
              child: 
              Padding(
                padding: EdgeInsetsGeometry.all(V4rs.paddingValue(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ButtonStyle2(
                      imagePath: 'assets/interface_icons/interface_icons/iImport.png', 
                      onPressed: () async {
                        //import board action
                      }, 
                      label: "Import Board",
                    ),
                  ]
                ),
              ),
            ),
            
            if(!V4rs.xSmallModeWidth)
            Expanded(
              flex: 2,
              child: SizedBox()
            ),
           
            Expanded(
              flex: 8,
              child:
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)),
              child: Container(
                decoration: BoxDecoration(
                  color: Cv4rs.themeColor4,
                  borderRadius: BorderRadius.circular(10)
                  ),
                child: Column( 
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(
                        V4rs.paddingValue(10), 
                        V4rs.paddingValue(15), V4rs.paddingValue(10), V4rs.paddingValue(15)), 
                      child: Text(
                        'Create from Template:', 
                        style: Sv4rs.settingslabelStyle.copyWith(
                          fontSize: 12,
                          fontWeight: newFontWeight,
                        ), textAlign: TextAlign.center,
                      ),
                    ),
                  
                  //dropdown menu from template json
                  Row(children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(
                          V4rs.paddingValue(10), 0, 
                          V4rs.paddingValue(10), 0
                        ), 
                        child: Text(
                          'Template:', 
                          style: Sv4rs.settingslabelStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder<String>(
                      valueListenable: templateUUID, builder: (context, use, _) {
                        return DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                              'template: ${templateUUID.value}', 
                              style: Sv4rs.settingslabelStyle,
                            ),
                          value: use,
                          items: [
                              DropdownMenuItem<String>(
                                value: '',
                                child: Text('none', style: Sv4rs.settingslabelStyle),
                              ),
                            ...mapOfTemplates.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.value,
                                child: Text(
                                entry.key, 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                              );
                              }
                            )
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              templateUUID.value = value;
                            }
                          },
                          );
                        }
                      ),
                    ),
                  ]
                  ),
                  //title
                  Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10), vertical: 0), 
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: Sv4rs.settingslabelStyle,
                        onChanged: (value){ 
                          setState(() {
                            newBoardTitle = value;
                            }
                          );
                        },
                        decoration: InputDecoration(
                        hintStyle: Sv4rs.settingslabelStyle.copyWith(
                          color: Cv4rs.themeColor2,
                        ),
                        hintText: "Board Title:",
                        ),
                      ),
                    ),
                    

                  //type picker

                  //if type picker not keyboard show row and column picker
                 
                    ButtonStyle2(
                    imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                    onPressed: () async {
                      if (templateUUID.value.isNotEmpty) {
                        if (newBoardTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please title your board'), 
                                duration: Duration(milliseconds: 750),
                              ),
                            );
                        } else if (compareToMap(newBoardTitle)){
                          copyTemplateBoardToRoot(
                            root: root, 
                            templateRoot: templateRoot, 
                            templateId: templateUUID.value,
                            newTitle: newBoardTitle,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$newBoardTitle already exists'), 
                                duration: Duration(milliseconds: 750),
                              ),
                            );
                          }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please pick a template'), 
                            duration: Duration(milliseconds: 750),
                            ),
                        );
                      }
                    }, 
                    label: "Create",
                  ),
                  
              ]
              )
            ),
            ),
            ),
            
            if(!V4rs.xSmallModeWidth)
            Expanded(
              flex: 2,
              child: SizedBox()
            ),

            
                  //close add board
                  Expanded(
                    flex: 2, 
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(
                        V4rs.paddingValue(3), 
                        V4rs.paddingValue(7), V4rs.paddingValue(3), 0),
                      child: SizedBox( 
                        height: (isLandscape || V4rs.xSmallModeWidth) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                        child: ButtonStyle1(
                          imagePath: 'assets/interface_icons/interface_icons/iClose.png', 
                          onPressed: () {
                            setState(() {
                              Ev4rs.showAddBoard.value = !Ev4rs.showAddBoard.value;
                            });
                          }
                        )
                      ),
                    ),
                  ),
                  
                  //
                  //space between close and other butttons
                  //
                  if(!V4rs.xSmallModeWidth)
                  Expanded(
                    flex: 1, 
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(
                        V4rs.paddingValue(3), 
                        V4rs.paddingValue(7), V4rs.paddingValue(3), 0),
                      child: SizedBox( 
                      ),
                    ),
                  ),
          ],
        );
            }

            return const Center(child: Text('Templates is Empty'));
          }
        );
      }
 
      //title, edit layout/format
      Widget one(
        Function(String) compareToMap, 
      ) {
        if (Ev4rs.selectedBoard.value != null){
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(
            horizontal: V4rs.paddingValue(10)), child: 
          Container(
                    decoration: BoxDecoration(
                      color: Cv4rs.themeColor4,
                      borderRadius: BorderRadius.circular(10)
                      ),
                    child: Column(children: [
                      //
                      //board title
                      //
                      Row(children: [ 
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 5, 
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: V4rs.paddingValue(10), vertical: 0), 
                            child: ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                              final titleController = TextEditingController(text: value)
                                ..selection = TextSelection.collapsed(offset: value.length);

                            return TextField(
                              controller: titleController,
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                              onChanged: (value){
                                Ev4rs.title.value = value;
                              },
                              decoration: InputDecoration(
                              hintStyle: Sv4rs.settingslabelStyle.copyWith(
                                fontSize: 14,
                                color: Cv4rs.themeColor2,
                              ),
                              hintText: Ev4rs.title.value,
                              ),
                            );
                            }),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 2, 
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: V4rs.paddingValue(5)), 
                            child: ButtonStyle4(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){setState(() {
                                if (compareToMap(Ev4rs.title.value)){
                                  widget.saveField(root, Ev4rs.selectedBoardUUID.value, 'title', Ev4rs.title.value);
                                  Ev4rs.saveJson(root);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$newBoardTitle already exists'),
                                      duration: Duration(milliseconds: 750),
                                    ),
                                  );
                                }
                                });
                                }, 
                              label: 'Save'
                            ),
                          ),
                        ),
                      ],
                      ),

                      //
                      //edit layout/format- future
                      //

                    ]
                    )
                  )
          );
        } else
        {
          return SizedBox();
        }

      }
      //grammer row, use subfolders,          
      Widget two(
        Map mapOfGrammer, 
        Map mapOfUseSubfolders,
      ){
        if (Ev4rs.selectedBoard.value != null)
        {
          return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10), vertical: 5), child: 
            Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        //
                        //grammer row picker
                        //
                        Padding(padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)), child: 
                          Row(children: [
                            Flexible(
                              fit: FlexFit.loose,
                                flex: 5, 
                                child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10), vertical: 0),
                                  child:
                                Column(children: [
                                  Text('Grammar Row:', style: Sv4rs.settingslabelStyle, textAlign: TextAlign.center,),
                                  ValueListenableBuilder<String>(
                                  valueListenable: Ev4rs.usedGrammerRowUUID, builder: (context, use, _) {
                                  return DropdownButton<String>(
                                  isExpanded: true,
                                    hint: Text(
                                      'Grammar Row: ${Ev4rs.useGrammerRowTitle}', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                    value: use,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: '',
                                        child: Text('none', style: Sv4rs.settingsSecondaryLabelStyle, textAlign: TextAlign.center,),
                                      ),
                                    ...mapOfGrammer.entries.map((entry) {
                                      return DropdownMenuItem<String>(
                                        value: entry.value,
                                        child: Text(
                                          entry.key, 
                                          style: Sv4rs.settingsSecondaryLabelStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    })
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        Ev4rs.usedGrammerRowUUID.value = value;
                                        Ev4rs.useGrammerRowTitle.value = mapOfGrammer.entries.firstWhere((element) => element.value == value).key;
                                      }
                                    },
                                  );
                                  }
                                ),
                                ]
                                )
                            )
                              ),
                            Flexible(
                              fit: FlexFit.loose,
                              flex: 2, 
                              child: Padding(
                                padding: EdgeInsetsGeometry.symmetric(vertical: V4rs.paddingValue(5)), 
                                child: ButtonStyle4(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){setState(() {
                                      widget.saveField(root, Ev4rs.selectedBoardUUID.value, 'useGrammerRow', Ev4rs.usedGrammerRowUUID.value);
                                      Ev4rs.saveJson(root);
                                      Ev4rs.reloadJson.value = !Ev4rs.reloadJson.value;
                                      });
                                    }, 
                                  label: 'Save'
                                ),
                              ),
                            ),
                            ]
                          )
                        ),
                    
                        //
                        //use subfolders toggle
                        //
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.useSubFolders, 
                          builder: (context, use, _) {
                          return Padding(
                            padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)), 
                            child: Row(children: [
                              Flexible(
                              fit: FlexFit.tight,
                              flex: 5, 
                              child: Padding(
                                  padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10), vertical: 0),
                                  child:
                            Column( children: [
                              Text(
                                'Use Subfolders:', 
                                style: Sv4rs.settingslabelStyle,
                                textAlign: TextAlign.start,
                                ),
                                Padding(padding: EdgeInsetsGeometry.all(V4rs.paddingValue(5)), child:
                              ValueListenableBuilder<int>(
                                valueListenable: Ev4rs.useSubFolders, builder: (context, use, _) {
                                  return DropdownButton<int>(
                                    isExpanded: true,
                                    hint: Text(
                                        'use sub folders ${V4rs.useSubFoldersAsBool(Ev4rs.useSubFolders.value)}', 
                                        style: Sv4rs.settingslabelStyle,
                                      ),
                                    value: use,
                                    items: [
                                      ...mapOfUseSubfolders.entries.map((entry) {
                                        return DropdownMenuItem<int>(
                                          value: entry.key,
                                          child: Text(
                                          entry.value, 
                                            style: Sv4rs.settingsSecondaryLabelStyle,
                                          ),
                                        );
                                        }
                                      )
                                    ],
                                    onChanged: (key) {
                                      if (key != null) {
                                        Ev4rs.useSubFolders.value = key;
                                      }
                                    },
                                    );
                                  }
                                ),
                                ),
                              ]
                            ),
                            ),
                              ),
                            Flexible(
                              fit: FlexFit.tight,
                              flex: 2, 
                              child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(vertical: V4rs.paddingValue(5)),  
                              child: ButtonStyle4(
                                imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                onPressed: (){setState(() {
                                    widget.saveField(root, Ev4rs.selectedBoardUUID.value, 'useSubFolders', Ev4rs.useSubFolders.value);
                                    Ev4rs.saveJson(root);
                                    });
                                  }, 
                                label: 'Save'
                              ),
                            ),
                            ),
                            
                            ]
                            )
                          );
                        })

                      ]
                      )
                    )
          );
        } 
        else
        {
          return SizedBox();
        }
      }
      //delete, add, add as template
      Widget three() {
        return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10)), child: 
                          Column(
                              children: [
                              //add
                              Padding(
                                padding: EdgeInsetsGeometry.all(V4rs.paddingValue(4)),
                                child: ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iAddBoard.png', 
                                  onPressed: () async {
                                  templateRoot = await V4rs.loadJsonTemplates();
                                    if (templateRoot.boards.isNotEmpty) {
                                      Ev4rs.showAddBoard.value = true;
                                    } 
                                  },
                                  label: 'Add Board'
                                )
                              ),
                              //delete
                              Padding(
                                padding: EdgeInsetsGeometry.all(V4rs.paddingValue(4)),
                                child: ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iAddBoard.png', 
                                  onPressed: () async {
                                    final confirmDelete = await showDeleteBoardConfirmation(context, Ev4rs.selectedBoard.value?.title ?? ''); 
                                    if (confirmDelete == true) {
                                      setState(() {
                                        //remove mentions in JSON
                                        final nav = Ev4rs.findNavByLinked(root.navRow, Ev4rs.selectedBoardUUID.value);
                                        if (nav != null){
                                          Ev4rs.updateNavField(root, nav.id, "linkToUUID", '');
                                          Ev4rs.updateNavField(root, nav.id, "linkToLabel", '');
                                          
                                        }
                                        final button = Ev4rs.findBoardByLinked(root.boards, Ev4rs.selectedBoardUUID.value);
                                        if (button != null){
                                          widget.saveField(root, button.id, "linkToUUID", '');
                                          widget.saveField(root, button.id, "linkToLabel", '');
                                        }
                                        final grammer = Ev4rs.findGrammerByLinked(root.grammerRow, Ev4rs.selectedBoardUUID.value);
                                        if (grammer != null){
                                          Ev4rs.updateGrammerField(root, grammer.id, "openUUID", '');
                                        }

                                        //delete
                                        Ev4rs.deleteBoard(root, Ev4rs.selectedBoardUUID.value);
                                        Ev4rs.saveJson(root);

                                        //clear selection
                                        Ev4rs.selectedBoardUUID.value = '';
                                        Ev4rs.selectedBoard.value = null;
                                        widget.goBack();
                                      });
                                    }
                                  },
                                  label: 'Delete Board'
                                )
                              ),
                              
                              ]
                            ),
                            );

      }
      //edit grammer, edit langauage overlay
      Widget four(){
        return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10)), child: 
          Column(children: [
            //edit grammer
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(7)),
              child: ButtonStyle2(
                imagePath: 'assets/interface_icons/interface_icons/iGrammerRowSettings.png', 
                onPressed: () async {
                  Ev4rs.grammerRowEditor.value = true;
                },
                label: 'Edit Grammar Row'
              )
            ),

            //edit overlay


            ]
            ),
          );

      }
      
      @override
      Widget build(BuildContext context) {

        var allBoards = Ev4rs.getBoards(root.boards);

        final mapOfBoardNames = {
          for (var board in allBoards) 
            if (board.title != null) 
              board.title!
        };

        bool compareToMap(String newTitle){
          //true = new title is unique
          //false = new title is not unique
          //takes map of the names and for every name checks if it = new title, goal is for it not to
          return mapOfBoardNames.every((n) => n != newTitle);
        }

        if (Ev4rs.selectedBoard.value != null) {
          Ev4rs.setPlacholderValuesBoard(root.grammerRow, Ev4rs.selectedBoard.value!);
        }

        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        return BaseEditor(
          root: root,
          windowWidget: Row(children: [
          Expanded(
            flex: 29,
            child: ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
            var allGrammerRows= Ev4rs.getGrammerRows(root.grammerRow);

            final mapOfGrammer = {
              for (var row in allGrammerRows) 
                if (row.title != null) 
                  row.title!: row.id,
            };

            final mapOfUseSubfolders = {
              1 : 'on',
              2 : 'off',
              3 : 'match default',
            };
              
              return ValueListenableBuilder<bool>(valueListenable: Ev4rs.showAddBoard, builder: (context, showAdd, _) {
                return Row( 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                  //
                  //content
                  //
                  Expanded(
                    flex: showAdd ? 26 : 29,
                    child:SizedBox(
                      child: 
                      (showAdd) 
                          ? addBoard(isLandscape)
                          : Padding(
                            padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                if (V4rs.xSmallModeWidth)
                                Expanded(child: 
                                Column(
                                  children: [
                                    //title, edit layout/format
                                    one(compareToMap),

                                    //grammer row picker, use subfolders toggle,
                                    two(
                                      mapOfGrammer,
                                      mapOfUseSubfolders
                                    ),
                                  ],
                                ),
                                ),
                                if (V4rs.xSmallModeWidth)
                                Expanded(child:
                                Column(
                                  children: [
                                    //delete, add, add as template
                                    three(),

                                    //edit grammer, edit langauage overlay
                                    four(),
                                  ],
                                ), 
                                ),

                              if (!V4rs.xSmallModeWidth)
                              //title, edit layout/format
                              Expanded(child:
                                one(compareToMap),
                              ),

                              if (!V4rs.xSmallModeWidth)
                              //grammer row picker, use subfolders toggle,
                              Expanded(child:
                                two(
                                  mapOfGrammer,
                                  mapOfUseSubfolders
                                ),
                              ),

                              if (!V4rs.xSmallModeWidth)
                              //delete, add, add as template
                              Expanded(child:
                                three(),
                              ),

                              if (!V4rs.xSmallModeWidth)
                              //edit grammer, edit langauage overlay
                              Expanded(child:
                                four(),
                              ),
                              ]
                            )
                        )
                      ),
                  ),
                  ]
                );
              }
            );
           }
          ),
          ),
        ])
        );
      }
    
    }



   class GrammerRowEditor extends StatefulWidget{
      final void Function(BoardObjects board) openBoard;
      final void Function() goBack;
      final void Function(Root root, String objUUID, String field, dynamic value) saveField;
      final Root root;

      const GrammerRowEditor({
        required this.openBoard,
        required this.saveField,
        required this.root,
        required this.goBack,
        super.key,
      });

      @override
      State<GrammerRowEditor> createState() => _GrammerRowEditorState();
    }

   class _GrammerRowEditorState extends State<GrammerRowEditor>{
      late Root root;
      late Root templateRoot;
      late Future<Root> loadedTemplates;
      
      final ValueNotifier<String> templateUUID = ValueNotifier<String>('');
      String newRowTitle = '';

      void copyTemplateBoardToRoot({
        required Root root, required Root templateRoot, 
        required String templateId, required String newTitle}) async {
        
        //find selected template
        final templateRow = Ev4rs.findGrammerById(templateRoot.grammerRow, templateId);
        if (templateRow == null) {
          throw Exception('Template board with id $templateId not found.');
        }

        //make copy
        final copied = templateRow.clone();

        //replace id 
        final uuid = const Uuid();
        copied.id = uuid.v4();
        copied.title = newTitle;

        for (var button in copied.content) {
          if (button.type != 'row'){
            button.id = uuid.v4();
          }
        }

        // add to main file & open
        root.grammerRow.add(copied);
        
        // create variables for wait
        final wait = Ev4rs.reloadJson.value;
        void listener() {
          if (Ev4rs.reloadJson.value != wait) {
            Ev4rs.reloadJson.removeListener(listener);

            // Wait until next frame so Editor has rebuilt with the new root
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              _handleReload();
              Ev4rs.showAddGrammer.value = false;
            });
          }
        }

        Ev4rs.reloadJson.addListener(listener);

        Ev4rs.saveJson(root);
        Ev4rs.reloadJson.value = !Ev4rs.reloadJson.value;
      }

      void nowOpen(String newUUID) {
        var newBoard = Ev4rs.findBoardById(root.boards, newUUID);
        var linkedGrammer = newBoard != null 
          ? Ev4rs.findGrammerById(root.grammerRow, newBoard.useGrammerRow ?? '') 
          : null;

        Ev4rs.boardSelecting(newBoard, linkedGrammer, root.grammerRow);
        if (newBoard != null) {
          widget.openBoard(newBoard);
        } 
      }
  

      @override
      void initState(){
        Ev4rs.rootReady = false;
        super.initState();
        root = widget.root;
        loadedTemplates = V4rs.loadJsonTemplates();

        loadedTemplates.then((value) {
          setState(() {
            templateRoot = value;
          });
        });

        Ev4rs.reloadJson.addListener(_handleReload);
      }

      @override
      void dispose(){
        Ev4rs.reloadJson.removeListener(_handleReload);
        super.dispose();
      }

      void _handleReload() {
        setState(() {
          root = widget.root;
        });
      }


      Widget addGrammerRow(bool isLandscape) {

        var allGrammer = Ev4rs.getGrammerRows(root.grammerRow);

        final mapOfBoardNames = {
          for (var row in allGrammer) 
            if (row.title != null) 
              row.title!
        };

        bool compareToMap(String newTitle){
          //true = new title is unique
          //false = new title is not unique
          //takes map of the names and for every name checks if it = new title, goal is for it not to
          return mapOfBoardNames.every((n) => n != newTitle);
        }
        
        return FutureBuilder<Root> (
          future: loadedTemplates,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.hasData) {

        var allTemplates = Ev4rs.getGrammerRows(templateRoot.grammerRow);

        // Get the current numeric weight, default to 400 if null
        final currentWeight = Sv4rs.settingslabelStyle.fontWeight?.index != null
            ? Sv4rs.settingslabelStyle.fontWeight!.index * 100 + 100
            : 400;

        // add 100
        final newWeightValue = currentWeight + 100;

        // Map to FontWeight.values safely
        final newFontWeight = FontWeight.values[
            ((newWeightValue ~/ 100) - 1).clamp(0, FontWeight.values.length - 1)
        ];

        final mapOfTemplates = {
          for (var row in allTemplates) 
            if (row.title != null) 
              row.title!: row.id,
        };

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if(!V4rs.xSmallModeWidth)
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
            Expanded(
              flex: 8,
              child:
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)),
              child: Container(
                decoration: BoxDecoration(
                  color: Cv4rs.themeColor4,
                  borderRadius: BorderRadius.circular(10)
                  ),
                child: Column( 
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(
                        V4rs.paddingValue(10), 
                        V4rs.paddingValue(15), V4rs.paddingValue(10), V4rs.paddingValue(15)), 
                      child: Text(
                        'Create from Template:', 
                        style: Sv4rs.settingslabelStyle.copyWith(
                          fontSize: 12,
                          fontWeight: newFontWeight,
                        ), textAlign: TextAlign.center,
                      ),
                    ),
                  
                  //dropdown menu from template json
                  Row(children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsGeometry.fromLTRB(
                          V4rs.paddingValue(10), 0, 
                          V4rs.paddingValue(10), 0
                        ), 
                        child: Text(
                          'Template:', 
                          style: Sv4rs.settingslabelStyle,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder<String>(
                      valueListenable: templateUUID, builder: (context, use, _) {
                        return DropdownButton<String>(
                          isExpanded: true,
                          hint: Text(
                              'template: ${templateUUID.value}', 
                              style: Sv4rs.settingslabelStyle,
                            ),
                          value: use,
                          items: [
                              DropdownMenuItem<String>(
                                value: '',
                                child: Text('none', style: Sv4rs.settingslabelStyle),
                              ),
                            ...mapOfTemplates.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.value,
                                child: Text(
                                entry.key, 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                              );
                              }
                            )
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              templateUUID.value = value;
                            }
                          },
                          );
                        }
                      ),
                    ),
                  ]
                  ),
                  //title
                  Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10), vertical: 0), 
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: Sv4rs.settingslabelStyle,
                        onChanged: (value){ 
                          setState(() {
                            newRowTitle = value;
                            }
                          );
                        },
                        decoration: InputDecoration(
                        hintStyle: Sv4rs.settingslabelStyle.copyWith(
                          color: Cv4rs.themeColor2,
                        ),
                        hintText: "Row Title:",
                        ),
                      ),
                    ),
                 
                    ButtonStyle2(
                    imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                    onPressed: () async {
                      if (templateUUID.value.isNotEmpty) {
                        if (newRowTitle.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please title your Row'), 
                                duration: Duration(milliseconds: 750),
                              ),
                            );
                        } else if (compareToMap(newRowTitle)){
                          copyTemplateBoardToRoot(
                            root: root, 
                            templateRoot: templateRoot, 
                            templateId: templateUUID.value,
                            newTitle: newRowTitle,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$newRowTitle already exists'), 
                                duration: Duration(milliseconds: 750),
                              ),
                            );
                          }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please pick a template'), 
                            duration: Duration(milliseconds: 750),
                            ),
                        );
                      }
                    }, 
                    label: "Create",
                  ),
                  
              ]
              )
            ),
            ),
            ),
            
            if(!V4rs.xSmallModeWidth)
            Expanded(
              flex: 2,
              child: SizedBox()
            ),

            
                  //close add board
                  Expanded(
                    flex: 2, 
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(
                        V4rs.paddingValue(3), 
                        V4rs.paddingValue(7), V4rs.paddingValue(3), 0),
                      child: SizedBox( 
                        height: (isLandscape || V4rs.xSmallModeWidth) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                        child: ButtonStyle1(
                          imagePath: 'assets/interface_icons/interface_icons/iClose.png', 
                          onPressed: () {
                            setState(() {
                              Ev4rs.showAddBoard.value = !Ev4rs.showAddBoard.value;
                            });
                          }
                        )
                      ),
                    ),
                  ),
                  
                  //
                  //space between close and other butttons
                  //
                  if(!V4rs.xSmallModeWidth)
                  Expanded(
                    flex: 1, 
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(
                        V4rs.paddingValue(3), 
                        V4rs.paddingValue(7), V4rs.paddingValue(3), 0),
                      child: SizedBox( 
                      ),
                    ),
                  ),
          ],
        );
            }

            return const Center(child: Text('Templates is Empty'));
          }
        );
      }
 
      //title
      Widget one(
        Function(String) compareToMap, 
      ) {
        if (Ev4rs.selectedGrammerRow.value != null){
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(
            horizontal: V4rs.paddingValue(10)), child: 
          Container(
                    decoration: BoxDecoration(
                      color: Cv4rs.themeColor4,
                      borderRadius: BorderRadius.circular(10)
                      ),
                    child: 
                      //
                      //Row title
                      //
                      Row(children: [ 
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 5, 
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: V4rs.paddingValue(10), vertical: 0), 
                            child: ValueListenableBuilder(valueListenable: Ev4rs.notes, builder: (context, value, _) {
                              final titleController = TextEditingController(text: value)
                                ..selection = TextSelection.collapsed(offset: value.length);

                            return TextField(
                              controller: titleController,
                              textAlign: TextAlign.center,
                              style: Sv4rs.settingslabelStyle,
                              onChanged: (value){
                                Ev4rs.title.value = value;
                              },
                              decoration: InputDecoration(
                              hintStyle: Sv4rs.settingslabelStyle.copyWith(
                                fontSize: 14,
                                color: Cv4rs.themeColor2,
                              ),
                              hintText: Ev4rs.title.value,
                              ),
                            );
                            }),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          flex: 2, 
                          child: Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: V4rs.paddingValue(5)), 
                            child: ButtonStyle4(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){setState(() {
                                if (compareToMap(Ev4rs.title.value)){
                                  widget.saveField(root, Ev4rs.selectedGrammerRowUUID, 'title', Ev4rs.title.value);
                                  Ev4rs.saveJson(root);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$newRowTitle already exists'),
                                      duration: Duration(milliseconds: 750),
                                    ),
                                  );
                                }
                                });
                                }, 
                              label: 'Save'
                            ),
                          ),
                        ),
                      ],
                      ),

                  )
          );
        } else
        {
          return SizedBox();
        }

      }
      //delete, add, add as template
      Widget three() {
        return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10)), child: 
            Column(
                children: [
                //add
                Padding(
                  padding: EdgeInsetsGeometry.all(V4rs.paddingValue(4)),
                  child: ButtonStyle2(
                    imagePath: 'assets/interface_icons/interface_icons/iAddBoard.png', 
                    onPressed: () async {
                    templateRoot = await V4rs.loadJsonTemplates();
                      if (templateRoot.grammerRow.isNotEmpty) {
                        Ev4rs.showAddGrammer.value = true;
                      } 
                    },
                    label: 'Add Grammer Row'
                  )
                ),
                //delete
                Padding(
                  padding: EdgeInsetsGeometry.all(V4rs.paddingValue(4)),
                  child: ButtonStyle2(
                    imagePath: 'assets/interface_icons/interface_icons/iAddBoard.png', 
                    onPressed: () async {
                      final confirmDelete = await showDeleteGramerRowConfirmation(context, Ev4rs.selectedGrammerRow.value?.title ?? ''); 
                      if (confirmDelete == true) {
                        setState(() {
                          //remove mentions in JSON
                          for (final board in root.boards){
                            if (board.useGrammerRow == Ev4rs.selectedGrammerRowUUID){
                              Ev4rs.updateBoardField(root, board.id, "useGrammerRow", null);
                            }
                          }

                          //delete
                          Ev4rs.deleteGrammerRow(root, Ev4rs.selectedGrammerRowUUID);
                          Ev4rs.saveJson(root);

                          //clear selection
                          Ev4rs.selectedGrammerRowUUID = '';
                          Ev4rs.selectedGrammerRow.value = null;
                        });
                      }
                    },
                    label: 'Delete Grammer Row'
                  )
                ),
                
                ]
              ),
              );

      }
      //edit grammer, edit langauage overlay
      Widget four(){
        return Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: V4rs.paddingValue(10)), child: 
                          
          Column(children: [
            //edit boards
            Padding(
              padding: EdgeInsetsGeometry.all(V4rs.paddingValue(7)),
              child: ButtonStyle2(
                imagePath: 'assets/interface_icons/interface_icons/iBoard.png', 
                onPressed: () async {
                  Ev4rs.grammerRowEditor.value = false;
                  Ev4rs.selectedGrammerRow.value = null;
                  Ev4rs.selectedGrammerRowUUID = '';

                  Ev4rs.boardEditor.value = true;
                },
                label: 'Edit Boards'
              )
            ),

            //edit overlay


            ]
            ),
          );

      }
      
      @override
      Widget build(BuildContext context) {

        var allGrammer = Ev4rs.getGrammerRows(root.grammerRow);

        final mapOfGrammerRowNames = {
          for (var row in allGrammer) 
            if (row.title != null) 
              row.title!
        };

        bool compareToMap(String newTitle){
          //true = new title is unique
          //false = new title is not unique
          //takes map of the names and for every name checks if it = new title, goal is for it not to
          return mapOfGrammerRowNames.every((n) => n != newTitle);
        }

        if (Ev4rs.selectedGrammerRow.value != null) {
          Ev4rs.setPlacholderValuesGrammerRow(Ev4rs.selectedGrammerRow.value!);
        }

        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        return BaseEditor(
          root: root,
          windowWidget: Row(children: [
          Expanded(
            flex: 29,
            child: ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
              

              return ValueListenableBuilder<bool>(valueListenable: Ev4rs.showAddGrammer, builder: (context, showAdd, _) {
                return Row( 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                
                  //
                  //content
                  //
                  Expanded(
                    flex: showAdd ? 26 : 29,
                    child:SizedBox(
                      child: 
                      (showAdd) 
                          ? addGrammerRow(isLandscape)
                          : Padding(
                            padding: EdgeInsetsGeometry.all(V4rs.paddingValue(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                if (V4rs.xSmallModeWidth)
                                Expanded(child: 
                                Column(
                                  children: [
                                    //title, edit layout/format
                                    one(compareToMap),
                                  ],
                                ),
                                ),
                                if (V4rs.xSmallModeWidth)
                                Expanded(child:
                                Column(
                                  children: [
                                    //delete, add, add as template
                                    three(),

                                    //edit board, edit langauage overlay
                                    four(),
                                  ],
                                ), 
                                ),

                              if (!V4rs.xSmallModeWidth)
                              //title, edit layout/format
                              Expanded(
                                flex: 2,
                                child:
                                one(compareToMap),
                              ),

                              if (!V4rs.xSmallModeWidth)
                              //delete, add, add as template
                              Expanded(child:
                                three(),
                              ),

                              if (!V4rs.xSmallModeWidth)
                              //edit grammer, edit langauage overlay
                              Expanded(child:
                                four(),
                              ),
                              ]
                            )
                        )
                      ),
                  ),
                  ]
                );
              }
            );
           }
          ),
          ),
        ])
        );
      }
    
    }



//confirmations 

Future<bool?> showDeleteBoardConfirmation(BuildContext context, String boardTitle) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Board'),
        content: Text(
          'Are you sure you want to delete "$boardTitle" board? You can make a new one later, but this one will be gone.',
          style: Sv4rs.settingslabelStyle,),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: Sv4rs.settingslabelStyle),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
          ),
          TextButton(
            child: Text('Delete', style: Sv4rs.settingslabelStyle,),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
          ),
        ],
      );
    },
  );
}


Future<bool?> showDeleteGramerRowConfirmation(BuildContext context, String rowTitle) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Grammer Row'),
        content: Text(
          'Are you sure you want to delete "$rowTitle"? You can make a new one later, but this one will be gone.',
          style: Sv4rs.settingslabelStyle,),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: Sv4rs.settingslabelStyle),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
          ),
          TextButton(
            child: Text('Delete', style: Sv4rs.settingslabelStyle,),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
          ),
        ],
      );
    },
  );
}


Future<bool?> showTitleConfirmation(BuildContext context, String boardTitle) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Board Title'),
        content: Text(
          'A diffent board already has this title. Please choose a different name.',
          style: Sv4rs.settingslabelStyle,),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: Sv4rs.settingslabelStyle),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false
            },
          ),
          TextButton(
            child: Text('Delete', style: Sv4rs.settingslabelStyle,),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true
            },
          ),
        ],
      );
    },
  );
}