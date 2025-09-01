import 'dart:io';
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';
import 'package:dart_json_schema/src/config/schema_config.dart';
import 'package:test/test.dart';

void main() {
  test('SchemaConfig loads from file', () async {
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    
    try {
      // Create a test config file
      final configFile = File('${tempDir.path}/dart_json_schema.yaml');
      await configFile.writeAsString('''
dart_json_schema:
  include:
    - lib/models/**/*.dart
    - lib/entities/**/*.dart
  exclude:
    - lib/models/internal/**/*.dart
''');

      final config = await SchemaConfig.loadFromFile(configFile.path);
      
      expect(config.includePatterns, contains('lib/models/**/*.dart'));
      expect(config.includePatterns, contains('lib/entities/**/*.dart'));
      expect(config.excludePatterns, contains('lib/models/internal/**/*.dart'));
      
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });

  test('SchemaConfig uses default values when file not found', () async {
    final config = await SchemaConfig.loadFromFile('nonexistent.yaml');
    
    expect(config.includePatterns, isEmpty);
    expect(config.excludePatterns, isEmpty);
  });

  test('SchemaConfig matches file patterns correctly', () async {
    final config = SchemaConfig(
      includePatterns: ['lib/models/**/*.dart', 'lib/entities/**/*.dart'],
      excludePatterns: ['lib/models/internal/**/*.dart'],
    );
    
    // Should match included patterns
    expect(config.shouldGenerateSchemaForFile('lib/models/user.dart'), isTrue);
    expect(config.shouldGenerateSchemaForFile('lib/models/product/order.dart'), isTrue);
    expect(config.shouldGenerateSchemaForFile('lib/entities/customer.dart'), isTrue);
    
    // Should not match excluded patterns
    expect(config.shouldGenerateSchemaForFile('lib/models/internal/helper.dart'), isFalse);
    
    // Should not match non-included patterns
    expect(config.shouldGenerateSchemaForFile('lib/services/api.dart'), isFalse);
  });

  test('Generator works with config-based schema generation', () async {
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    final outputDir = Directory('${tempDir.path}/output');
    
    try {
      // Create a test file that should be included by config
      final testFile = File('${tempDir.path}/lib/models/user_model.dart');
      await testFile.create(recursive: true);
      await testFile.writeAsString('''
class UserModel {
  final int id;
  final String name;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });
}
''');

      // Create config file
      final configFile = File('${tempDir.path}/dart_json_schema.yaml');
      await configFile.writeAsString('''
dart_json_schema:
  include:
    - lib/models/**/*.dart
''');

      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: tempDir.path,
        outputDir: outputDir.path,
        configPath: configFile.path,
      );
      
      final schemaFile = File('${outputDir.path}/user_model.schema.json');
      
      expect(await schemaFile.exists(), isTrue);
      
      final schemaContent = await schemaFile.readAsString();
      
      expect(schemaContent, contains(r'"$schema": "https://json-schema.org/draft/2020-12/schema"'));
      expect(schemaContent, contains('"title": "UserModel"'));
      expect(schemaContent, contains('"type": "object"'));
      
      // Check that all fields are included
      expect(schemaContent, contains('"id"'));
      expect(schemaContent, contains('"name"'));
      expect(schemaContent, contains('"email"'));
      
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}