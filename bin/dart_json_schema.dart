import 'dart:io';
import 'package:args/args.dart';
import 'package:dart_json_schema/src/generator/json_schema_generator.dart';
import 'package:dart_json_schema/src/config.dart';
import 'package:path/path.dart' as p;

const String version = '1.0.0-alpha-0.1';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('generate', generateCommandParser())
    ..addCommand('init', initCommandParser())
    ..addCommand('version', versionCommandParser());

  try {
    if (arguments.isEmpty) {
      print('No command specified. Use --help for available commands.');
      print(parser.usage);
      exit(1);
    }

    final results = parser.parse(arguments);
    
    if (results.command?.name == 'generate') {
      await handleGenerateCommand(results.command!);
    } else if (results.command?.name == 'init') {
      await handleInitCommand(results.command!);
    } else if (results.command?.name == 'version') {
      handleVersionCommand(results.command!);
    } else {
      print('Unknown command. Use --help for available commands.');
      print(parser.usage);
      exit(1);
    }
  } on FormatException catch (e) {
    print('Error: ${e.message}');
    exit(1);
  }
}

ArgParser generateCommandParser() {
  return ArgParser()
    ..addOption('output', abbr: 'o', 
        help: 'Output directory', 
        defaultsTo: 'build/schemas')
    ..addFlag('watch', abbr: 'w', 
        help: 'Watch for changes and regenerate',
        defaultsTo: false)
    ..addOption('config', abbr: 'c', 
        help: 'Config file path', 
        defaultsTo: 'dart_json_schema.yaml')
    ..addFlag('verbose', abbr: 'v', 
        help: 'Verbose output',
        defaultsTo: false)
    ..addFlag('help', abbr: 'h', 
        help: 'Show help',
        negatable: false)
    ..addFlag('include-private', 
        help: 'Include private fields',
        defaultsTo: false)
    ..addOption('format', 
        help: 'Output format (json|yaml)', 
        defaultsTo: 'json')
    ..addOption('schema-version',
        help: 'JSON Schema version',
        defaultsTo: '2020-12')
    ..addMultiOption('input',
        help: 'Input files or directories');
}

ArgParser initCommandParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', 
        help: 'Show help',
        negatable: false);
}

ArgParser versionCommandParser() {
  return ArgParser()
    ..addFlag('help', abbr: 'h', 
        help: 'Show help',
        negatable: false);
}

Future<void> handleGenerateCommand(ArgResults results) async {
  if (results['help'] as bool) {
    print('Generate JSON schemas for annotated models');
    print('');
    print('Usage: dart run dart_json_schema:generate [options] [files...]');
    print('');
    print('Options:');
    // Would normally print detailed help here
    return;
  }

  final outputDir = results['output'] as String;
  final watchMode = results['watch'] as bool;
  final configPath = results['config'] as String;
  final verbose = results['verbose'] as bool;
  final includePrivate = results['include-private'] as bool;
  final format = results['format'] as String;
  final schemaVersion = results['schema-version'] as String;
  final inputPaths = results.rest;

  print('Generating JSON schemas...');
  
  if (verbose) {
    print('Output directory: $outputDir');
    print('Watch mode: $watchMode');
    print('Config file: $configPath');
    print('Include private fields: $includePrivate');
    print('Format: $format');
    print('Schema version: $schemaVersion');
    if (inputPaths.isNotEmpty) {
      print('Input paths: ${inputPaths.join(', ')}');
    }
  }

  try {
    // Load configuration
    final config = await Config.loadFromFile(configPath);
    
    // Determine input directory
    String inputDir = 'lib/';
    if (inputPaths.isNotEmpty) {
      inputDir = inputPaths.first;
    } else if (config.inputDirectories.isNotEmpty) {
      inputDir = config.inputDirectories.first;
    }

    if (watchMode) {
      print('Watching for changes... Press Ctrl+C to stop.');
      // In a real implementation, this would watch for file changes
      // For now, we'll just generate once
      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: inputDir,
        outputDir: outputDir,
      );
    } else {
      await JsonSchemaGenerator.generateAllSchemas(
        inputDir: inputDir,
        outputDir: outputDir,
      );
      print('Schema generation complete.');
    }
  } catch (e) {
    print('Error generating schemas: $e');
    exit(1);
  }
}

Future<void> handleInitCommand(ArgResults results) async {
  if (results['help'] as bool) {
    print('Initialize dart_json_schema configuration');
    print('');
    print('Usage: dart run dart_json_schema:init');
    return;
  }

  const configContent = '''
dart_json_schema:
  input_directories:
    - lib/models/
    - lib/entities/
  output_directory: schemas/
  file_naming: snake_case
  include_metadata: true
  watch_mode: false
  schema_version: "https://json-schema.org/draft/2020-12/schema"
''';

  final configFile = File('dart_json_schema.yaml');
  if (await configFile.exists()) {
    print('Configuration file already exists: dart_json_schema.yaml');
    return;
  }

  await configFile.writeAsString(configContent);
  print('Created configuration file: dart_json_schema.yaml');
}

void handleVersionCommand(ArgResults results) async {
  if (results['help'] as bool) {
    print('Show dart_json_schema version');
    print('');
    print('Usage: dart run dart_json_schema:version');
    return;
  }

  print('dart_json_schema version $version');
}
