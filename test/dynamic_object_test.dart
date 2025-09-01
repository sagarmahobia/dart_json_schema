import 'dart:io';
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Generator throws exception for dynamic objects', () async {
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    final outputDir = Directory('${tempDir.path}/output');
    
    try {
      // Create a test file with dynamic objects
      final testFile = File('${tempDir.path}/dynamic_model.dart');
      await testFile.writeAsString('''
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

class DynamicModel {
  @Field(
    description: 'A dynamic object field',
    examples: [
      {'name': 'John', 'age': 30},
      {'product': 'Laptop', 'price': 999.99}
    ]
  )
  final dynamic dynamicObject;

  const DynamicModel({
    required this.dynamicObject,
  });
}
''');

      // Expect an exception to be thrown
      await expectLater(
        () => JsonSchemaGenerator.generateAllSchemas(
          inputDir: tempDir.path,
          outputDir: outputDir.path,
        ),
        throwsA(
          predicate((e) => 
            e is Exception && 
            e.toString().contains('Dynamic type is not supported')
          )
        )
      );
      
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}