# Dart JSON Schema Generator

## Project Overview

A Dart/Flutter package that provides a simple `@Field` annotation for adding metadata to model fields and generates standard JSON schemas using a command-line tool. Perfect for creating API documentation, validation schemas, and interoperability with other systems.

## Package Specification

### **Package Name**: `dart_json_schema`
### **Package Name**: `dart_json_schema`
### **Version**: `1.0.0-alpha-0.1`
### **Platform Support**: Dart & Flutter

## Project Structure

```
dart_json_schema/
├── lib/
│   ├── dart_json_schema.dart             # Main export file
│   └── src/
│       ├── field.dart                    # @Field annotation
│       ├── annotations.dart              # Annotation utilities
│       └── config.dart                   # Configuration support
├── bin/
│   └── dart_json_schema.dart             # CLI command tool
├── lib/src/generator/
│   └── json_schema_generator.dart        # Core generation logic
├── example/
│   ├── lib/
│   │   └── models/
│   │       ├── user.dart                 # Example model
│   │       ├── product.dart              # Another example
│   │       └── order.dart                # Nested object example
│   └── pubspec.yaml
├── test/
│   ├── field_test.dart
│   ├── generator_test.dart
│   ├── nested_object_test.dart
│   └── cli_test.dart
├── pubspec.yaml
├── README.md
├── CHANGELOG.md
├── spec.md
└── LICENSE
```

## Core Features

### 1. Simple @Field Annotation
```dart
class Field {
  final String? title;
  final String? description;  
  final List<dynamic>? examples;
  
  const Field({
    this.title,
    this.description,
    this.examples,
  });
}
```

### 2. Command-Line Tool
```bash
# Generate JSON schemas for all annotated models
dart run dart_json_schema:generate

# Generate with custom output directory
dart run dart_json_schema:generate --output schemas/

# Generate for specific files
dart run dart_json_schema:generate lib/models/user.dart

# Watch mode (regenerate on file changes)
dart run dart_json_schema:generate --watch
```

### 3. Automatic Model Discovery
- Scans project for `@Field` annotated classes
- Generates JSON schema files automatically
- Supports custom output directories

## Technical Requirements

### Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  analyzer: ^6.0.0
  path: ^1.8.0
  yaml: ^3.1.0
  args: ^2.4.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  test: ^1.21.0
  flutter_lints: ^3.0.0
  build_runner: ^2.3.0
```

### Dart Version Support
- Minimum: `>=2.17.0`
- Maximum: `<4.0.0`

## API Design

### Core Classes

#### 1. Field Annotation
```dart
/// Simple field annotation for metadata
class Field {
  /// Human-readable field title
  final String? title;
  
  /// Field description
  final String? description;
  
  /// Example values
  final List<dynamic>? examples;

  const Field({
    this.title,
    this.description,
    this.examples,
  });
}
```

#### 2. CLI Generator
```dart
class JsonSchemaGenerator {
  /// Scan directory and generate all schemas
  static Future<void> generateAllSchemas({
    String inputDir = 'lib/',
    String outputDir = 'build/schemas',
  });
  
  /// Generate JSON schema for a single model file
  static Future<Map<String, dynamic>?> generateSchemaForFile(String filePath);
}
```

#### 3. Configuration Support
```yaml
# dart_json_schema.yaml (optional config file)
dart_json_schema:
  input_directories:
    - lib/models/
    - lib/entities/
  output_directory: build/schemas/
  file_naming: snake_case  # or camelCase
  include_metadata: true
  watch_mode: false
  schema_version: "https://json-schema.org/draft/2020-12/schema"
```

## Usage Examples

### 1. Model Definition
```dart
// lib/models/user.dart
import 'package:dart_json_schema/dart_json_schema.dart';

class User {
  @Field(
    title: "User ID",
    description: "Unique identifier for the user",
    examples: [1, 2, 3]
  )
  final int id;

  @Field(
    title: "Full Name", 
    description: "The user's full name",
    examples: ["John Doe", "Jane Smith"]
  )
  final String name;

  @Field(
    title: "Email Address",
    description: "User's email address", 
    examples: ["john@example.com"]
  )
  final String email;

  const User({
    required this.id,
    required this.name, 
    required this.email,
  });
}
```

### 2. Command Usage
```bash
# Navigate to your Dart/Flutter project
cd my_project/

# Add dart_json_schema to dev_dependencies
dart pub add --dev dart_json_schema
# or for Flutter: flutter pub add --dev dart_json_schema

# Generate JSON schemas
dart run dart_json_schema:generate

# Output: Generated schemas/user.schema.json
```

### 3. Generated Output (Pydantic-Compatible)
```json
// schemas/user.schema.json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "title": "User", 
  "properties": {
    "id": {
      "title": "User ID",
      "description": "Unique identifier for the user",
      "examples": [1, 2, 3],
      "type": "integer"
    },
    "name": {
      "title": "Full Name",
      "description": "The user's full name", 
      "examples": ["John Doe", "Jane Smith"],
      "type": "string"
    },
    "email": {
      "title": "Email Address",
      "description": "User's email address",
      "examples": ["john@example.com"],
      "type": "string"
    }
  },
  "required": ["id", "name", "email"],
  "$defs": {}
}
```

### 4. Integration with Build Process
```yaml
# pubspec.yaml
dev_dependencies:
  dart_json_schema: ^1.0.0
  build_runner: ^2.3.0

