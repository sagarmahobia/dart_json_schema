
import 'dart:convert';
import 'dart:io';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;

class JsonSchemaGenerator {
  static Future<void> generateAllSchemas({
    String inputDir = 'lib/',
    String outputDir = 'build/schemas',
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

    await for (final file in input.list(recursive: true)) {
      if (file is File && file.path.endsWith('.dart')) {
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

  static Future<Map<String, dynamic>?> generateSchemaForFile(
      String filePath) async {
    final absolutePath = p.isRelative(filePath)
        ? p.absolute(filePath)
        : filePath;
        
    final parseResult = await parseFile(
      path: absolutePath,
      featureSet: FeatureSet.latestLanguageVersion(),
    );

    final classVisitor = _ClassVisitor();
    parseResult.unit.visitChildren(classVisitor);

    if (classVisitor.className == null) {
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
      
      Annotation? fieldAnnotation;
      try {
        // Check for any of the new typed annotations or the base Field annotation
        fieldAnnotation = annotations.firstWhere((a) =>
          a.name.name == 'Field' ||
          a.name.name == 'IntField' ||
          a.name.name == 'StringField' ||
          a.name.name == 'DoubleField' ||
          a.name.name == 'BooleanField' ||
          a.name.name == 'ListField' ||
          a.name.name == 'ObjectField' ||
          a.name.name == 'EnumField' ||
          a.name.name == 'DateTimeField'
        );
      } catch (e) {
        continue;
      }

      final title = _getArgument(fieldAnnotation, 'title');
      final description = _getArgument(fieldAnnotation, 'description');
      final examples = _getArgument(fieldAnnotation, 'examples');

      final type = field.fields.type;
      final typeName = type?.toSource() ?? 'any';

      // Check for unsupported dynamic type
      if (typeName == 'dynamic') {
        throw Exception('Dynamic type is not supported for field: $fieldName. Use a specific type instead.');
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
  final classes = <ClassDeclaration>[];
  final fields = <FieldDeclaration>[];

  String? get className => classes.isNotEmpty ? classes.first.name.toString() : null;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    classes.add(node);
    super.visitClassDeclaration(node);
  }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    if (node.metadata.any((a) =>
      a.name.name == 'Field'
    )) {
      fields.add(node);
    }
    super.visitFieldDeclaration(node);
  }
}
