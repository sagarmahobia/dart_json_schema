# dart_json_schema

A Dart/Flutter package that provides a simple `@Field` annotation for adding metadata to model fields and generates standard JSON schemas using a command-line tool. Perfect for creating API documentation, validation schemas, and interoperability with other systems.

## Features

- **Simple @Field Annotation**: Add metadata like title, description, and examples to your model fields
- **Command-Line Tool**: Generate JSON schemas with a simple command
- **Automatic Model Discovery**: Scans your project for annotated models automatically
- **Standard JSON Schema**: Generates Pydantic-compatible JSON schemas
- **Configuration Support**: Customize behavior with YAML configuration files
- **Watch Mode**: Automatically regenerate schemas when files change

## Installation

Add `dart_json_schema` to your `pubspec.yaml`:

```yaml
dev_dependencies:
  dart_json_schema: ^1.0.0-alpha-0.1
```

Then run:

```bash
dart pub get
# or for Flutter projects
flutter pub get
```

## Usage

### 1. Annotate Your Models

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

### 2. Generate JSON Schemas

```bash
# Generate schemas for all annotated models
dart run dart_json_schema:generate

# Generate with custom output directory
dart run dart_json_schema:generate --output build/schemas/

# Generate for specific files
dart run dart_json_schema:generate lib/models/user.dart

# Watch mode (regenerate on file changes)
dart run dart_json_schema:generate --watch
```

### 3. Generated Output

The generated JSON schema will look like this:

```json
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

## Command-Line Interface

### Commands

#### generate
Generate JSON schemas for annotated models:

```bash
dart run dart_json_schema:generate [options] [files...]
```

Options:
- `-o, --output`: Output directory (default: build/schemas)
- `-w, --watch`: Watch for changes and regenerate
- `-c, --config`: Config file path (default: dart_json_schema.yaml)
- `-v, --verbose`: Verbose output
- `-h, --help`: Show help
- `--include-private`: Include private fields
- `--format`: Output format (json|yaml) (default: json)
- `--schema-version`: JSON Schema version (default: 2020-12)
- `--input`: Input files or directories

#### init
Create a default configuration file:

```bash
dart run dart_json_schema:init
```

#### version
Show the package version:

```bash
dart run dart_json_schema:version
```

## Configuration

Create a `dart_json_schema.yaml` file in your project root:

```yaml
dart_json_schema:
  input_directories:
    - lib/models/
    - lib/entities/
  output_directory: build/schemas/
  file_naming: snake_case
  include_metadata: true
  watch_mode: false
  schema_version: "https://json-schema.org/draft/2020-12/schema"
```

## Integration

### With Build Process

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  dart_json_schema: ^1.0.0-alpha-0.1
  build_runner: ^2.3.0

scripts:
  build: dart run build_runner build
  schemas: dart run dart_json_schema:generate
  watch: dart run dart_json_schema:generate --watch
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

## API Reference

### @Field Annotation

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

## Example Project

See the `example/` directory for a complete Flutter example with annotated models and generated schemas.

## Testing

Run the tests with:

```bash
dart test
```

## License

MIT License - see [LICENSE](LICENSE) file for details.
