import 'dart:io';
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Generator creates a schema', () async {
    // Create a temporary directory for testing
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    final outputDir = Directory('${tempDir.path}/output');
    
    try {
      // Test the generator with specific directories
      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: 'example/lib/models/',
        outputDir: outputDir.path,
      );
      
      // Check that schema files were created
      final userSchema = File('${outputDir.path}/user.schema.json');
      final productSchema = File('${outputDir.path}/product.schema.json');
      
      expect(await userSchema.exists(), isTrue);
      expect(await productSchema.exists(), isTrue);
      
      // Check that the schemas have the correct structure
      final userSchemaContent = await userSchema.readAsString();
      final productSchemaContent = await productSchema.readAsString();
      
      expect(userSchemaContent, contains(r'"$schema": "https://json-schema.org/draft/2020-12/schema"'));
      expect(userSchemaContent, contains('"title": "User"'));
      expect(userSchemaContent, contains('"type": "object"'));
      expect(userSchemaContent, contains(r'"$defs": {}'));
      
      expect(productSchemaContent, contains(r'"$schema": "https://json-schema.org/draft/2020-12/schema"'));
      expect(productSchemaContent, contains('"title": "Product"'));
      expect(productSchemaContent, contains('"type": "object"'));
      expect(productSchemaContent, contains(r'"$defs": {'));
    } finally {
      // Clean up
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });

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
