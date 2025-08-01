
import 'dart:io';

class FileWriter {
  static Future<void> write(String path, String content) async {
    final file = File(path);
    await file.create(recursive: true);
    await file.writeAsString(content);
  }
}
