/// Configuration file support for dart_json_schema
library dart_json_schema.config;

import 'dart:io';
import 'package:yaml/yaml.dart';

class Config {
  final List<String> inputDirectories;
  final String outputDirectory;
  final String fileNaming;
  final bool includeMetadata;
  final bool watchMode;
  final String schemaVersion;

  Config({
    this.inputDirectories = const ['lib/models/', 'lib/entities/'],
    this.outputDirectory = 'schemas/',
    this.fileNaming = 'snake_case',
    this.includeMetadata = true,
    this.watchMode = false,
    this.schemaVersion = 'https://json-schema.org/draft/2020-12/schema',
  });

  /// Load configuration from a YAML file
  static Future<Config> loadFromFile(String configPath) async {
    final file = File(configPath);
    if (!await file.exists()) {
      // Return default configuration if file doesn't exist
      return Config();
    }

    try {
      final content = await file.readAsString();
      final yaml = loadYaml(content);
      
      if (yaml is! YamlMap || !yaml.containsKey('dart_json_schema')) {
        // Return default configuration if file format is invalid
        return Config();
      }
      
      final configMap = yaml['dart_json_schema'] as YamlMap;
      
      return Config(
        inputDirectories: _getList(configMap, 'input_directories') ?? const ['lib/models/', 'lib/entities/'],
        outputDirectory: configMap['output_directory'] as String? ?? 'schemas/',
        fileNaming: configMap['file_naming'] as String? ?? 'snake_case',
        includeMetadata: configMap['include_metadata'] as bool? ?? true,
        watchMode: configMap['watch_mode'] as bool? ?? false,
        schemaVersion: configMap['schema_version'] as String? ?? 'https://json-schema.org/draft/2020-12/schema',
      );
    } catch (e) {
      // Return default configuration if parsing fails
      return Config();
    }
  }
  
  /// Helper method to extract a list from YAML
  static List<String>? _getList(YamlMap map, String key) {
    final value = map[key];
    if (value is YamlList) {
      return value.nodes.map((node) => node.toString()).toList();
    } else if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return null;
  }

  /// Helper function to read version from pubspec.yaml
  static Future<String?> readPubspecVersion(String pubspecPath) async {
    final file = File(pubspecPath);
    if (!await file.exists()) {
      return null;
    }
    
    try {
      final content = await file.readAsString();
      final yaml = loadYaml(content);
      
      if (yaml is YamlMap && yaml.containsKey('version')) {
        return yaml['version'].toString();
      }
    } catch (e) {
      // Return null if parsing fails
    }
    
    return null;
  }
  
  /// Helper function to read name from pubspec.yaml
  static Future<String?> readPubspecName(String pubspecPath) async {
    final file = File(pubspecPath);
    if (!await file.exists()) {
      return null;
    }
    
    try {
      final content = await file.readAsString();
      final yaml = loadYaml(content);
      
      if (yaml is YamlMap && yaml.containsKey('name')) {
        return yaml['name'].toString();
      }
    } catch (e) {
      // Return null if parsing fails
    }
    
    return null;
  }
}