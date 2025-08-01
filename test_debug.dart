import 'dart:io';
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';

void main() async {
  // Create a temporary directory for testing
  final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_debug');
  final outputDir = Directory('${tempDir.path}/output');
  
  print('Temp directory: ${tempDir.path}');
  print('Output directory: ${outputDir.path}');
  
  try {
    // Test the generator with specific directories
    await JsonSchemaGenerator.generateAllSchemas(
      inputDir: 'example/lib/models/',
      outputDir: outputDir.path,
    );
    
    print('Generated files:');
    if (await outputDir.exists()) {
      await for (final file in outputDir.list(recursive: true)) {
        print('  ${file.path}');
        
        // Show content of each file
        if (file is File) {
          print('  Content:');
          final content = await file.readAsString();
          print(content);
          print('---');
        }
      }
    } else {
      print('Output directory does not exist');
    }
  } finally {
    // Clean up
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
      print('Cleaned up temp directory');
    }
  }
}