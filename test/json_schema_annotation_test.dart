import 'dart:io';
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';
import 'package:test/test.dart';

void main() {
  test('Generator handles @JsonSchema annotation', () async {
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    final outputDir = Directory('${tempDir.path}/output');
    
    try {
      // Create a test file with @JsonSchema annotation
      final testFile = File('${tempDir.path}/json_schema_model.dart');
      await testFile.writeAsString('''
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

@JsonSchema()
class UserModel {
  final int id;
  final String name;
  final String email;
  final int age;
  final bool isActive;

  @Field(
    description: 'User bio with custom description',
    examples: ['Software developer', 'Designer']
  )
  final String? bio;

  final dynamic dynamicField; // This should be ignored

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.isActive,
    this.bio,
    this.dynamicField,
  });
}
''');

      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: tempDir.path,
        outputDir: outputDir.path,
      );
      
      final schemaFile = File('${outputDir.path}/json_schema_model.schema.json');
      
      expect(await schemaFile.exists(), isTrue);
      
      final schemaContent = await schemaFile.readAsString();
      
      expect(schemaContent, contains(r'"$schema": "https://json-schema.org/draft/2020-12/schema"'));
      expect(schemaContent, contains('"title": "UserModel"'));
      expect(schemaContent, contains('"type": "object"'));
      
      // Check that all fields are included
      expect(schemaContent, contains('"id"'));
      expect(schemaContent, contains('"name"'));
      expect(schemaContent, contains('"email"'));
      expect(schemaContent, contains('"age"'));
      expect(schemaContent, contains('"isActive"'));
      expect(schemaContent, contains('"bio"'));
      
      // Check that dynamic field is not included
      expect(schemaContent, isNot(contains('dynamicField')));
      
      // Check that field with @Field annotation has description and examples
      expect(schemaContent, contains('"description": "User bio with custom description"'));
      expect(schemaContent, contains('"examples": ['));
      
      // Check required fields (nullable fields should not be required)\n      expect(schemaContent, contains('\"required\": ['));\n      expect(schemaContent, contains('\"id\"'));\n      expect(schemaContent, contains('\"name\"'));\n      expect(schemaContent, contains('\"email\"'));\n      expect(schemaContent, contains('\"age\"'));\n      expect(schemaContent, contains('\"isActive\"'));\n      // bio is nullable, so it should not be in required fields\n      expect(schemaContent, isNot(contains('\"required\": [\\n    \"id\",\\n    \"name\",\\n    \"email\",\\n    \"age\",\\n    \"isActive\",\\n    \"bio\"')));
      
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });

  test('Generator ignores classes without @JsonSchema annotation', () async {
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    final outputDir = Directory('${tempDir.path}/output');
    
    try {
      // Create a test file without @JsonSchema annotation
      final testFile = File('${tempDir.path}/no_annotation_model.dart');
      await testFile.writeAsString('''
class NoAnnotationModel {
  final int id;
  final String name;

  const NoAnnotationModel({
    required this.id,
    required this.name,
  });
}
''');

      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: tempDir.path,
        outputDir: outputDir.path,
      );
      
      final schemaFile = File('${outputDir.path}/no_annotation_model.schema.json');
      
      // No schema should be generated
      expect(await schemaFile.exists(), isFalse);
      
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}