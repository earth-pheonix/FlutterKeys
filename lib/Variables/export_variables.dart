
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:flutterkeysaac/Variables/variables.dart'; 
import 'package:flutterkeysaac/Variables/editing/editor_variables.dart'; 
import 'package:flutterkeysaac/Models/json_model_nav_and_root.dart';
import 'package:archive/archive_io.dart';
import 'package:archive/archive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ExV4rs {

  static ValueNotifier<bool> loading = ValueNotifier(false);
  static ValueNotifier<bool> loadingPrint = ValueNotifier(false);
  
  static File? fileToExport = V4rs.currentFile;

  static var associatedImages = <String>{};
  static var associatedAssetImages = <String>{};

  static var associatedAudio = <String>{};
  static var associatedAssetAudio = <String>{};

  static Future<void> gatherAssociatedImages(Root root) async {
    associatedImages.clear();

    var everyImage = Ev4rs.getAllImages(root);

    //
    //get a list of image files to export
    //

    //temporary export directory for bundled images
    final tempDir = await getTemporaryDirectory();
    final exportAssetsDir = Directory(p.join(tempDir.path, 'export_assets'));
    
    if (await exportAssetsDir.exists()) {
      await exportAssetsDir.delete(recursive: true);
    }
    await exportAssetsDir.create();

    //regular directory
    final dir = await getApplicationDocumentsDirectory();

    //collecting the paths
    for (final path in everyImage) {
      if (path.startsWith('my_images/')) {
        // make absolute (the complete path instead of the referance name)
        associatedImages.add(p.join(dir.path, path));
      } else if (path.startsWith('/')) {
        //already absolute
        associatedImages.add(path);
      } else {
        //bundled asset
        final exportedPath = await copyAssetForExport(
          assetRelativePath: path,
          exportDir: exportAssetsDir,
        );
        if (exportedPath != null) {
          associatedAssetImages.add(exportedPath);
        }
      }
    }
  }

  static Future<void> gatherAssociatedAudio(Root root) async {
    associatedAudio.clear();

    var everyMp3 = Ev4rs.getAllMp3(root);

    //
    //get a list of mp3 files to export
    //

    //temporary export directory for bundled audio
    final tempDir = await getTemporaryDirectory();
    final exportAssetsDir = Directory(p.join(tempDir.path, 'export_assets'));
    
    if (await exportAssetsDir.exists()) {
      await exportAssetsDir.delete(recursive: true);
    }
    await exportAssetsDir.create();

    //regular directory
    final dir = await getApplicationDocumentsDirectory();
    
    //collecting the paths
    for (final path in everyMp3) {
      if (path.startsWith('my_audio/')) {
        // make absolute (the complete path instead of the referance name)
        associatedAudio.add(p.join(dir.path, path));
      } else if (path.startsWith('/')) {
        //already absolute
        associatedAudio.add(path);
      } else {
        //bundled asset
        final exportedPath = await copyAssetForExport(
          assetRelativePath: path,
          exportDir: exportAssetsDir,
        );
        if (exportedPath != null) {
          associatedAssetAudio.add(exportedPath);
        }
      }
    }
  }

  static Future<String?> copyAssetForExport({
    required String assetRelativePath,
    required Directory exportDir,
  }) async {
    try {
      // Load the asset bytes (must match your asset path structure)
      final byteData = await rootBundle.load(assetRelativePath);
      final bytes = byteData.buffer.asUint8List();

      // Extract only the filename (e.g., 'cat.png')
      final filename = p.basename(assetRelativePath);

      // Create the output file inside export folder
      final outFile = File(p.join(exportDir.path, filename));

      // Write asset bytes to the file
      await outFile.writeAsBytes(bytes);

      return outFile.path; // absolute path

    } catch (e) {
      // asset may not exist, wrong path, etc.
      return null;
    }
  }

  static Future<String> prepReadMes(String path) async {
    // Path for temp copy
    final dir = await getTemporaryDirectory();
    final exportDir = Directory(p.join(dir.path, 'export_assets'));
    
    if (await exportDir.exists() == false) {
      await exportDir.create();
    }

    String normalizeReadMe = '';

    final copiedPath = await copyAssetForExport(
      assetRelativePath: path, 
      exportDir: exportDir
    );
    if (copiedPath != null) {
      normalizeReadMe = copiedPath;
    }
    
    return normalizeReadMe;
  }

