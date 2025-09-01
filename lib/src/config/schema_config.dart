import 'dart:io';

import 'package:yaml/yaml.dart';

class SchemaConfig {
  final List<String> includePatterns;
  final List<String> excludePatterns;

  SchemaConfig({
    this.includePatterns = const [],
    this.excludePatterns = const [],
  });

  static Future<SchemaConfig> loadFromFile(String configPath) async {
    final file = File(configPath);
    if (await file.exists()) {
      final content = await file.readAsString();
      final yaml = loadYaml(content);
      
      if (yaml is Map && yaml['dart_json_schema'] is Map) {
        final config = yaml['dart_json_schema'];
        final List<String> include;
        final List<String> exclude;
        
        if (config['include'] is List) {
          include = (config['include'] as List).map((item) => item.toString()).toList();
        } else {
          include = [];
        }
        
        if (config['exclude'] is List) {
          exclude = (config['exclude'] as List).map((item) => item.toString()).toList();
        } else {
          exclude = [];
        }
          
        return SchemaConfig(
          includePatterns: include,
          excludePatterns: exclude,
        );
      }
    }
    
    // Return empty configuration by default
    return SchemaConfig();
  }

  bool shouldGenerateSchemaForFile(String filePath) {
    // Check exclude patterns first
    for (final pattern in excludePatterns) {
      if (_matchesPattern(filePath, pattern)) {
        return false;
      }
    }
    
    // Check include patterns
    for (final pattern in includePatterns) {
      if (_matchesPattern(filePath, pattern)) {
        return true;
      }
    }
    
    return false;
  }

  bool _matchesPattern(String filePath, String pattern) {
    // Handle simple glob patterns
    if (pattern.endsWith('/**/*.dart')) {
      // Pattern like lib/models/**/*.dart - matches any .dart file in directory or subdirectories
      final prefix = pattern.substring(0, pattern.length - 9); // Remove /**/*.dart
      final result = filePath.startsWith(prefix) && filePath.endsWith('.dart');
      return result;
    } else if (pattern.endsWith('/*.dart')) {
      // Pattern like lib/models/*.dart - matches any .dart file directly in directory
      final prefix = pattern.substring(0, pattern.length - 6); // Remove /*.dart
      final result = filePath.startsWith(prefix) && 
             filePath.endsWith('.dart') && 
             !filePath.substring(prefix.length).contains('/');
      return result;
    } else if (pattern == '*.dart') {
      // Simple pattern - matches any .dart file
      final result = filePath.endsWith('.dart');
      return result;
    } else if (pattern.endsWith('.dart')) {
      // Exact file match
      final result = filePath == pattern;
      return result;
    }
    
    return false;
  }
}