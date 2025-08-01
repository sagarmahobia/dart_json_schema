
import 'dart:io';
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';
import 'package:dart_json_schema/src/config.dart';
import 'package:test/test.dart';

void main() {
  test('Generator creates a schema for a model with a nested object', () async {
    final tempDir = Directory.systemTemp.createTempSync('dart_json_schema_test');
    final outputDir = Directory('${tempDir.path}/output');
    
    try {
      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: 'example/lib/models/',
        outputDir: outputDir.path,
      );
      
      final pluginName = await Config.readPubspecName('pubspec.yaml') ?? 'dart_json_schema';
      final orderSchema = File('${outputDir.path}/${pluginName}/schemas/order.schema.json');
      
      expect(await orderSchema.exists(), isTrue);
      
      final orderSchemaContent = await orderSchema.readAsString();
      
      expect(orderSchemaContent, contains(r'"$ref": "#/$defs/User"'));
      expect(orderSchemaContent, contains(r'"$defs": {'));
      expect(orderSchemaContent, contains(r'"User": {'));
      expect(orderSchemaContent, contains(r'"type": "object"'));
      expect(orderSchemaContent, contains(r'"properties": {}'));
      expect(orderSchemaContent, contains(r'"required": []'));
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}
