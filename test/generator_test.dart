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

  test('Generator skips dynamic objects in @JsonSchema classes', () async {
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    final outputDir = Directory('${tempDir.path}/output');
    
    try {
      // Create a test file with dynamic objects
      final testFile = File('${tempDir.path}/dynamic_model.dart');
      await testFile.writeAsString('''
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

@JsonSchema()
class DynamicModel {
  final int id;
  final dynamic dynamicObject; // This should be skipped
  final String name;

  const DynamicModel({
    required this.id,
    required this.dynamicObject,
    required this.name,
  });
}
''');

      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: tempDir.path,
        outputDir: outputDir.path,
      );
      
      final schemaFile = File('${outputDir.path}/dynamic_model.schema.json');
      
      expect(await schemaFile.exists(), isTrue);
      
      final schemaContent = await schemaFile.readAsString();
      
      // Check that the schema was generated
      expect(schemaContent, contains(r'"$schema": "https://json-schema.org/draft/2020-12/schema"'));
      expect(schemaContent, contains('"title": "DynamicModel"'));
      expect(schemaContent, contains('"type": "object"'));
      
      // Check that non-dynamic fields are included
      expect(schemaContent, contains('"id"'));
      expect(schemaContent, contains('"name"'));
      
      // Check that dynamic field is not included
      expect(schemaContent, isNot(contains('dynamicObject')));
      
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}
