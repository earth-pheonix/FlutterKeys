import 'package:flutter/material.dart';
import 'package:flutterkeysaac/Models/json_model_boards.dart';
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart';

class SeV4rs{

  static String searchFor = '';
  static ValueNotifier<bool> openSearch = ValueNotifier(false);
  static ValueNotifier<bool> findAndPick = ValueNotifier(false);
  static BoardObjects? findThis;
  static List<BoardObjects> startBoard = [];
  
  static Map<String, String> findAllUUIDsForWord(List<BoardObjects> boards, String word) {
    Map<String, String> results = {};

    for (final board in boards) {
      void addIfMatches(String? text) {
        if ((text ?? '').toLowerCase().contains(word.toLowerCase()) && (!results.containsValue(board.id))) {
          results[board.id] = (text ?? '');
        }
      }
      addIfMatches(board.label);
      addIfMatches(board.message);
      addIfMatches(board.alternateLabel);

      if (board.content.isNotEmpty) {
        results.addAll(findAllUUIDsForWord(board.content, word));
      }
    }

    return sortBySimilar(results, word);
  }

  static Map<String, String> sortBySimilar(Map<String, String> input, String word) {
    
    int startAndEnd(String a, String b) {
      a = a.toLowerCase();
      b = b.toLowerCase();

      if (a.startsWith(b)) return 1; //check start of word
      if (a.endsWith(b)) return 3; //check end of word
      if (a.contains(b)) return 2; //check middle of word (first 2 ifs rule out start or end)
      return 4; //else
    }
    
    int lengthSimilarity(String a, String b) {
      a = a.toLowerCase();
      b = b.toLowerCase();

      return (a.length - b.length);
    }
    
    var entries = input.entries.toList();

    entries.sort((a, b) {
      int scoreA = lengthSimilarity(a.value, word);
      int scoreB = lengthSimilarity(b.value, word);
      return scoreA.compareTo(scoreB);
    });

     entries.sort((a, b) {
      int scoreA = startAndEnd(a.value, word);
      int scoreB = startAndEnd(b.value, word);
      return scoreA.compareTo(scoreB);
    });

    return Map.fromEntries(entries);
  }

  static Map<String, String> findWord(Root root, String inputUUID, List<BoardObjects> startBoard){

    Map<String, String> path = {};

    var firstObj = Ev4rs.findBoardById(root.boards, inputUUID);

    for (final obj in startBoard){
      //if the object is on the current board, we have the path. 
      if (firstObj == obj){
        path[obj.id] = (obj.label ?? obj.title ?? '');
        return path;
      } 
    }
    
    //if its not there
      //and its not null
      if (firstObj != null){
        //we need to find its parent
        var parent = findParentFromChild(root.boards, firstObj);
        
        //if its parent isn't null then
        if (parent != null) {
          //we check if it is owned by one of the nav buttons
          for (final navBoard in findFirstBoards(root).entries){
            if (parent.id == navBoard.key){
              //if it is we add the button to the path and we have the path
              path[navBoard.key] = navBoard.value;
              return path;
            }
          }
          
          //if not then we need to find who owns the parent
          final owner = findOwnerByLink(root.boards, parent.id);

          if (owner != null) {
            path[owner.id] = (owner.label ?? owner.title ?? '');
            path.addAll(findWord(root, owner.id, startBoard));
          }
        }
    }
    //saftey- for if something falls through
    return path;
  }

  static Map<String, String> findFirstBoards(Root root){
    Map<String, String> startBoards = {};

    for (final row in root.navRow){
      for (final button in row.content) {
        startBoards[button.linkToUUID ?? ''] = (button.label ?? '');
      }
    }

    return startBoards;
  }
  
  static BoardObjects? findParentFromChild(List<BoardObjects> boards, BoardObjects child){
    for (final board in boards){
      for (final obj in board.content) {
        if (obj.id == child.id){
          return board;
        }
      }
    }
    return null;
  }

  static BoardObjects? findOwnerByLink(List<BoardObjects> boards, String childId) {
  for (final board in boards) {
    // If this board links to the child
    if (board.linkToUUID == childId) {
      return board;
    }
    // Search deeper
    final deeper = findOwnerByLink(board.content, childId);
    if (deeper != null) {
      return deeper;
    }
  }
  return null;
}

  static List<BoardObjects?> objectsReturned(Root root, Map<String, String> map){
    List<BoardObjects?> objects = [];
      for (final obj in map.entries){
        objects.add(Ev4rs.findBoardById(root.boards, obj.key));
      }
    return objects;
  }

//for history
  static BoardObjects? findObjfromUUID(String id, List<BoardObjects> boards){
    for (var b in boards) {
      if (b.id == id) return b;
      
      if (b.content.isNotEmpty) {
        if (b.id == id) {
          final BoardObjects? foundInContent = findObjfromUUID(id, b.content);
          if (foundInContent != null) return foundInContent;
        }
      }
    }
    return null;
  }
  
  static Map<String, String> findPath(Root root, String inputUUID){
    Map<String, String> path = {};
    var firstObj = Ev4rs.findBoardById(root.boards, inputUUID);
      if (firstObj != null){
        //we need to find its parent
        var parent = findParentFromChild(root.boards, firstObj);
        
        //if its parent isn't null then
        if (parent != null) {
          //we check if it is owned by one of the nav buttons
          for (final navBoard in findFirstBoards(root).entries){
            if (parent.id == navBoard.key){
              //if it is we add the button to the path and we have the path
              path[navBoard.key] = navBoard.value;
              return path;
            }
          }
          
          //if not then we need to find who owns the parent
          final owner = findOwnerByLink(root.boards, parent.id);

          if (owner != null) {
            path[owner.id] = (owner.label ?? owner.title ?? '');
            path.addAll(findWord(root, owner.id, startBoard));
          }
        }
    }
    //saftey- for if something falls through
    return path;
  }
  
  static String getPath(Map<String, String> map){
    String path = '';
    
    if (map.isEmpty) return path;

    path = map.entries.last.value;

    for (int i=1; i < map.length; i++){
      path = "$path -> ${map.entries.elementAt((map.length-1) - i).value}";
    }

    return path;
  }

}