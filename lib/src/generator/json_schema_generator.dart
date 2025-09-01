
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;
import '../config/schema_config.dart';

class JsonSchemaGenerator {
  static Future<void> generateAllSchemas({
    String inputDir = 'lib/',
    String outputDir = 'build/schemas',
    String configPath = 'dart_json_schema.yaml',
  }) async {
    // Use the output directory directly without adding project name subdirectory
    final actualOutputDir = outputDir;
        
    final input = Directory(inputDir);
    final output = Directory(actualOutputDir);

    if (!await input.exists()) {
      print('Input directory not found: ${input.path}');
      return;
    }

    if (!await output.exists()) {
      await output.create(recursive: true);
    }

    // Load configuration
    final config = await SchemaConfig.loadFromFile(configPath);

    await for (final file in input.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
        // Check if this file should generate a schema based on configuration
        final relativePath = p.relative(file.path, from: input.path);
        if (config.shouldGenerateSchemaForFile(relativePath)) {
          final schema = await generateSchemaForFile(file.path, useJsonSchema: true);
          if (schema != null) {
            final schemaFileName =
                '${p.basenameWithoutExtension(file.path)}.schema.json';
            final outputFile = File(p.join(output.path, schemaFileName));
            final jsonString = JsonEncoder.withIndent('  ').convert(schema);
            await outputFile.writeAsString(jsonString);
            print('Generated schema for ${file.path} at ${outputFile.path}');
          }
        } else {
          // Process normally (for @Field annotations or @JsonSchema annotations)
          final schema = await generateSchemaForFile(file.path);
          if (schema != null) {
            final schemaFileName =
                '${p.basenameWithoutExtension(file.path)}.schema.json';
            final outputFile = File(p.join(output.path, schemaFileName));
            final jsonString = JsonEncoder.withIndent('  ').convert(schema);
            await outputFile.writeAsString(jsonString);
            print('Generated schema for ${file.path} at ${outputFile.path}');
          }
        }
      }
    }
  }

  static Future<Map<String, dynamic>?> generateSchemaForFile(
      String filePath, {bool useJsonSchema = false}) async {
    final absolutePath = p.isRelative(filePath)
        ? p.absolute(filePath)
        : filePath;
        
    final parseResult = await parseFile(
      path: absolutePath,
      featureSet: FeatureSet.latestLanguageVersion(),
    );

    final classVisitor = _ClassVisitor(useJsonSchema: useJsonSchema);
    parseResult.unit.visitChildren(classVisitor);

    // Only generate schema if the class should generate a schema or has @Field annotations
    if (classVisitor.className == null || 
        (!classVisitor.shouldGenerateSchema && classVisitor.fields.isEmpty)) {
      return null;
    }

    final defs = <String, dynamic>{};
    final schema = _generateSchemaForClass(classVisitor, defs);

    final Map<String, dynamic> result = {
      '\$schema': 'https://json-schema.org/draft/2020-12/schema',
      'title': classVisitor.className,
      'type': 'object',
      'properties': schema['properties'],
      'required': schema['required'],
      '\$defs': defs,
    };
    
    
    return result;
  }

  static Map<String, dynamic> _generateSchemaForClass(
      _ClassVisitor classVisitor, Map<String, dynamic> defs) {
    final properties = <String, dynamic>{};
    final requiredFields = <String>[];

    for (final field in classVisitor.fields) {
      final fieldName = field.fields.variables.first.name.lexeme;
      final annotations = field.metadata;
      
      // Get field annotation if it exists, otherwise use null
      Annotation? fieldAnnotation;
      try {
        fieldAnnotation = annotations.firstWhere((a) => a.name.name == 'Field');
      } catch (e) {
        // No @Field annotation found, that's OK for @JsonSchema classes
      }

      final title = fieldAnnotation != null ? _getArgument(fieldAnnotation, 'title') : null;
      final description = fieldAnnotation != null ? _getArgument(fieldAnnotation, 'description') : null;
      final examples = fieldAnnotation != null ? _getArgument(fieldAnnotation, 'examples') : null;

      final type = field.fields.type;
      final typeName = type?.toSource() ?? 'any';

      // Check for unsupported dynamic type
      if (typeName == 'dynamic') {
        // Skip dynamic fields
        continue;
      }

      // Skip unsupported types
      if (typeName == 'Function' || typeName == 'Future' || typeName.startsWith('Future<')) {
        continue;
      }

      if (_isPrimitiveType(typeName)) {
        properties[fieldName] = {
          'type': _getDartType(type),
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (examples != null) 'examples': examples,
        };
      } else {
        // Add the type definition to $defs if it's not already there
        if (!defs.containsKey(typeName)) {
          // For now, we'll create a placeholder. In a more complete implementation,
          // we would generate the full schema for the referenced type.
          defs[typeName] = {
            'type': 'object',
            'properties': {},
            'required': [],
          };
        }
        
        properties[fieldName] = {
          '\$ref': '#/\$defs/$typeName',
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (examples != null) 'examples': examples,
        };
      }

      // Fields are required unless they are nullable
      if (type?.toSource().endsWith('?') == false) {
        requiredFields.add(fieldName);
      }
    }

    return {
      'type': 'object',
      'properties': properties,
      'required': requiredFields,
    };
  }

  static bool _isPrimitiveType(String typeName) {
    return [
      'String',
      'int',
      'double',
      'num',
      'bool',
      'List',
      'Set',
      'Iterable',
    ].contains(typeName);
  }

  static dynamic _getArgument(Annotation annotation, String name) {
    final args = annotation.arguments?.arguments;
    if (args == null) return null;

    for (final arg in args) {
      if (arg is NamedExpression && arg.name.label.name == name) {
        final expression = arg.expression;
        return _parseExpression(expression);
      }
    }
    return null;
  }

  static dynamic _parseExpression(Expression expression) {
    if (expression is SimpleStringLiteral) {
      return expression.value;
    } else if (expression is IntegerLiteral) {
      return expression.value;
    } else if (expression is DoubleLiteral) {
      return expression.value;
    } else if (expression is BooleanLiteral) {
      return expression.value;
    } else if (expression is ListLiteral) {
      final List<dynamic> result = [];
      for (final element in expression.elements) {
        // Handle different types of collection elements
        if (element is Expression) {
          result.add(_parseExpression(element));
        } else {
          // For complex elements, add the source representation
          result.add(element.toSource());
        }
      }
      return result;
    } else if (expression is SimpleIdentifier) {
      // Handle identifiers like null
      if (expression.name == 'null') {
        return null;
      }
    }
    // For complex expressions, return the source code as string
    return expression.toSource();
  }

  static String _getDartType(TypeAnnotation? type) {
    if (type == null) {
      return 'any';
    }
    
    final typeName = type.toSource();
    
    // Handle generic types by extracting the base type
    String baseType = typeName;
    if (typeName.contains('<')) {
      baseType = typeName.substring(0, typeName.indexOf('<'));
    }
    
    switch (baseType) {
      case 'String':
        return 'string';
      case 'int':
        return 'integer';
      case 'double':
        return 'number';
      case 'num':
        return 'number';
      case 'bool':
        return 'boolean';
      case 'List':
      case 'Set':
      case 'Iterable':
        return 'array';
      default:
        return 'object'; // We will replace this with a reference to the definition
    }
  }
}

class _ClassVisitor extends GeneralizingAstVisitor<void> {
  ClassDeclaration? currentClass;
  final fields = <FieldDeclaration>[];
  bool shouldGenerateSchema = false;
  final bool useJsonSchema;

  _ClassVisitor({this.useJsonSchema = false});

  String? get className => currentClass?.name.toString();

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    currentClass = node;
    // Check if the class has the @JsonSchema annotation or if we're using config-based generation
    if (useJsonSchema || node.metadata.any((a) => a.name.name == 'JsonSchema')) {
      shouldGenerateSchema = true;
    }
    super.visitClassDeclaration(node);
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    // Only process fields if we're in a class with @JsonSchema or fields with @Field annotation
    if (currentClass != null) {
      if (shouldGenerateSchema) {
        // For @JsonSchema classes, include all public fields
        final fieldName = node.fields.variables.first.name.lexeme;
        if (!fieldName.startsWith('_')) {
          fields.add(node);
        }
      } else if (node.metadata.any((a) => a.name.name == 'Field')) {
        // For non-@JsonSchema classes, only include fields with @Field annotation
        fields.add(node);
      }
    }
    super.visitFieldDeclaration(node);
  }
}
