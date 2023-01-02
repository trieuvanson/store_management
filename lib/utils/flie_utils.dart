

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {

 readDataFromFileJson(var fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      if (file.existsSync()) {
        final contents = await file.readAsString();
        var json = contents.trim().isNotEmpty
            ? jsonDecode(contents)
            : [];
        return json;
      }
      return [];
    } catch (e) {
    }
    return [];
  }


  saveDataToFileJson(var data, var fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      print('Save to file: ${file.path}');
      var saveData = data.map((e) => e.toJson()).toList();
      final contents = jsonEncode(saveData);
      await file.writeAsString(contents.toString());
      return true;
    } catch (e) {
    }
    return false;
  }

//remove all cart
  removeFile(var fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.json');
      print('Remove all cart: ${file.path}');
     var delete = await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}

final fileUtils = FileUtils();