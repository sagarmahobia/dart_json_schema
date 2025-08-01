import 'dart:io';
import 'package:test/test.dart';

void main() {
  group('CLI tests', () {
    test('CLI shows help when no arguments provided', () async {
      final result = await Process.run(
        'dart', 
        ['run', 'dart_json_schema:dart_json_schema'],
        runInShell: true,
      );
      
      expect(result.exitCode, 1);
      expect(result.stdout, contains('No command specified'));
    });

    test('CLI shows version', () async {
      final result = await Process.run(
        'dart', 
        ['run', 'dart_json_schema:dart_json_schema', 'version'],
        runInShell: true,
      );
      
      expect(result.exitCode, 0);
      expect(result.stdout, contains('dart_json_schema version'));
    });

    test('CLI shows help for generate command', () async {
      final result = await Process.run(
        'dart', 
        ['run', 'dart_json_schema:dart_json_schema', 'generate', '--help'],
        runInShell: true,
      );
      
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Generate JSON schemas'));
    });

    test('CLI shows help for init command', () async {
      final result = await Process.run(
        'dart', 
        ['run', 'dart_json_schema:dart_json_schema', 'init', '--help'],
        runInShell: true,
      );
      
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Initialize dart_json_schema'));
    });

    test('CLI init command creates config file', () async {
      // Remove config file if it exists
      final configFile = File('dart_json_schema.yaml');
      if (await configFile.exists()) {
        await configFile.delete();
      }

      final result = await Process.run(
        'dart', 
        ['run', 'dart_json_schema:dart_json_schema', 'init'],
        runInShell: true,
      );
      
      expect(result.exitCode, 0);
      expect(result.stdout, contains('Created configuration file'));
      
      // Check that config file was created
      expect(await configFile.exists(), isTrue);
      
      // Clean up
      if (await configFile.exists()) {
        await configFile.delete();
      }
    });

    test('CLI handles unknown command', () async {
      final result = await Process.run(
        'dart', 
        ['run', 'dart_json_schema:dart_json_schema', 'unknown'],
        runInShell: true,
      );
      
      expect(result.exitCode, 1);
      expect(result.stdout, contains('Unknown command'));
    });
  });
}