static List<int> _prepareAndEncodeArchive(List<ArchiveFile> files) {
  
  final archive = Archive();
  for (final f in files) {
    if (f.content != null && f.content is Iterable<int>) {
      
      // Safe conversion
      final safeBytes = f.content is Uint8List
          ? f.content as Uint8List
          : Uint8List.fromList(List<int>.from(f.content as Iterable<int>));
      archive.addFile(ArchiveFile(f.name, safeBytes.length, safeBytes));
    } else {
      // Fallback for folders or invalid content
      final folderName = f.name.endsWith('/') ? f.name : '${f.name}/';
      archive.addFile(ArchiveFile.noCompress(folderName, 0, <int>[]));
    }
  }
  return ZipEncoder().encode(archive)!;
}
  //use dropdown to set fileToExport before calling
  static Future<File> createBoardsetZip() async {
    loading.value = true;

    final archive = Archive();
    final root = await V4rs.simpleLoadRootData(); 
    await gatherAssociatedImages(root);
    await gatherAssociatedAudio(root);

    
    // get file name
    final fileLabel = p.basename(fileToExport!.path);
    final fileLabel2 = p.basenameWithoutExtension(fileToExport!.path);
    
    // 1. Add JSON to root of ZIP
    archive.addFile(
      ArchiveFile(
        fileLabel,
        await fileToExport!.length(),
        await fileToExport!.readAsBytes(),
      ),
    );

    // 2. Add imges to images folder
    for (final path in associatedImages) {
      final file = File(path);
      if (await file.exists()) {
        final filename = p.basename(path);
        archive.addFile(
          ArchiveFile.noCompress(
            'images/$filename',
            await file.length(),
            await file.readAsBytes(),
          ),
        );
      }
    }

    // 3. add asset images to images bundled folder
    for (final path in associatedAssetImages) {
      final file = File(path);
      if (await file.exists()) {
        final filename = p.basename(path);
        archive.addFile(
          ArchiveFile.noCompress(
            'images/bundled/$filename',
            await file.length(),
            await file.readAsBytes(),
          ),
        );
      }
    }

    // 4. add read me
    final firstReadMe = File(
      await prepReadMes(
        'assets/magma_vocab_symbols/READ_ME.txt'
      )
    );

    final firstReadMeName = p.basename(firstReadMe.path);
    archive.addFile(
      ArchiveFile.noCompress(
        'images/bundled/$firstReadMeName',
        await firstReadMe.length(),
        await firstReadMe.readAsBytes(),
      ),
    );

    // 5. Add mp3's inside audio folder
    for (final path in associatedAudio) {
      final file = File(path);
      if (await file.exists()) {
        final filename = p.basename(path);
        archive.addFile(
          ArchiveFile.noCompress(
            'audio/$filename',
            await file.length(),
            await file.readAsBytes(),
          ),
        );
      }
    }

    // 6. add audio inside audio bundled
    for (final path in associatedAssetAudio) {
      final file = File(path);
      if (await file.exists()) {
        final filename = p.basename(path);
        archive.addFile(
          ArchiveFile.noCompress(
            'audio/bundled/$filename',
            await file.length(),
            await file.readAsBytes(),
          ),
        );
      }
    }

    // 7. add read me
    final secondReadMe = File(
      await prepReadMes(
        'assets/sounds/READ_ME.txt'
      )
    );
    final secondReadMeName = p.basename(secondReadMe.path);
    archive.addFile(
      ArchiveFile.noCompress(
        'audio/bundled/$secondReadMeName',
        await secondReadMe.length(),
        await secondReadMe.readAsBytes(),
      ),
    );

    // Make the ZIP path
    final tempDir = await getTemporaryDirectory();
    final outputZip = p.join(tempDir.path, '$fileLabel2.zip');

    //Encode zip
    final zipBytes = await compute(_prepareAndEncodeArchive, archive.files);

    // Write ZIP
    final zipFile = File(outputZip);
    await zipFile.writeAsBytes(zipBytes);

    // Return ZIP
    loading.value = false;
    return zipFile;
  }

  static String getFileName(File file){
    return p.basenameWithoutExtension(file.path);
  }

  static int includeMessageRow = 1;
  static int includeNavRow = 1;
  static int includeGrammerRow = 1;

  static bool includeIndicatorRow = true;

  static String indicator1 = 'Start Over';
  static final String _indicator1 = "indicator1";

  static Future<void> saveIndicator1 (String indicator1) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_indicator1, indicator1);
  } 

  static String indicator2 = 'Wrong Button';
  static final String _indicator2 = "indicator2";
   static Future<void> saveIndicator2 (String indicator2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_indicator2, indicator2);
  } 

  static String indicator3 = 'Done';
  static final String _indicator3 = "indicator3";
   static Future<void> saveIndicator3 (String indicator3) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_indicator3, indicator3);
  } 

  static Future<void> loadSavedExportValues() async {
    final prefs = await SharedPreferences.getInstance();
    
    indicator1 = prefs.getString(_indicator1) ?? indicator1;
    indicator2 = prefs.getString(_indicator2) ?? indicator2;
    indicator3 = prefs.getString(_indicator3) ?? indicator3;
  }




}