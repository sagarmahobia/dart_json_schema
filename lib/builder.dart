import 'package:build/build.dart';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';

Builder jsonSchemaBuilder(BuilderOptions options) {
  return JsonSchemaBuilder();
}

class JsonSchemaBuilder implements Builder {
  @override
  final buildExtensions = const {
    '.dart': ['.schema.json']
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    
    // Skip if not in models or entities directory
    if (!inputId.path.contains('lib/models/') && !inputId.path.contains('lib/entities/')) {
      return;
    }
    
    // Generate schema for this specific file
    final schema = await JsonSchemaGenerator.generateSchemaForFile(inputId.path);
    
    if (schema != null) {
      final outputId = inputId.changeExtension('.schema.json');
      
      final jsonString = JsonEncoder.withIndent('  ').convert(schema);
      await buildStep.writeAsString(outputId, jsonString);
    }
  }
}