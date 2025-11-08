import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/ui_shortcuts.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';
import 'package:flutterkeysaac/Variables/boardset_settings_variables.dart';
import 'package:flutterkeysaac/Variables/Settings_variable.dart';
import 'package:flutterkeysaac/Variables/color_variables.dart';
import 'package:flutterkeysaac/Variables/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterkeysaac/Variables/grammer_variables.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

//
//editor windows
//

   class BaseEditor extends StatefulWidget{
      const BaseEditor({
        super.key,
      });

      @override
      State<BaseEditor> createState() => _BaseEditorState();
    }

   class _BaseEditorState extends State<BaseEditor>{
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

      @override
      Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        return Stack( children: [
          ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
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

              Expanded(
                flex: 29,
                child: SizedBox(),
              ),

              //
              //undo + share
              //
              
              Expanded(flex: 2, child: 
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
              Expanded(flex: 2, child: 
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
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
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
    }

  //===: button editor

    class ButtonEditor extends StatefulWidget{
      final BoardObjects obj;
      const ButtonEditor({
        super.key,
        required this.obj,
      });

      @override
      State<ButtonEditor> createState() => _ButtonEditorState();
    }

    class _ButtonEditorState extends State<ButtonEditor>{
      late AudioPlayer _player;
      late Future<Root> rootFuture;
      final ImagePicker _picker = ImagePicker();
      late Root root;
      var everyImage = <String>[];
      var everyMp3 = <String>[];

      @override
      void initState(){
        Ev4rs.rootReady = false;
        super.initState();
        rootFuture = V4rs.loadRootData();

        _player = AudioPlayer();

        Ev4rs.reloadJson.addListener(_handleReload);
      }

      @override
      void dispose(){
        _player.dispose();
        Ev4rs.reloadJson.removeListener(_handleReload);
        super.dispose();
      }

      void _handleReload() {
        setState(() {
          rootFuture = V4rs.loadRootData();
        });
      }

      @override
      Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        return Stack( children: [
          ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
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
              
            everyImage = Ev4rs.getAllImages(root);
            everyMp3 = Ev4rs.getAllMp3(root);
          

            final obj_ = Ev4rs.findBoardById(root.boards, Ev4rs.selectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol(obj_.symbol);

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
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: ImageStyle1(
                                      image: image, 
                                      symbolSaturation: Ev4rs.saturation.value, 
                                      symbolContrast: Ev4rs.contrast.value, 
                                      invertSymbolColors: Ev4rs.invert.value, 
                                      overlayColor: Ev4rs.overlay.value, 
                                      matchOverlayColor: Ev4rs.matchOverlay.value, 
                                      matchSymbolContrast: Ev4rs.matchContrast.value, 
                                      matchSymbolInvert: Ev4rs.matchInvert.value, 
                                      matchSymbolSaturation: Ev4rs.matchSaturation.value,
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.pickImage(root, _picker);
                                              if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                              await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.pickImage(root, _picker);
                                          if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                            await Ev4rs.cleanupUnusedImages(everyImage);
                                          } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                        Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'overlayColor', Ev4rs.overlay.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'symbolSaturation', Ev4rs.saturation.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'symbolContrast', Ev4rs.contrast.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    matchContrast: Ev4rs.matchContrast.value,
                    matchInvert: Ev4rs.matchInvert.value,
                    matchOverlay: Ev4rs.matchOverlay.value,
                    matchSaturation: Ev4rs.matchSaturation.value,
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                  

                ]
                ),
              );
              }
            ),
              
              //
              //label, message, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label and message
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              TextField(
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: '${obj_.label}',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'label', Ev4rs.label);
                                if (Ev4rs.matchLabel){
                                  Ev4rs.label = '${Ev4rs.label.trim()} ';
                                  Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'message', Ev4rs.label);
                                }
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                        Row(children: [ 
                        Expanded(
                          flex: 5,
                          child: 
                        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                          TextField(
                            style: Ev4rs.labelStyle,
                            onChanged: (value){
                              Ev4rs.message = value;
                            },
                            decoration: InputDecoration(
                            hintStyle: Ev4rs.hintLabelStyle,
                            hintText: '${obj_.message}',
                            ),
                          ),
                        ),
                        ),
                        Flexible(
                          flex: 2,
                          child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                        ButtonStyle4(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                              Ev4rs.message = '${Ev4rs.message.trim()} ';
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'message', Ev4rs.message);
                              if (Ev4rs.matchLabel){
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'label', Ev4rs.message.trim());
                              }
                              Ev4rs.saveJson(root);
                          }, 
                          label: 'Save'
                          ),
                          ),
                        ),
                      ]
                      ),
                        Row(children: [
                          Expanded(child: 
                            Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Text(
                                'Match Label & Message', 
                                style: Sv4rs.settingslabelStyle
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), child: 
                            Switch(
                              padding: EdgeInsets.all(0),
                              value: Ev4rs.matchLabel, 
                              onChanged: (value) {
                                Ev4rs.matchLabel = value;
                              }
                            ),
                          ),
                        ]
                        ),
                      
                    ]
                      
                    ))),
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text(
                                  'Match Speak on Select:', 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 'Speak on Select: ${Ev4rs.speakOnSelect.value}',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Message", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){
                                    if (Ev4rs.rootReady) {
                                      Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                    }
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchFont', Ev4rs.matchFont.value);
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'fontSize', Ev4rs.fontSize.value);
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'fontItalics', Ev4rs.fontItalics.value);
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'fontUnderline', Ev4rs.fontUnderline.value);
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'fontWeight', Ev4rs.fontWeight.value);
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'fontFamily', Ev4rs.fontFamily.value);
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save Button Font'
                            ),
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              //show, format, border, background
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //show button
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container( 
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.show, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(
                                child: Text(
                                  'Show Button:', 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.show.value, 
                                  onChanged: (value) {
                                    Ev4rs.show.value = value;
                                  }
                                ),
                              ),
                              ]
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'show', Ev4rs.show.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 0), 
                                    child: Text(
                                      'Match Format:', 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${
                                          Ev4rs.format.value == 1 ? 
                                            'Text Below' 
                                          : Ev4rs.format.value == 2 ? 
                                            'Text Above' 
                                          : Ev4rs.format.value == 3 ? 
                                            'Image Only' 
                                          : Ev4rs.format.value == 4 ? 
                                            'Text Only' 
                                          : ''
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchFormat', Ev4rs.matchFormat.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //
                  //border
                  //

                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBorder, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 20), 
                                    child: Text(
                                      'Match Border:', 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBorder.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchBorder.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border weight 
                        ValueListenableBuilder<double>(
                          valueListenable: Ev4rs.borderWeight, 
                          builder: (context, borderWeight, _) {
                            return Column (children: [
                            Text('Border Weight: ${Ev4rs.borderWeight.value}', style: Sv4rs.settingslabelStyle),
                            Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 20,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 'Border Weight: ${Ev4rs.borderWeight.value}',
                                  value: Ev4rs.borderWeight.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.borderWeight.value = value;
                                    }
                            )
                            ]
                                  );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.borderColor, 
                          builder: (context, borderColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text('Border Color:', style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.borderColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),
                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.borderColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.borderColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.borderColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.borderColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'borderWeight', Ev4rs.borderWeight.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchBorder', Ev4rs.matchBorder.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'borderColor', Ev4rs.borderColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //background
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBackground, 
                          builder: (context, matchBackground, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                    child: Text(
                                      'Match Color:', 
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBackground.value,
                                  onChanged: (value) {
                                    Ev4rs.matchBackground.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text('Button Color:', style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),

                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'matchPOS', Ev4rs.matchBackground.value);
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              //pos, button type -> link, return after select, grammer func, mp3
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //part of speech
                  
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: SizedBox( child:
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.pos, 
                          builder: (context, pos, _) {
                            return 
                          Column(children: [
                            SizedBox(child:
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: SizedBox(child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),),
                              value: Ev4rs.pos.value.toLowerCase(),
                              items: Gv4rs.partOfSpeechList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(child: Text(
                                    item,
                                    style: Sv4rs.settingslabelStyle,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                  Ev4rs.pos.value = value;
                                }
                                }
                            ),
                            ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'pos', Ev4rs.pos.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                    ),
                  ),
                  //type 
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.buttonType, 
                          builder: (context, buttonType, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Button Type:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<int>(
                              isExpanded: true,
                                hint: Text(
                                  'button type', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.buttonType.value,
                                items: V4rs.buttonTypeMap.entries.map((entry) {
                                  return DropdownMenuItem<int>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.buttonType.value = value;
                                  }
                                },
                              ),
                            ),
                  
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'type', Ev4rs.buttonType.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                  
                  ),
                  ),

                  //if pocket folder or folder
                  if (Ev4rs.buttonType.value == 3 || Ev4rs.buttonType.value == 2)
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Link To...', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'link to...', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: 
                                    Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                    Ev4rs.linkLabel.value = mapOfBoards.entries.firstWhere((element) => element.value == value).key;
                                  }
                                },
                              ),
                            ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){
                                if (Ev4rs.rootReady) {
                                  Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'linkToUUID', Ev4rs.link.value);
                                  Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'linkToLabel', Ev4rs.linkLabel.value);
                                  Ev4rs.saveJson(root);
                                }
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  if (Ev4rs.buttonType.value == 3 || Ev4rs.buttonType.value == 2)
                  Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: Ev4rs.returnAfterSelect, 
                        builder: (context, returnAfterSelect, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                  child: Text(
                                    'Return After Select:', 
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Sv4rs.settingslabelStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                              child: Switch(
                                padding: EdgeInsets.all(0),
                                value: Ev4rs.returnAfterSelect.value,
                                onChanged: (value) {
                                  Ev4rs.returnAfterSelect.value = value;
                                }
                              ),
                            ),
                          ]
                          );
                        }
                      ),
                      ButtonStyle2(
                            imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              if (Ev4rs.rootReady) {
                                Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'returnAfterSelect', Ev4rs.returnAfterSelect.value);
                                Ev4rs.saveJson(root);
                              }
                            }, 
                            label: 'Save'
                          ),
                        
                        ]
                        ),
                    ),
                    ),

                  //if grammer
                  if (Ev4rs.buttonType.value == 6)
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.grammerFunction, 
                          builder: (context, grammerFunction, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Grammer Function:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  'grammer function', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.grammerFunction.value,
                                items: Gv4rs.grammerFunctionMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.grammerFunction.value = value;
                                  }
                                },
                              ),
                          ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'function', Ev4rs.grammerFunction.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                  ),
                  
                  //if audio tile
                  if (Ev4rs.buttonType.value == 4)
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child:
                    Container(
                        padding: EdgeInsetsGeometry.all(10),
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                        child: Column(children: [
                          SizedBox( child: 
                          ButtonStyle2(
                            imagePath: 'assets/interface_icons/interface_icons/iPlay.png', 
                            onPressed: () async {
                              await LoadAudio.fromAudio(obj_.audioClip);
                            },
                            label: 'Play'
                          ),
                          ),
                          SizedBox( child: 
                          ButtonStyle3(
                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                            onPressed: () async {
                              Ev4rs.pickMP3(root);
                              if (Ev4rs.rootReady && everyMp3.isNotEmpty) {
                                await Ev4rs.cleanupUnusedmp3(everyMp3);
                                } 
                            }, 
                            label: 'upload mp3'
                            )
                          ),
                        ]
                      )
                    ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              TextField(
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: 'Notes... ${Ev4rs.notes.value}',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    ))),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
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
              Expanded(flex: 2, child: 
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
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
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
    }

    class MultiButtonEditor extends StatefulWidget{
      final BoardObjects obj;
      const MultiButtonEditor({
        super.key,
        required this.obj,
      });

      @override
      State<MultiButtonEditor> createState() => _MultiButtonEditor();
    }

    class _MultiButtonEditor extends State<MultiButtonEditor>{
      late AudioPlayer _player;
      late Future<Root> rootFuture;
      final ImagePicker _picker = ImagePicker();
      late Root root;
      var everyImage = <String>[];
      var everyMp3 = <String>[];

      @override
      void initState(){
        Ev4rs.rootReady = false;
        super.initState();
        rootFuture = V4rs.loadRootData();

        _player = AudioPlayer();

        Ev4rs.reloadJson.addListener(_handleReload);
      }

      @override
      void dispose(){
        _player.dispose();
        Ev4rs.reloadJson.removeListener(_handleReload);
        super.dispose();
      }

      void _handleReload() {
        setState(() {
          rootFuture = V4rs.loadRootData();
        });
      }

      @override
      Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        return Stack( children: [
          ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
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
              
            everyImage = Ev4rs.getAllImages(root);
            everyMp3 = Ev4rs.getAllMp3(root);
          

            final obj_ = Ev4rs.findBoardById(root.boards, Ev4rs.selectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol('assets/interface_icons/interface_icons/iPlaceholder.png');
            Widget image2 = LoadImage.fromSymbol(obj_.symbol);

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
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: (!Ev4rs.compareObjFields(root.boards, (b) => b.symbol)) ?
                                  Column(children: [
                                    Text('--Not All Match--', style: Sv4rs.settingslabelStyle),
                                    ImageStyle1(
                                        image: image, 
                                        symbolSaturation: Bv4rs.buttonSymbolSaturation, 
                                        symbolContrast: Bv4rs.buttonSymbolContrast, 
                                        invertSymbolColors: Bv4rs.buttonSymbolInvert, 
                                        overlayColor: Bv4rs.buttonSymbolColorOverlay, 
                                        matchOverlayColor: true, 
                                        matchSymbolContrast: true, 
                                        matchSymbolInvert: true, 
                                        matchSymbolSaturation: true,
                                        defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                        defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                        defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                        defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      ) 
                                    ]
                                    )
                                  : ImageStyle1(
                                      image: image2, 
                                      symbolSaturation: obj_.symbolSaturation ?? 1.0, 
                                      symbolContrast: obj_.symbolContrast ?? 1.0, 
                                      invertSymbolColors: obj_.invertSymbol ?? false, 
                                      overlayColor: obj_.overlayColor ?? Colors.white,
                                      
                                      matchOverlayColor: 
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchOverlayColor) 
                                        && (Ev4rs.compareObjFields(root.boards, (b) => b.overlayColor)))
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolContrast:
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolContrast)
                                        && Ev4rs.compareObjFields(root.boards, (b) => b.symbolContrast)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolInvert:  
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchInvertSymbol)
                                        && Ev4rs.compareObjFields(root.boards, (b) => b.invertSymbol)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolSaturation: 
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolSaturation)
                                        && Ev4rs.compareObjFields(root.boards, (b) => b.symbolSaturation)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.multiPickImage(root, _picker);
                                              if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                              await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.multiPickImage(root, _picker);
                                          if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                            await Ev4rs.cleanupUnusedImages(everyImage);
                                          } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                          (Ev4rs.compareObjFields(root.boards, (b) => b.padding)) 
                        ? Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,)
                        : Text('Image Padding: --Not All Match--', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    specialLabel: 
                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolContrast) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.symbolContrast)
                      && Ev4rs.compareObjFields(root.boards, (b) => b.matchInvertSymbol) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.invertSymbol)
                      && Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolSaturation) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.symbolSaturation)
                      && Ev4rs.compareObjFields(root.boards, (b) => b.matchOverlayColor) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.overlayColor)
                      ) 
                      ? false 
                      : true,
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'overlayColor', Ev4rs.overlay.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'symbolSaturation', Ev4rs.saturation.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'symbolContrast', Ev4rs.contrast.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    
                    matchContrast: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolContrast) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.symbolContrast)) 
                    ? Ev4rs.matchContrast.value
                    : true,
                    matchInvert: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchInvertSymbol) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.invertSymbol)) 
                    ? Ev4rs.matchInvert.value
                    : true,
                    matchOverlay: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchOverlayColor) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.overlayColor)) 
                    ? Ev4rs.matchOverlay.value
                    : true,
                    matchSaturation: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolSaturation) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.symbolSaturation)) 
                    ? Ev4rs.matchSaturation.value
                    : true,
                    
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                
                ]
                ),
              );
              }
            ),
              
              //
              //label, message, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label and message
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              TextField(
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: (Ev4rs.compareObjFields(root.boards, (b) => (b).label)) ? '${obj_.label}' : '--Not All Match--',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'label', Ev4rs.label);
                                if (Ev4rs.matchLabel){
                                  Ev4rs.label = '${Ev4rs.label.trim()} ';
                                  Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'message', Ev4rs.label);
                                }
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                        Row(children: [ 
                        Expanded(
                          flex: 5,
                          child: 
                        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                          TextField(
                            style: Ev4rs.labelStyle,
                            onChanged: (value){
                              Ev4rs.message = value;
                            },
                            decoration: InputDecoration(
                            hintStyle: Ev4rs.hintLabelStyle,
                            hintText: (Ev4rs.compareObjFields(root.boards, (b) => (b).message)) ? '${obj_.message}' : '--Not All Match--',
                            ),
                          ),
                        ),
                        ),
                        Flexible(
                          flex: 2,
                          child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                        ButtonStyle4(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                              Ev4rs.message = '${Ev4rs.message.trim()} ';
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'message', Ev4rs.message);
                              if (Ev4rs.matchLabel){
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'label', Ev4rs.message.trim());
                              }
                              Ev4rs.saveJson(root);
                          }, 
                          label: 'Save'
                          ),
                          ),
                        ),
                      ]
                      ),
                        Row(children: [
                          Expanded(child: 
                            Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Text(
                                'Match Label & Message', 
                                style: Sv4rs.settingslabelStyle
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), child: 
                            Switch(
                              padding: EdgeInsets.all(0),
                              value: Ev4rs.matchLabel, 
                              onChanged: (value) {
                                Ev4rs.matchLabel = value;
                              }
                            ),
                          ),
                        ]
                        ),
                      
                    ]
                      
                    ))),
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text( (Ev4rs.compareObjFields(root.boards, (b) => b.matchSpeakOS)) ?
                                  'Match Speak on Select:' : 'Match Speak on Select: --Not All Match--', 
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                if (!Ev4rs.compareObjFields(root.boards, (b) => b.matchSpeakOS)) 
                                  Text('Speak on Select: --Not All Match--', style: Sv4rs.settingslabelStyle),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 
                                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchSpeakOS)) 
                                    ? 'Speak on Select: ${Ev4rs.speakOnSelect.value}'
                                    : 'Speak on Select: --Not All Match--',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Message", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){
                                    if (Ev4rs.rootReady) {
                                      Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                    }
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchFont', Ev4rs.matchFont.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'fontSize', Ev4rs.fontSize.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'fontItalics', Ev4rs.fontItalics.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'fontUnderline', Ev4rs.fontUnderline.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'fontWeight', Ev4rs.fontWeight.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'fontFamily', Ev4rs.fontFamily.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save Button Font'
                            ),
                            specialLabel: 
                              (Ev4rs.compareObjFields(root.boards, (b) => b.matchFont) 
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontSize)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontItalics)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontUnderline)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontWeight)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontFamily)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontColor)) 
                              ? false 
                              : true,
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              //show, format, border, background
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //show button
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container( 
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.show, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(
                                child: Text(
                                  (Ev4rs.compareObjFields(root.boards, (b) => b.show)) 
                                    ? 'Show Button:'
                                    : 'Show Button: --Not All Match--', 
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.show.value, 
                                  onChanged: (value) {
                                    Ev4rs.show.value = value;
                                  }
                                ),
                              ),
                              ]
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'show', Ev4rs.show.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), 
                                    child: Text(
                                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchFormat)) 
                                        ? 'Match Format:'
                                        : 'Match Format: --Not All Match--',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${ Ev4rs.compareObjFields(root.boards, (b) => b.format) 
                                          ? (Ev4rs.format.value == 1 ? 
                                              'Text Below' 
                                            : Ev4rs.format.value == 2 ? 
                                              'Text Above' 
                                            : Ev4rs.format.value == 3 ? 
                                              'Image Only' 
                                            : Ev4rs.format.value == 4 ? 
                                              'Text Only' 
                                            : '') 
                                          : '--Not All Match--'
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchFormat', Ev4rs.matchFormat.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //
                  //border
                  //

                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBorder, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 3, 20), 
                                    child: Text(
                                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchBorder)) 
                                        ? 'Match Border: '
                                        : 'Match Border: --Not All Match--', 
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBorder.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchBorder.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border weight 
                        ValueListenableBuilder<double>(
                          valueListenable: Ev4rs.borderWeight, 
                          builder: (context, borderWeight, _) {
                            return Column(children: [
                            Text(
                              (Ev4rs.compareObjFields(root.boards, (b) => b.borderWeight)) 
                              ? 'Border Weight: ${Ev4rs.borderWeight.value}'
                              : 'Border Weight: --Not All Match--',
                              style: Sv4rs.settingslabelStyle),
                            Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 20,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 
                                    (Ev4rs.compareObjFields(root.boards, (b) => b.borderWeight)) 
                                      ? 'Border Weight: ${Ev4rs.borderWeight}'
                                      : 'Border Weight: --Not All Match--',
                                  value: Ev4rs.borderWeight.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.borderWeight.value = value;
                                    }
                            )
                            ]
                                  );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.borderColor, 
                          builder: (context, borderColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                  Text(
                                    (Ev4rs.compareObjFields(root.boards, (b) => b.borderColor)) 
                                      ? 'Border Color: '
                                      : 'Border Weight: --Not All Match--', 
                                    style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.borderColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),
                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.borderColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.borderColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.borderColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.borderColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'borderWeight', Ev4rs.borderWeight.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchBorder', Ev4rs.matchBorder.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'borderColor', Ev4rs.borderColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //background
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBackground, 
                          builder: (context, matchBackground, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                    child: Text(
                                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchPOS)) 
                                        ? 'Background Color:'
                                        : 'Background Color: --Not All Match--',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBackground.value,
                                  onChanged: (value) {
                                    Ev4rs.matchBackground.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text((Ev4rs.compareObjFields(root.boards, (b) => b.backgroundColor)) 
                                  ? 'Background Color: '
                                  : 'Background Color: --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),
                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'matchPOS', Ev4rs.matchBackground.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              //pos, button type -> link, return after select, grammer func, mp3
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //part of speech
                  
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: SizedBox( child:
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.pos, 
                          builder: (context, pos, _) {
                            return 
                          Column(children: [
                            SizedBox(child:
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text((Ev4rs.compareObjFields(root.boards, (b) => b.pos)) 
                                  ? 'Part of Speech:'
                                  : 'Part of Speech: --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: SizedBox(child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),),
                              value: Ev4rs.pos.value.toLowerCase(),
                              items: Gv4rs.partOfSpeechList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(child: Text(
                                    item,
                                    style: Sv4rs.settingslabelStyle,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                  Ev4rs.pos.value = value;
                                }
                                }
                            ),
                            ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'pos', Ev4rs.pos.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                    ),
                  ),
                  //type 
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.buttonType, 
                          builder: (context, buttonType, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text((Ev4rs.compareObjFields(root.boards, (b) => b.type)) 
                                  ? 'Button Type: '
                                  : 'Button Type: --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<int>(
                              isExpanded: true,
                                hint: Text(
                                  'button type', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.buttonType.value,
                                items: V4rs.buttonTypeMap.entries.map((entry) {
                                  return DropdownMenuItem<int>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.buttonType.value = value;
                                  }
                                },
                              ),
                            ),
                  
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'type', Ev4rs.buttonType.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                  
                  ),
                  ),

                  //if pocket folder or folder
                  if (Ev4rs.buttonType.value == 3 || Ev4rs.buttonType.value == 2)
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                (Ev4rs.compareObjFields(root.boards, (b) => b.linkToUUID)) 
                                  ? 'Link To...'
                                  : 'Link To... --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'link to...', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                    Ev4rs.linkLabel.value = mapOfBoards.entries.firstWhere((element) => element.value == value).key;
                                  }
                                },
                              ),
                          ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){
                                if (Ev4rs.rootReady) {
                                  Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'linkToUUID', Ev4rs.link.value);
                                  Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'linkToLabel', Ev4rs.linkLabel.value);
                                  Ev4rs.saveJson(root);
                                }
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  if (Ev4rs.buttonType.value == 3 || Ev4rs.buttonType.value == 2)
                  Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: Ev4rs.returnAfterSelect, 
                        builder: (context, returnAfterSelect, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                  child: Text(
                                    (Ev4rs.compareObjFields(root.boards, (b) => b.returnAfterSelect)) 
                                  ? 'Return After Select:'
                                  : 'Return After Select: --Not All Match--',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Sv4rs.settingslabelStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ),
                            Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                              child: Switch(
                                padding: EdgeInsets.all(0),
                                value: Ev4rs.returnAfterSelect.value,
                                onChanged: (value) {
                                  Ev4rs.returnAfterSelect.value = value;
                                }
                              ),
                            ),
                          ]
                          );
                        }
                      ),
                      ButtonStyle2(
                            imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              if (Ev4rs.rootReady) {
                                Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'returnAfterSelect', Ev4rs.returnAfterSelect.value);
                                Ev4rs.saveJson(root);
                              }
                            }, 
                            label: 'Save'
                          ),
                        
                        ]
                        ),
                    ),
                    ),

                  //if grammer
                  if (Ev4rs.buttonType.value == 6)
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.grammerFunction, 
                          builder: (context, grammerFunction, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                (Ev4rs.compareObjFields(root.boards, (b) => b.function)) 
                                  ? 'Grammer Function:'
                                  : 'Grammer Function: --Not All Match--',
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                          Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  'grammer function', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.grammerFunction.value,
                                items: Gv4rs.grammerFunctionMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.grammerFunction.value = value;
                                  }
                                },
                              ),
                          ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'function', Ev4rs.grammerFunction.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                  ),
                  
                  //if audio tile
                  if (Ev4rs.buttonType.value == 4)
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child:
                    Container(
                        padding: EdgeInsetsGeometry.all(10),
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                        child: Column(children: [
                          if (Ev4rs.compareObjFields(root.boards, (b) => b.audioClip))
                          Text('--Not All Match--', style: Sv4rs.settingslabelStyle),

                          SizedBox( child: 
                          ButtonStyle2(
                            imagePath: 'assets/interface_icons/interface_icons/iPlay.png', 
                            onPressed: () async {
                              await LoadAudio.fromAudio(obj_.audioClip);
                            },
                            label: 'Play'
                          ),
                          ),
                          SizedBox( child: 
                          ButtonStyle3(
                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                            onPressed: () async {
                              Ev4rs.multiPickMP3(root);
                              if (Ev4rs.rootReady && everyMp3.isNotEmpty) {
                              await Ev4rs.cleanupUnusedmp3(everyMp3);
                                } 
                            }, 
                            label: 'upload mp3'
                            )
                          ),
                        ]
                      )
                    ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              TextField(
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: (Ev4rs.compareObjFields(root.boards, (b) => b.note)) 
                                  ? 'Notes... ${Ev4rs.notes.value}'
                                  : 'Notes... --Not All Match--',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateMultiBoardField(root, Ev4rs.selectedUUIDs.value, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    ))),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //undo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child: ValueListenableBuilder<bool>(
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
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04,
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
              Expanded(flex: 2, child: 
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
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
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
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
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
                  onPressed: ()  {
                    setState(() {
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
                  onPressed: () { 
                    setState(() {
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
                  onPressed: () { 
                    setState(() {
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
                onPressed: () { setState(() {
                  Ev4rs.invertSelectionAction(root);
                });
                }
              );
                    }
                    ),

            //sort a-z
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.sortSelectAZ, 
                    builder: (context, sorting, _) {
              return ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iSortAZ.png', 
                onPressed: () { setState(() {
                  Ev4rs.sortSelectedAzAction(root);
                });
                }
              );
                    })

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
    }

  //===: sub folder editor
  
    class SubFolderEditor extends StatefulWidget{
      final BoardObjects obj;
      const SubFolderEditor({
        super.key,
        required this.obj,
      });

      @override
      State<SubFolderEditor> createState() => _SubFolderEditorState();
    }

    class _SubFolderEditorState extends State<SubFolderEditor>{
      late Future<Root> rootFuture;
      final ImagePicker _picker = ImagePicker();
      late Root root;
      var everyImage = <String>[];

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

      @override
      Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        return Stack( children: [
          ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
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
              
            everyImage = Ev4rs.getAllImages(root);
          

            final obj_ = Ev4rs.findBoardById(root.boards, Ev4rs.subFolderSelectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setSubFolderPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol(obj_.symbol);

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
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: ImageStyle1(
                                      image: image, 
                                      symbolSaturation: Ev4rs.saturation.value, 
                                      symbolContrast: Ev4rs.contrast.value, 
                                      invertSymbolColors: Ev4rs.invert.value, 
                                      overlayColor: Ev4rs.overlay.value, 
                                      matchOverlayColor: Ev4rs.matchOverlay.value, 
                                      matchSymbolContrast: Ev4rs.matchContrast.value, 
                                      matchSymbolInvert: Ev4rs.matchInvert.value, 
                                      matchSymbolSaturation: Ev4rs.matchSaturation.value,
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.pickImage(root, _picker);
                                              if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                              await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.pickImage(root, _picker);
                                          if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                            await Ev4rs.cleanupUnusedImages(everyImage);
                                          } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                        Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.selectedUUID, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'overlayColor', Ev4rs.overlay.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'symbolSaturation', Ev4rs.saturation.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'symbolContrast', Ev4rs.contrast.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    matchContrast: Ev4rs.matchContrast.value,
                    matchInvert: Ev4rs.matchInvert.value,
                    matchOverlay: Ev4rs.matchOverlay.value,
                    matchSaturation: Ev4rs.matchSaturation.value,
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                  

                ]
                ),
              );
              }
            ),
              
              //
              //label, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              TextField(
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: '${obj_.label}',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'label', Ev4rs.label);
                              Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                         Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              TextField(
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.alternateLabel = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: '${obj_.alternateLabel}',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'alternateLabel', Ev4rs.alternateLabel);
                              Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                   
                    ]
                    ))),
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text(
                                  'Match Speak on Select:', 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 'Speak on Select: ${Ev4rs.speakOnSelect.value}',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Alternate Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){
                                    if (Ev4rs.rootReady) {
                                      Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                    }
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                                Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchFont', Ev4rs.matchFont.value);
                                Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'fontSize', Ev4rs.fontSize.value);
                                Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'fontItalics', Ev4rs.fontItalics.value);
                                Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'fontUnderline', Ev4rs.fontUnderline.value);
                                Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'fontWeight', Ev4rs.fontWeight.value);
                                Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'fontFamily', Ev4rs.fontFamily.value);
                                Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save Button Font'
                            ),
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              //show, format, border, background
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //show button
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container( 
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.show, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(
                                child: Text(
                                  'Show Button:', 
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.show.value, 
                                  onChanged: (value) {
                                    Ev4rs.show.value = value;
                                  }
                                ),
                              ),
                              ]
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'show', Ev4rs.show.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 0), 
                                    child: Text(
                                      'Match Format:', 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${
                                          Ev4rs.format.value == 1 ? 
                                            'Text Right' 
                                          : Ev4rs.format.value == 2 ? 
                                            'Text Left' 
                                          : Ev4rs.format.value == 3 ? 
                                            'Image Only' 
                                          : Ev4rs.format.value == 4 ? 
                                            'Text Only' 
                                          : ''
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchFormat', Ev4rs.matchFormat.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //
                  //border
                  //

                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBorder, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 20), 
                                    child: Text(
                                      'Match Border:', 
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBorder.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchBorder.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border weight 
                        ValueListenableBuilder<double>(
                          valueListenable: Ev4rs.borderWeight, 
                          builder: (context, borderWeight, _) {
                            return Column (children: [
                            Text('Border Weight: ${Ev4rs.borderWeight.value}', style: Sv4rs.settingslabelStyle),
                            Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 20,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 'Border Weight: ${Ev4rs.borderWeight.value}',
                                  value: Ev4rs.borderWeight.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.borderWeight.value = value;
                                    }
                            )
                            ]
                                  );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.borderColor, 
                          builder: (context, borderColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text('Border Color:', style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.borderColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),
                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.borderColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.borderColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.borderColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.borderColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'borderWeight', Ev4rs.borderWeight.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchBorder', Ev4rs.matchBorder.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'borderColor', Ev4rs.borderColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //background
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBackground, 
                          builder: (context, matchBackground, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                    child: Text(
                                      'Match Color:', 
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBackground.value,
                                  onChanged: (value) {
                                    Ev4rs.matchBackground.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text('Button Color:', style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),

                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'matchPOS', Ev4rs.matchBackground.value);
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              //pos, button type -> link, return after select, grammer func, mp3
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //part of speech
                  
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: SizedBox( child:
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.pos, 
                          builder: (context, pos, _) {
                            return 
                          Column(children: [
                            SizedBox(child:
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: SizedBox(child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),),
                              value: Ev4rs.pos.value.toLowerCase(),
                              items: Gv4rs.partOfSpeechList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(child: Text(
                                    item,
                                    style: Sv4rs.settingslabelStyle,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                  Ev4rs.pos.value = value;
                                }
                                }
                            ),
                            ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'pos', Ev4rs.pos.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                    ),
                  ),
                  //type 
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.subFolderType, 
                          builder: (context, buttonType, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Type:', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'type', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.subFolderType.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'subFolderButton',
                                    child: Text(
                                      'sub folder', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'backButton',
                                    child: Text(
                                      'back button', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.subFolderType.value = value;
                                  }
                                },
                              ),
                            ),
                  
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'type1', Ev4rs.subFolderType.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                  
                  ),
                  ),

                  if (Ev4rs.subFolderType.value == 'subFolderButton')
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text(
                                'Link To...', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text(
                                  'link to...', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                    Ev4rs.linkLabel.value = mapOfBoards.entries.firstWhere((element) => element.value == value).key;
                                  }
                                },
                              ),
                            ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){
                                if (Ev4rs.rootReady) {
                                  Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'linkToUUID', Ev4rs.link.value);
                                  Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'linkToLabel', Ev4rs.linkLabel.value);
                                  Ev4rs.saveJson(root);
                                }
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              TextField(
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: 'Notes... ${Ev4rs.notes.value}',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    ))),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
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
              Expanded(flex: 2, child: 
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
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
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
    }

    class MultiSubFolderEditor extends StatefulWidget{
          final BoardObjects obj;
          const MultiSubFolderEditor({
            super.key,
            required this.obj,
          });

          @override
          State<MultiSubFolderEditor> createState() => _MultiSubFolderEditor();
        }

    class _MultiSubFolderEditor extends State<MultiSubFolderEditor>{
      late Future<Root> rootFuture;
      final ImagePicker _picker = ImagePicker();
      late Root root;
      var everyImage = <String>[];

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

      @override
      Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;

        return Stack( children: [
          ValueListenableBuilder<bool>(valueListenable: Ev4rs.reloadJson, builder: (context, reload, _) {
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
              
            everyImage = Ev4rs.getAllImages(root);
          

            final obj_ = Ev4rs.findBoardById(root.boards, Ev4rs.subFolderSelectedUUID);
            if (obj_ == null) {
              return const Center(child: Text("Object not found"));
            }

            Ev4rs.setPlacholderValues(obj_);
            
            var allBoards = Ev4rs.getBoards(root.boards);

            final mapOfBoards = {
              for (var board in allBoards) 
                if (board.title != null) 
                  board.title!: board.id,
            };

            Widget image = LoadImage.fromSymbol('assets/interface_icons/interface_icons/iPlaceholder.png');
            Widget image2 = LoadImage.fromSymbol(obj_.symbol);

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
              //Image, image padding, image overlay settings
              //
              ValueListenableBuilder(
                valueListenable: CombinedValueNotifier(
                    Ev4rs.padding, Ev4rs.overlay, Ev4rs.contrast, 
                    Ev4rs.invert, Ev4rs.saturation, Ev4rs.matchContrast, 
                    Ev4rs.matchInvert, Ev4rs.matchOverlay, Ev4rs.matchSaturation
                  ), 
                builder: (context, values, _) {
              return Expanded(flex: 8, child: 
                Column( children:[
                  //
                  //image
                  //
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                          Container(
                            width: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Cv4rs.themeColor4,
                              borderRadius: BorderRadius.circular(10)
                              ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(child: Padding(padding: EdgeInsetsGeometry.all(Ev4rs.padding.value), 
                                  child: (!Ev4rs.compareObjFields(root.boards, (b) => b.symbol)) ?
                                  Column(children: [
                                    Text('--Not All Match--', style: Sv4rs.settingslabelStyle),
                                    ImageStyle1(
                                        image: image, 
                                        symbolSaturation: Bv4rs.buttonSymbolSaturation, 
                                        symbolContrast: Bv4rs.buttonSymbolContrast, 
                                        invertSymbolColors: Bv4rs.buttonSymbolInvert, 
                                        overlayColor: Bv4rs.buttonSymbolColorOverlay, 
                                        matchOverlayColor: true, 
                                        matchSymbolContrast: true, 
                                        matchSymbolInvert: true, 
                                        matchSymbolSaturation: true,
                                        defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                        defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                        defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                        defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      ) 
                                    ]
                                    )
                                  : ImageStyle1(
                                      image: image2, 
                                      symbolSaturation: obj_.symbolSaturation ?? 1.0, 
                                      symbolContrast: obj_.symbolContrast ?? 1.0, 
                                      invertSymbolColors: obj_.invertSymbol ?? false, 
                                      overlayColor: obj_.overlayColor ?? Colors.white,
                                      
                                      matchOverlayColor: 
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchOverlayColor) 
                                        && (Ev4rs.compareObjFields(root.boards, (b) => b.overlayColor)))
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolContrast:
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolContrast)
                                        && Ev4rs.compareObjFields(root.boards, (b) => b.symbolContrast)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolInvert:  
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchInvertSymbol)
                                        && Ev4rs.compareObjFields(root.boards, (b) => b.invertSymbol)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      matchSymbolSaturation: 
                                        (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolSaturation)
                                        && Ev4rs.compareObjFields(root.boards, (b) => b.symbolSaturation)) 
                                        ? Ev4rs.matchOverlay.value
                                        : true, 
                                      
                                      defaultSymbolColorOverlay: Bv4rs.buttonSymbolColorOverlay, 
                                      defaultSymbolInvert: Bv4rs.buttonSymbolInvert, 
                                      defaultSymbolContrast: Bv4rs.buttonSymbolContrast, 
                                      defaultSymbolSaturation: Bv4rs.buttonSymbolSaturation
                                      )
                                  ),
                                ),
                                Flexible(child: 
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                        SizedBox( 
                                          width: MediaQuery.of(context).size.height * 0.08,
                                          child: ButtonStyle3(
                                            imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                            onPressed: () async {
                                              Ev4rs.multiPickImage(root, _picker);
                                              if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                              await Ev4rs.cleanupUnusedImages(everyImage);
                                              } 
                                            }, 
                                            label: 'Photo Lib'
                                          ),
                                        ),
                                      ),
                                  Visibility(
                                    visible: false,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child:
                                    SizedBox( 
                                      width: MediaQuery.of(context).size.height * 0.07,
                                      child: ButtonStyle3(
                                      imagePath: 'assets/interface_icons/interface_icons/iPlaceholder.png', 
                                      onPressed: () async {
                                        Ev4rs.multiPickImage(root, _picker);
                                          if (Ev4rs.rootReady && everyImage.isNotEmpty) {
                                            await Ev4rs.cleanupUnusedImages(everyImage);
                                          } 
                                      }, 
                                      label: 'App Lib'
                                      )
                                    ),
                                  ),
                                  ),
                              ]
                              )
                              ),
                            ]),
                          ),
                  ),

                  //
                  //padding
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox( 
                    width: MediaQuery.of(context).size.height * 0.25,
                    child: 
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(padding: EdgeInsets.all(10), child: 
                        Column(children: [
                          (Ev4rs.compareObjFields(root.boards, (b) => b.padding)) 
                        ? Text('Image Padding: ${Ev4rs.padding.value}', style: Sv4rs.settingslabelStyle,)
                        : Text('Image Padding: --Not All Match--', style: Sv4rs.settingslabelStyle,),
                        Slider(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              value: Ev4rs.padding.value,
                              min: 0.0,
                              max: 10.0,
                              divisions: 11,
                              activeColor: Cv4rs.themeColor1,
                              inactiveColor: Cv4rs.themeColor3,
                              thumbColor: Cv4rs.themeColor1,
                              label: 'Image Padding: ${Ev4rs.padding.value}',
                              onChanged: (value) {
                                Ev4rs.padding.value = value.roundToDouble();
                              }
                          ),
                        ])
                        ),
                        ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'padding', Ev4rs.padding.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save Padding'
                          ),
                        ]),
                    ),
                  ),
                  ),

                  //
                  //symbolColors
                  //
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                  SizedBox(
                    child:
                  SymbolColorCustomizer2(
                    specialLabel: 
                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolContrast) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.symbolContrast)
                      && Ev4rs.compareObjFields(root.boards, (b) => b.matchInvertSymbol) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.invertSymbol)
                      && Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolSaturation) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.symbolSaturation)
                      && Ev4rs.compareObjFields(root.boards, (b) => b.matchOverlayColor) 
                      && Ev4rs.compareObjFields(root.boards, (b) => b.overlayColor)
                      ) 
                      ? false 
                      : true,
                    widgety: 
                    ButtonStyle2(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchOverlayColor', Ev4rs.matchOverlay.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'overlayColor', Ev4rs.overlay.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchSymbolSaturation', Ev4rs.matchSaturation.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'symbolSaturation', Ev4rs.saturation.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchSymbolContrast', Ev4rs.matchContrast.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'symbolContrast', Ev4rs.contrast.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchInvertSymbol', Ev4rs.matchInvert.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'invertSymbol', Ev4rs.invert.value);
                              
                              Ev4rs.saveJson(root);
                          }, 
                          label: 'Save Adjustments'
                          ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    additionalHeight: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.height * 0.25,
                    invert: Ev4rs.invert.value, 
                    overlay: Ev4rs.overlay.value,
                    saturation: Ev4rs.saturation.value, 
                    contrast: Ev4rs.contrast.value, 
                    
                    matchContrast: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolContrast) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.symbolContrast)) 
                    ? Ev4rs.matchContrast.value
                    : true,
                    matchInvert: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchInvertSymbol) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.invertSymbol)) 
                    ? Ev4rs.matchInvert.value
                    : true,
                    matchOverlay: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchOverlayColor) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.overlayColor)) 
                    ? Ev4rs.matchOverlay.value
                    : true,
                    matchSaturation: 
                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchSymbolSaturation) 
                    && Ev4rs.compareObjFields(root.boards, (b) => b.symbolSaturation)) 
                    ? Ev4rs.matchSaturation.value
                    : true,
                    
                    onContrastChanged: (value){
                      Ev4rs.contrast.value = value;
                    }, 
                    onInvertChanged: (value){
                      Ev4rs.invert.value = value;
                    },
                    onOverlayChanged: (value){
                      Ev4rs.overlay.value = value;
                    },
                    onSaturationChanged: (value){
                      Ev4rs.saturation.value = value;
                    },
                    onMatchContrastChanged: (value){
                      Ev4rs.matchContrast.value = value;
                    }, 
                    onMatchInvertChanged: (value){
                      Ev4rs.matchInvert.value = value;
                    },
                    onMatchOverlayChanged: (value){
                      Ev4rs.matchOverlay.value = value;
                    },
                    onMatchSaturationChanged: (value){
                      Ev4rs.matchSaturation.value = value;
                    },
                    )
                  )
                  ),
                
                ]
                ),
              );
              }
            ),
              
              //
              //label, message, speak on select, font
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //label and message
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                              TextField(
                                style: Ev4rs.labelStyle,
                                onChanged: (value){
                                  Ev4rs.label = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Ev4rs.hintLabelStyle,
                                hintText: (Ev4rs.compareObjFields(root.boards, (b) => (b).label)) ? '${obj_.label}' : '--Not All Match--',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'label', Ev4rs.label);
                                
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                        Row(children: [ 
                        Expanded(
                          flex: 5,
                          child: 
                        Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 0), child: 
                          TextField(
                            style: Ev4rs.labelStyle,
                            onChanged: (value){
                              Ev4rs.alternateLabel = value;
                            },
                            decoration: InputDecoration(
                            hintStyle: Ev4rs.hintLabelStyle,
                            hintText: (Ev4rs.compareObjFields(root.boards, (b) => (b).alternateLabel)) ? '${obj_.alternateLabel}' : '--Not All Match--',
                            ),
                          ),
                        ),
                        ),
                        Flexible(
                          flex: 2,
                          child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                        ButtonStyle4(
                        imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                              Ev4rs.message = '${Ev4rs.message.trim()} ';
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'alternateLabel', Ev4rs.alternateLabel);
                              
                              Ev4rs.saveJson(root);
                          }, 
                          label: 'Save'
                          ),
                          ),
                        ),
                      ]
                      ),
                       
                    ]
                      
                    ))),
                  //match speak on select, speak on select
                  Padding(padding: EdgeInsetsGeometry.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchSpeakOnSelect, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(child: 
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(10, 10, 10, 0), 
                                child: Text( (Ev4rs.compareObjFields(root.boards, (b) => b.matchSpeakOS)) ?
                                  'Match Speak on Select:' : 'Match Speak on Select: --Not All Match--', 
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchSpeakOnSelect.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchSpeakOnSelect.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.speakOnSelect, 
                          builder: (context, speakOnSelect, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.all(10), 
                              child: Column(children: [
                                if (!Ev4rs.compareObjFields(root.boards, (b) => b.matchSpeakOS)) 
                                  Text('Speak on Select: --Not All Match--', style: Sv4rs.settingslabelStyle),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 1.0,
                                  max: 3.0,
                                  divisions: 2,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 
                                    (Ev4rs.compareObjFields(root.boards, (b) => b.matchSpeakOS)) 
                                    ? 'Speak on Select: ${Ev4rs.speakOnSelect.value}'
                                    : 'Speak on Select: --Not All Match--',
                                  value: Ev4rs.speakOnSelect.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.speakOnSelect.value = value.toInt();
                                    }
                                  ),
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 10), 
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                    Expanded(child: 
                                      Text(
                                        "Off", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(child: 
                                      Text(
                                        "Speak Alternate Label", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ]
                                  ), 
                                ),
                                ButtonStyle2(
                                  imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                                  onPressed: (){
                                    if (Ev4rs.rootReady) {
                                      Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchSpeakOS', Ev4rs.matchSpeakOnSelect.value);
                                      Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'speakOS', Ev4rs.speakOnSelect.value);
                                      Ev4rs.saveJson(root);
                                    }
                                  }, 
                                  label: 'Save'
                                ),
                              ]
                            ),
                            );
                          }
                        ),
                        
                      ]
                    )
                    )
                  ),
                  //font, match font settings, font picker
                  Padding(
                      padding: EdgeInsetsGeometry.all(10), 
                      child: FontPicker2(
                        widgety:  ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                                Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchFont', Ev4rs.matchFont.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'fontSize', Ev4rs.fontSize.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'fontItalics', Ev4rs.fontItalics.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'fontUnderline', Ev4rs.fontUnderline.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'fontWeight', Ev4rs.fontWeight.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'fontFamily', Ev4rs.fontFamily.value);
                                Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'fontColor', Ev4rs.fontColor.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save Button Font'
                            ),
                            specialLabel: 
                              (Ev4rs.compareObjFields(root.boards, (b) => b.matchFont) 
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontSize)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontItalics)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontUnderline)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontWeight)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontFamily)
                              || Ev4rs.compareObjFields(root.boards, (b) => b.fontColor)) 
                              ? false 
                              : true,
                            matchFontSet: Ev4rs.matchFont.value,
                            height: MediaQuery.of(context).size.height * 0.3,
                            size: Ev4rs.fontSize.value, 
                            sizeMax: 25,
                            sizeMin: 5,
                            divisions: 20,
                            weight: (Ev4rs.fontWeight.value).toInt(), 
                            italics: Ev4rs.fontItalics.value, 
                            font: Ev4rs.fontFamily.value, 
                            label: 'Button Font:', 
                            color: Ev4rs.fontColor.value, 
                            underline: Ev4rs.fontUnderline.value,
                            onSizeChanged: (value) {
                              Ev4rs.fontSize.value = value;
                              }, 
                            onWeightChanged: (value) {
                              Ev4rs.fontWeight.value = value.toDouble();
                              },
                            onItalicsChanged: (value) {
                              Ev4rs.fontItalics.value = value;
                              },
                            onFontChanged: (value) {
                              Ev4rs.fontFamily.value = value;
                              },
                            onColorChanged: (value) {
                              Ev4rs.fontColor.value = value.toColor() ?? Cv4rs.themeColor1;
                              },
                            onMatchFont: (value) {
                              Ev4rs.matchFont.value = value;
                              },
                            useUnderline: true, 
                            onUnderlineChanged: (value) {
                              Ev4rs.fontUnderline.value = value;
                              }, 
                            )
                          ),
                ]
              ),
              ),
              
              //
              //show, format, border, background
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  
                  //
                  //show button
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container( 
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.show, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(children: [
                              Expanded(
                                child: Text(
                                  (Ev4rs.compareObjFields(root.boards, (b) => b.show)) 
                                    ? 'Show Button:'
                                    : 'Show Button: --Not All Match--', 
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: Sv4rs.settingslabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.show.value, 
                                  onChanged: (value) {
                                    Ev4rs.show.value = value;
                                  }
                                ),
                              ),
                              ]
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'show', Ev4rs.show.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                  
                  //
                  //format
                  //

                  Padding(
                    padding: EdgeInsetsGeometry.all(10), 
                    child: Container(
                      padding: EdgeInsetsGeometry.all(10),
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchFormat, 
                          builder: (context, matchFormat, _) {
                            return Row(children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 0, 0), 
                                    child: Text(
                                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchFormat)) 
                                        ? 'Match Format:'
                                        : 'Match Format: --Not All Match--',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchFormat.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchFormat.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),
                        ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.format, 
                          builder: (context, format, _) {
                            return Padding(
                              padding: EdgeInsetsGeometry.fromLTRB(5, 15, 5, 10), 
                              child: Column(children: [
                                      Text(
                                        "Format: ${ Ev4rs.compareObjFields(root.boards, (b) => b.format) 
                                          ? (Ev4rs.format.value == 1 ? 
                                              'Text Right' 
                                            : Ev4rs.format.value == 2 ? 
                                              'Text Left' 
                                            : Ev4rs.format.value == 3 ? 
                                              'Image Only' 
                                            : Ev4rs.format.value == 4 ? 
                                              'Text Only' 
                                            : '') 
                                          : '--Not All Match--'
                                          }", 
                                        style: Sv4rs.settingslabelStyle,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                Slider(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  min: 1.0,
                                  max: 4.0,
                                  divisions: 3,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  value: Ev4rs.format.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.format.value = value.toInt();
                                    }
                                  ),
                                ]
                            ),
                            );
                          }
                        ),
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchFormat', Ev4rs.matchFormat.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'format', Ev4rs.format.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //
                  //border
                  //

                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [
                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBorder, 
                          builder: (context, matchSpeakOnSelect, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(0, 10, 3, 20), 
                                    child: Text(
                                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchBorder)) 
                                        ? 'Match Border: '
                                        : 'Match Border: --Not All Match--', 
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 0, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBorder.value, 
                                  onChanged: (value) {
                                    Ev4rs.matchBorder.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border weight 
                        ValueListenableBuilder<double>(
                          valueListenable: Ev4rs.borderWeight, 
                          builder: (context, borderWeight, _) {
                            return Column(children: [
                            Text(
                              (Ev4rs.compareObjFields(root.boards, (b) => b.borderWeight)) 
                              ? 'Border Weight: ${Ev4rs.borderWeight.value}'
                              : 'Border Weight: --Not All Match--',
                              style: Sv4rs.settingslabelStyle),
                            Slider(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  min: 0.0,
                                  max: 10.0,
                                  divisions: 20,
                                  activeColor: Cv4rs.themeColor1,
                                  inactiveColor: Cv4rs.themeColor3,
                                  thumbColor: Cv4rs.themeColor1,
                                  label: 
                                    (Ev4rs.compareObjFields(root.boards, (b) => b.borderWeight)) 
                                      ? 'Border Weight: ${Ev4rs.borderWeight}'
                                      : 'Border Weight: --Not All Match--',
                                  value: Ev4rs.borderWeight.value.toDouble(), 
                                  onChanged: (value) {
                                    Ev4rs.borderWeight.value = value;
                                    }
                            )
                            ]
                                  );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.borderColor, 
                          builder: (context, borderColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                  Text(
                                    (Ev4rs.compareObjFields(root.boards, (b) => b.borderColor)) 
                                      ? 'Border Color: '
                                      : 'Border Weight: --Not All Match--', 
                                    style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.borderColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),
                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.borderColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.borderColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.borderColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.borderColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'borderWeight', Ev4rs.borderWeight.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchBorder', Ev4rs.matchBorder.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'borderColor', Ev4rs.borderColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),

                  //background
                  
                  Padding(padding: EdgeInsetsGeometry.all(10), child: //outer padding 
                    Container(
                      padding: EdgeInsetsGeometry.all(10), //inner padding 
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column( children: [

                        //match border 
                        ValueListenableBuilder<bool>(
                          valueListenable: Ev4rs.matchBackground, 
                          builder: (context, matchBackground, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(child: 
                                Padding(
                                  padding: EdgeInsetsGeometry.fromLTRB(5, 10, 5, 10), 
                                    child: Text(
                                      (Ev4rs.compareObjFields(root.boards, (b) => b.matchPOS)) 
                                        ? 'Background Color:'
                                        : 'Background Color: --Not All Match--',
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Sv4rs.settingslabelStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.fromLTRB(0, 0, 10, 0), 
                                child: Switch(
                                  padding: EdgeInsets.all(0),
                                  value: Ev4rs.matchBackground.value,
                                  onChanged: (value) {
                                    Ev4rs.matchBackground.value = value;
                                  }
                                ),
                              ),
                            ]
                            );
                          }
                        ),

                        //border color
                        ValueListenableBuilder<Color>(
                          valueListenable: Ev4rs.backgroundColor, 
                          builder: (context, backgroundColor, _) {
                            return ExpansionTile(
                          tilePadding: EdgeInsets.all(0),
                          title: Row(
                              children: [
                                Expanded(child: 
                                Text((Ev4rs.compareObjFields(root.boards, (b) => b.backgroundColor)) 
                                  ? 'Background Color: '
                                  : 'Background Color: --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,),
                                ),
                                CircleAvatar(
                                  backgroundColor: Cv4rs.themeColor3,
                                  radius: 20,
                                  child: Icon(Icons.circle, color: Ev4rs.backgroundColor.value, size: 40, shadows: [
                                    Shadow(
                                      color: Cv4rs.themeColor4,
                                      blurRadius: 4,
                                    ),
                                  ],),
                                ),
                              ]
                            ),
                          children: [
                            Column(children:[
                            //hexcode input
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
                              child: HexCodeInput2(
                                startValue: Ev4rs.backgroundColor.value.toHexString(),
                                textStyle: Sv4rs.settingslabelStyle,
                                hintTextStyle: TextStyle(color: Cv4rs.themeColor3, fontSize: 16),
                                onColorChanged: (color) { 
                                  Ev4rs.backgroundColor.value = color;
                                },
                              ),
                            ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[ 
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Scroll horizontally here...', 
                                      style: Sv4rs.settingsSecondaryLabelStyle,
                                      ),
                                    SizedBox(height: 30,),
                                  ]
                                ),
                                GestureDetector(
                                  onVerticalDragStart: (_) {},
                                  onVerticalDragUpdate: (_) {},
                                  onVerticalDragEnd: (_) {},
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    child: ColorPicker(
                                      pickerColor: Ev4rs.backgroundColor.value, 
                                      enableAlpha: true,
                                      displayThumbColor: false,
                                      labelTypes: ColorLabelType.values,
                                      onColorChanged: (color) { 
                                        Ev4rs.backgroundColor.value = color;
                                      },
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ] 
                        ),
                      ]
                      );
                          }
                        ),
                        
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'matchPOS', Ev4rs.matchBackground.value);
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'backgroundColor', Ev4rs.backgroundColor.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                      ]
                    )
                    ),
                  ),
                ]
                ),
              ),
              
              //
              //pos, button type -> link, return after select
              //
              Expanded(flex: 7, child: 
                Column( children:[
                  //part of speech
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: SizedBox( child:
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.pos, 
                          builder: (context, pos, _) {
                            return 
                          Column(children: [
                            SizedBox(child:
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text((Ev4rs.compareObjFields(root.boards, (b) => b.pos)) 
                                  ? 'Part of Speech:'
                                  : 'Part of Speech: --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            ),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child:
                            DropdownButton<String>(
                              isExpanded: true,
                              hint: SizedBox(child: Text(
                                'Part of Speech:', 
                                style: Sv4rs.settingslabelStyle,
                                ),),
                              value: Ev4rs.pos.value.toLowerCase(),
                              items: Gv4rs.partOfSpeechList.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(child: Text(
                                    item,
                                    style: Sv4rs.settingslabelStyle,
                                    overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                  Ev4rs.pos.value = value;
                                }
                                }
                            ),
                            ),
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'pos', Ev4rs.pos.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                
                  ),
                    ),
                  ),
                  
                  //type 
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<int>(
                          valueListenable: Ev4rs.buttonType, 
                          builder: (context, buttonType, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child: Text((Ev4rs.compareObjFields(root.boards, (b) => b.type1)) 
                                  ? 'Type: '
                                  : 'Type: --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10), child: 
                            DropdownButton<String>(
                              isExpanded: true,
                                hint: Text((Ev4rs.compareObjFields(root.boards, (b) => b.type1)) 
                                  ? 'Type: '
                                  : 'Type: --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.subFolderType.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: 'subFolderButton',
                                    child: Text(
                                      'sub folder', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: 'backButton',
                                    child: Text(
                                      'back button', 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  ),
                                  ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.subFolderType.value = value;
                                  }
                                },
                              ),
                            ),
                  
                        //save 
                        ButtonStyle2(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                          onPressed: (){
                            if (Ev4rs.rootReady) {
                              Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'type1', Ev4rs.subFolderType.value);
                              Ev4rs.saveJson(root);
                            }
                          }, 
                          label: 'Save'
                        ),
                          ]);
                        }),
                  
                  ),
                  ),

                  if (Ev4rs.subFolderType.value == 'subFolderButton')
                  Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: 
                      Container(
                        decoration: BoxDecoration(
                          color: Cv4rs.themeColor4,
                          borderRadius: BorderRadius.circular(10)
                          ),
                          child:  ValueListenableBuilder<String>(
                          valueListenable: Ev4rs.link, 
                          builder: (context, link, _) {
                            return
                          Column(children: [
                            Padding (
                              padding: EdgeInsetsGeometry.fromLTRB(0,15,0,0),
                              child:  Text(
                                (Ev4rs.compareObjFields(root.boards, (b) => b.linkToUUID)) 
                                  ? 'Link To...'
                                  : 'Link To... --Not All Match--', 
                                style: Sv4rs.settingslabelStyle,
                                ),
                            ),
                            DropdownButton<String>(
                              isExpanded: true,
                                hint:  Text(
                                (Ev4rs.compareObjFields(root.boards, (b) => b.linkToUUID)) 
                                  ? 'Link To...'
                                  : 'Link To... --Not All Match--', 
                                  style: Sv4rs.settingslabelStyle,
                                ),
                                value: Ev4rs.link.value,
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('none', style: Sv4rs.settingslabelStyle),
                                  ),
                                ...mapOfBoards.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(
                                      entry.key, 
                                      style: Sv4rs.settingslabelStyle,
                                    ),
                                  );
                                })
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    Ev4rs.link.value = value;
                                    Ev4rs.linkLabel.value = mapOfBoards.entries.firstWhere((element) => element.value == value).key;
                                  }
                                },
                              ),
                            //save 
                            ButtonStyle2(
                              imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                              onPressed: (){
                                if (Ev4rs.rootReady) {
                                  Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'linkToUUID', Ev4rs.link.value);
                                  Ev4rs.updateBoardField(root, Ev4rs.subFolderSelectedUUID, 'linkToLabel', Ev4rs.linkLabel.value);
                                  Ev4rs.saveJson(root);
                                }
                              }, 
                              label: 'Save'
                            ),
                          ]);
                        }),
                      ),
                    ),

                  //notes
                  Padding(padding: EdgeInsetsGeometry.all(10),
                  child:
                    Container(
                      decoration: BoxDecoration(
                        color: Cv4rs.themeColor4,
                        borderRadius: BorderRadius.circular(10)
                        ),
                      child: Column(children: [
                        Row(children: [ 
                          Expanded(flex: 5, child: 
                            Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 10), child: 
                              TextField(
                                minLines: 1,
                                maxLines: 5,
                                style: Sv4rs.settingslabelStyle,
                                onChanged: (value){
                                  Ev4rs.notes.value = value;
                                },
                                decoration: InputDecoration(
                                hintStyle: Sv4rs.settingslabelStyle,
                                hintText: (Ev4rs.compareObjFields(root.boards, (b) => b.note)) 
                                  ? 'Notes... ${Ev4rs.notes.value}'
                                  : 'Notes... --Not All Match--',
                                ),
                              ),
                            ),
                          ),
                          Flexible(flex: 2, child: 
                          Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 5), child: 
                          ButtonStyle4(
                          imagePath: 'assets/interface_icons/interface_icons/iCheck.png', 
                            onPressed: (){
                              Ev4rs.updateMultiBoardField(root, Ev4rs.subFolderSelectedUUIDs.value, 'note', Ev4rs.notes.value);
                                Ev4rs.saveJson(root);
                            }, 
                            label: 'Save'
                            ),
                          ),
                          ),
                      ],
                      ),
                    ]
                      
                    ))),

                ]
                ),
              ),
              
              //
              //undo + share
              //
              Expanded(flex: 2, child: 
                Column( children:[
                  //undo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
                child: ValueListenableBuilder<bool>(
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
              Expanded(flex: 2, child: 
                Column( children:[
                  //redo
                  Padding(padding: EdgeInsetsGeometry.fromLTRB(3, 7, 3, 0),
              child:
                  SizedBox( 
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
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
                height: (isLandscape) ? MediaQuery.of(context).size.height * 0.06 : MediaQuery.of(context).size.height * 0.04 ,
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
            child:  Padding(padding: EdgeInsetsGeometry.all(7), child:
          Row(
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
                  onPressed: ()  {
                    setState(() {
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
                  onPressed: () { 
                    setState(() {
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
                  onPressed: () { 
                    setState(() {
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
                onPressed: () { setState(() {
                  Ev4rs.invertSelectionAction(root);
                });
                }
              );
                    }
                    ),

            //sort a-z
            if (Ev4rs.isButtonExpanded.value == false 
              && Ev4rs.showSelectionMenu.value == true)
              ValueListenableBuilder<bool>(
                    valueListenable: Ev4rs.sortSelectAZ, 
                    builder: (context, sorting, _) {
              return ButtonStyle1(
                imagePath: 'assets/interface_icons/interface_icons/iSortAZ.png', 
                onPressed: () { setState(() {
                  Ev4rs.sortSelectedAzAction(root);
                });
                }
              );
                    })

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
    }