# Add build script
scripts:
  build: dart run build_runner build
  schemas: dart run dart_json_schema:generate
  watch: dart run dart_json_schema:generate --watch
```

## Command-Line Interface

### Commands

#### Generate Command
```bash
dart run dart_json_schema:generate [options] [files...]

Options:
  -o, --output          Output directory (default: schemas/)
  -w, --watch           Watch for changes and regenerate
  -c, --config          Config file path (default: dart_json_schema.yaml)
  -v, --verbose         Verbose output
  -h, --help            Show help
  --include-private     Include private fields
  --format              Output format (json|yaml) (default: json)
  --schema-version      JSON Schema version (default: 2020-12)

Examples:
  dart run dart_json_schema:generate
  dart run dart_json_schema:generate --output api/schemas/
  dart run dart_json_schema:generate lib/models/ --watch
  dart run dart_json_schema:generate --config custom_config.yaml
```

#### Init Command
```bash
dart run dart_json_schema:init

# Creates default configuration file
# Sets up recommended directory structure
```

#### Version Command
```bash
dart run dart_json_schema:version
# Outputs: dart_json_schema version 1.0.0-alpha-0.1
```

## Implementation Plan

### Phase 1: Core Implementation (Week 1-2)
- [ ] Create `@Field` annotation class
- [ ] Implement basic CLI tool structure
- [ ] Build model scanning logic
- [ ] Implement JSON schema generation
- [ ] Basic file writing functionality

### Phase 2: CLI Enhancement (Week 2-3)
- [ ] Add command-line argument parsing
- [ ] Implement watch mode
- [ ] Add configuration file support
- [ ] Error handling and validation
- [ ] Progress indicators and logging

### Phase 3: Flutter Integration (Week 3-4)
- [ ] Test with Flutter projects
- [ ] Build runner integration
- [ ] Performance optimization
- [ ] Integration tests with real projects

### Phase 4: Polish & Documentation (Week 4)
- [x] Complete CLI documentation
- [x] Example Flutter app with commands
- [x] CI/CD setup for testing
- [x] Prepare for pub.dev publication

## Command Workflow

### Development Workflow
```bash
# Developer adds @Field annotations to models
# lib/models/user.dart

# Run generation command
dart run dart_json_schema:generate

# JSON schemas are generated in build/schemas/ directory
# build/schemas/user.schema.json

# Use schemas for API docs, validation, OpenAPI specs, etc.
```

### CI/CD Integration
```yaml
# .github/workflows/schemas.yml
name: Generate JSON Schemas
on: [push, pull_request]

jobs:
  generate-schemas:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
      - run: dart pub get
      - run: dart run dart_json_schema:generate
      - run: git diff --exit-code build/schemas/  # Ensure schemas are up to date
```

## Testing Strategy

### Unit Tests
- Test `@Field` annotation parsing
- Test schema generation logic
- Test file scanning and discovery
- Test CLI argument parsing

### Integration Tests  
- Test with complete Flutter projects
- Test watch mode functionality
- Test configuration file handling
- Test error scenarios

### CLI Tests
- Test all command-line options
- Test file path handling
- Test output formatting
- Test watch mode behavior

## Documentation Requirements

### README.md
- Installation instructions
- Command usage examples
- Configuration options
- Integration with build tools

### CLI Help
- Built-in help system
- Command examples
- Option descriptions
- Troubleshooting guide

### Example Project
- Complete Flutter example
- Multiple annotated models
- Generated schemas
- Build integration example

## Quality Standards

### Code Quality
- Flutter lints compliance
- 100% dartdoc coverage for public APIs
- Minimum 90% test coverage
- CLI usability testing

### Performance
- Fast model scanning (< 1s for 100 models)
- Efficient file watching
- Minimal memory usage
- Progress feedback for large projects

### Reliability
- Robust error handling
- Graceful failure modes
- Clear error messages
- File system safety

## Success Metrics

### Adoption
- Target: 1000+ pub points within 6 months
- Target: Used in 50+ Flutter projects
- Positive CLI tool feedback

### Performance
- Model scanning: < 100ms per file
- Schema generation: < 10ms per model
- Watch mode: < 200ms response time

### Quality
- Zero critical bugs in CLI
- 95%+ test coverage maintained
- All platforms working (Windows/Mac/Linux)

## Future Roadmap (Post 1.0)

### Version 1.1
- VSCode extension for schema preview
- Build runner integration
- Custom output formats (YAML, TypeScript)

### Version 1.2
- Real-time schema validation
- Schema diffing tools
- Integration with popular API tools

### Version 2.0
- GUI tool for schema management
- Advanced templating system
- Multi-project support

## Risk Mitigation

### Technical Risks
- **File System Issues**: Robust path handling and permissions
- **Large Projects**: Efficient scanning and incremental updates
- **Cross-Platform**: Test on all major platforms

### Usability Risks  
- **Complex CLI**: Focus on simple, intuitive commands
- **Configuration**: Provide sensible defaults
- **Error Messages**: Clear, actionable error messages

## Conclusion

This command-driven approach makes the plugin more suitable for development workflows, CI/CD integration, and large Flutter projects. Developers can easily generate schemas as part of their build process and keep them up-to-date with a simple command.