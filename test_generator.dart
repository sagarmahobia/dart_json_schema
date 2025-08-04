import 'package:dart_json_schema/src/generator/json_schema_generator.dart';

void main() async {
  print('Testing JSON schema generator with new annotations...');
  
  try {
    await JsonSchemaGenerator.generateAllSchemas(
      inputDir: 'example/lib/models',
      outputDir: 'build/schemas',
    );
    print('Schema generation completed successfully!');
  } catch (e) {
    print('Error during schema generation: $e');
  }
}