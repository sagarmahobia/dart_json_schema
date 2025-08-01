
import 'dart:io';

class ModelScanner {
  static Future<List<String>> scan(String directory) async {
    final dir = Directory(directory);
    final files = <String>[];
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          files.add(entity.path);
        }
      }
    }
    return files;
  }
}
