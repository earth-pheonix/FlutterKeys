import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/Settings_variable.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';


   class BoardEditor extends StatefulWidget{
      final void Function(BoardObjects board) openBoard;
      final void Function() goBack;
      final Root root;

      const BoardEditor({
        required this.openBoard,
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
      }

      void nowOpen(String newUUID) {
        var newBoard = Ev4rs.findBoardById(root.boards, newUUID);
        var linkedGrammer = newBoard != null 
          ? Ev4rs.findGrammerById(root.grammerRow, newBoard.useGrammerRow ?? '') 
          : null;

        Ev4rs.boardSelecting(newBoard, linkedGrammer);
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

        return Stack( 
          children: [
          
          ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
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
              
              return ValueListenableBuilder<bool>(valueListenable: Ev4rs.showAddBoard, builder: (context, reload, _) {
                return Row( 
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  //
                  //back, in positioned is the tap expander
                  //
                  Padding(padding: EdgeInsetsGeometry.all(7),
                  child: SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.065 : MediaQuery.of(context).size.height * 0.03 ,
                    child: ButtonStyle1(
                      imagePath: 'assets/interface_icons/interface_icons/iBack.png', 
                      onPressed: () {
                      setState(() {
                        Ev4rs.closeEditorAction();
                      });
                      }
                    ),
                  ),
                  ),
                
                  //
                  //content
                  //
                  Flexible(
                    flex: Ev4rs.showAddBoard.value ? 26 : 29,
                    child:
                  ValueListenableBuilder(valueListenable: Ev4rs.showAddBoard, builder: (context, showAdd, _) {
                    return SizedBox(
                      child: 
                      (Ev4rs.showAddBoard.value) 
                          ? addBoard()
                          : Padding(
                            padding: EdgeInsetsGeometry.all(10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                          
                          //title, edit layout/format
                          (Ev4rs.selectedBoard.value != null)
                          ? Flexible(
                            child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
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
                                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), 
                                              child: TextField(
                                                textAlign: TextAlign.center,
                                                style: Sv4rs.settingslabelStyle,
                                                onChanged: (value){
                                                  Ev4rs.title = value;
                                                },
                                                decoration: InputDecoration(
                                                hintStyle: Sv4rs.settingslabelStyle.copyWith(
                                                  fontSize: 14,
                                                  color: Cv4rs.themeColor2,
                                                ),
                                                hintText: Ev4rs.title,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            fit: FlexFit.loose,
                                            flex: 2, 
                                            child: Padding(
                                              padding: EdgeInsetsGeometry.symmetric(vertical: 5), 
                                              child: ButtonStyle4(
                                                imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                                onPressed: (){
                                                  if (compareToMap(Ev4rs.title)){
                                                    Ev4rs.updateBoardField(root, Ev4rs.selectedBoardUUID.value, 'title', Ev4rs.title);
                                                    Ev4rs.saveJson(root);
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('$newBoardTitle already exists'),
                                                        duration: Duration(milliseconds: 750),
                                                      ),
                                                    );
                                                  }
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
                            ),
                          )
                          : Expanded(child: SizedBox()),

                          //grammer row picker, use subfolders toggle,
                          (Ev4rs.selectedBoard.value != null)
                          ? Flexible(
                            child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            Container(
                                      decoration: BoxDecoration(
                                        color: Cv4rs.themeColor4,
                                        borderRadius: BorderRadius.circular(10)
                                        ),
                                      child: Column(children: [
                                        //
                                        //grammer row picker
                                        //
                                        Padding(padding: EdgeInsetsGeometry.all(10), child: 
                                          Row(children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                                flex: 5, 
                                                child: Padding(
                                                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0),
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
                                                padding: EdgeInsetsGeometry.symmetric(vertical: 5), 
                                                child: ButtonStyle4(
                                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                                  onPressed: (){
                                                      Ev4rs.updateBoardField(root, Ev4rs.selectedBoardUUID.value, 'useGrammerRow', Ev4rs.usedGrammerRowUUID.value);
                                                      Ev4rs.saveJson(root);
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
                                            padding: EdgeInsetsGeometry.all(10), 
                                            child: Row(children: [
                                              Flexible(
                                              fit: FlexFit.tight,
                                              flex: 5, 
                                              child: Padding(
                                                  padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0),
                                                  child:
                                            Column( children: [
                                              Text(
                                                'Use Subfolders:', 
                                                style: Sv4rs.settingslabelStyle,
                                                textAlign: TextAlign.start,
                                               ),
                                               Padding(padding: EdgeInsetsGeometry.all(5), child:
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
                                              padding: EdgeInsetsGeometry.symmetric(vertical: 5),  
                                              child: ButtonStyle4(
                                                imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                                onPressed: (){
                                                    Ev4rs.updateBoardField(root, Ev4rs.selectedBoardUUID.value, 'useSubFolders', Ev4rs.useSubFolders.value);
                                                    Ev4rs.saveJson(root);
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
                            ),
                          )
                          : Expanded(child: SizedBox()),

                          //delete, add, template
                          Flexible(
                            child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                          Column(
                              children: [
                              //add
                              Padding(
                                padding: EdgeInsetsGeometry.all(4),
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
                                padding: EdgeInsetsGeometry.all(4),
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
                                          Ev4rs.updateBoardField(root, button.id, "linkToUUID", '');
                                          Ev4rs.updateBoardField(root, button.id, "linkToLabel", '');
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
                            ),
                            ),
      
                          //edit grammer edit overlay
                          Flexible(
                            child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                          
                            Column(children: [
                              //edit grammer
                              Padding(
                                padding: EdgeInsetsGeometry.all(7),
                                child: ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iGrammerRowSettings.png', 
                                  onPressed: () async {
                                    
                                  },
                                  label: 'Edit Grammar Row'
                                )
                              ),

                              //edit overlay


                              ]
                              ),
                            ),
                          ),
                          ]
                          )
                        )
                      );
                  }
                  ),
                  ),
                  
                  //
                  //close add board
                  //
                  if (Ev4rs.showAddBoard.value) 
                  Flexible(
                    flex: 2, 
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
                      child: SizedBox( 
                        height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
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
                  if (Ev4rs.showAddBoard.value) 
                  Expanded(
                    flex: 1, 
                    child: Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
                      child: SizedBox( 
                      ),
                    ),
                  ),
                  

                  //
                  //undo + share
                  //
                  Flexible(flex: 2, child: 
                    Column( children:[
                      //undo
                      Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
                  child:
                      SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                    child:ValueListenableBuilder<bool>(
                        valueListenable: Ev4rs.isUndoing, 
                        builder: (context, inverting, _) {
                    return 
                      ButtonStyle1(
                        glow: (Ev4rs.isUndoing.value) ? true : false,
                        imagePath: 'assets/interface_icons/interface_icons/iUndo.png', 
                        onPressed: () { setState(() {
                          Ev4rs.undoAction(root);
                        });
                        }
                      );
                        }),
                      ),
                      ),

                      //share
                      Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
                  child:
                      SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                    child:
                    
                      ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iExport.png', 
                        onPressed: () { setState(() {
                          Ev4rs.isExporting.value = !Ev4rs.isExporting.value;
                        });
                        }
                      ), 
                      ),
                      ),
                    ]
                    ),
                  ),
                  
                  //
                  //redo + print
                  //
                  Flexible(flex: 2, child: 
                    Column( children:[
                      //redo
                      Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
                  child:
                      SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                    child: ValueListenableBuilder<bool>(
                        valueListenable: Ev4rs.isRedoing, 
                        builder: (context, inverting, _) {
                    return 
                      ButtonStyle1(
                        glow: (Ev4rs.isRedoing.value) ? true : false,
                        imagePath: 'assets/interface_icons/interface_icons/iRe-do.png', 
                        onPressed: () { setState(() {
                          Ev4rs.redoAction(root);
                        });
                        }
                      );
                        }),
                      ),
                      ),
                      //print
                      Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
                  child:
                      SizedBox( 
                    height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
                    child:
                      ButtonStyle1(
                        imagePath: 'assets/interface_icons/interface_icons/iPrint.png', 
                        onPressed: () { setState(() {
                          Ev4rs.isPrinting.value = !Ev4rs.isPrinting.value;
                        });
                        }
                      ),
                      ),
                      ),
                    ]
                    ),
                  ),
                  
                  //
                  //expand/collapse + board settings
                  //
                  Column( children:[
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(7, 7, 7, 0),
                      child: SizedBox( 
                        height: (isLandscape) ? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.04,
                        child: (Ev4rs.isButtonExpanded.value) 
                        ? ButtonStyle1(
                            imagePath: 'assets/interface_icons/interface_icons/iCollapse.png', 
                            onPressed: () { 
                              setState(() {
                                Ev4rs.isButtonExpanded.value = false;
                              });
                            }
                          ) 
                        : ButtonStyle1(
                            imagePath: 'assets/interface_icons/interface_icons/iExpand.png', 
                            onPressed: () { 
                              setState(() {
                                Ev4rs.isButtonExpanded.value = true;
                              });
                            }
                          ) 
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.fromLTRB(7, 0, 7, 7),
                      child: SizedBox( 
                        height: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04 ,
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(10), child: 
                          ButtonStyle1(
                              glow: (Ev4rs.boardEditor.value) ? true : false,
                              imagePath: 'assets/interface_icons/interface_icons/iBoard.png', 
                              onPressed: () { setState(() {
                                Ev4rs.editBoardsAction(root);
                              });
                              }
                            ) 
                          ),
                        ),
                      ),
                  ]
                  )
                ]
                );
              }
            );
           }
          ),
        //here
        Positioned(
          top: (isLandscape) ? MediaQuery.of(context).size.height * 0.08 : MediaQuery.of(context).size.height * 0.04,
          child: ValueListenableBuilder<bool>(valueListenable: Ev4rs.showSelectionMenu, builder: (context, showSelectionMenu, _) {
          return SizedBox( 
            height: (isLandscape) ? MediaQuery.of(context).size.height * 0.09 : MediaQuery.of(context).size.height * 0.04,
            child: Padding(
              padding: EdgeInsetsGeometry.all(7), 
              child: Row(
                children: [
              //tap
            if (Ev4rs.isButtonExpanded.value == false)
                ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iTap.png', 
                onPressed: () { setState(() {
                  Ev4rs.showSelectionMenu.value = !Ev4rs.showSelectionMenu.value;
                });
                }
              ),

            //tap and swap
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.tapAndSwap) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iTapAndSwap.png', 
                  onPressed: () { setState(() {
                    Ev4rs.tapAndSwapAction(root);
                  });
                  }
                ),

            //drag to select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.dragSelectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iDragSelectMultiple.png', 
                  onPressed: () { setState(() {
                    Ev4rs.dragSelectMultipleAction(root);
                  });
                }
              ),

            //select multiple
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
                ButtonStyle1(
                  glow: (Ev4rs.selectMultiple.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iSelectMultiple.png', 
                  onPressed: () { setState(() {
                    Ev4rs.selectMultipleAction(root);
                  });
                }
              ),

            //invert selection
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.invertSelections, 
                    builder: (context, inverting, _) { 
                return ButtonStyle1(
                  glow: (Ev4rs.invertSelections.value) ? true : false,
                  imagePath: 'assets/interface_icons/interface_icons/iInvertSelection.png', 
                  onPressed: () { 
                    setState(() {
                      Ev4rs.invertSelectionAction(root);
                    });
                  }
                );
              }),

            //sort a-z
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.sortSelectAZ, 
                    builder: (context, inverting, _) {
                return ButtonStyle1(
                glow: (Ev4rs.sortSelectAZ.value) ? true : false,
                imagePath: 'assets/interface_icons/interface_icons/iSortAZ.png', 
                onPressed: () { setState(() {
                  Ev4rs.sortSelectedAzAction(root);
                });
                }
              );}),

          ]
          ),
            ),
          );
        }
        )
        )
        ]
        );
      }
    
      Widget addBoard() {

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
            Expanded(
              flex: 2,
              child: SizedBox()
            ),
            
            Flexible(
              flex: 4,
              child: 
              Padding(
                padding: EdgeInsetsGeometry.all(20),
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
            
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
           
            Flexible(
              flex: 4,
              child:
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Cv4rs.themeColor4,
                  borderRadius: BorderRadius.circular(10)
                  ),
                child: Column( children: [
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(10, 15, 10, 5), 
                    child: Text('Create from Template:', 
                      style: Sv4rs.settingslabelStyle.copyWith(
                        fontSize: 12,
                        fontWeight: newFontWeight,
                      ), textAlign: TextAlign.center,
                      ),
                  ),
                  
                  //dropdown menu from template json
                  Row(children: [
                    Flexible(child: 
                    Padding(padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 0), child:
                      Text(
                        'Template:', 
                        style: Sv4rs.settingslabelStyle,
                      ),
                    ),
                    ),
                    Flexible(child: 
                    ValueListenableBuilder<String>(
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
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), 
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
            
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
          ],
        );
        //
            }

            return const Center(child: Text('Templates is Empty'));
          }
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