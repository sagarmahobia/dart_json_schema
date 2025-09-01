# dart_json_schema

A Dart package for generating JSON schemas from Dart model classes using annotations.

## Features

- Generate JSON schemas from Dart classes
- Support for primitive types (String, int, double, bool)
- Support for complex types (List, custom objects)
- Support for optional and required fields
- Simple `@Field` annotation with just three properties: title, description, and examples
- Class-level `@JsonSchema` annotation for automatic schema generation
- **Configuration-based schema generation** - Specify patterns to automatically treat files as if they have the `@JsonSchema` annotation
- Build runner integration

## Installation

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  dart_json_schema_annotations: ^2.1.0

dev_dependencies:
  dart_json_schema: ^2.1.0
  build_runner: ^2.4.0
```

## Usage

### Basic Usage

1. Create your model classes with annotations:

```dart
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

class User {
  @Field(
    title: 'User ID',
    description: 'Unique identifier for the user',
    examples: [1, 2, 3]
  )
  final int id;

  @Field(
    title: 'User Name',
    description: 'The full name of the user',
    examples: ["John Doe", "Jane Smith"]
  )
  final String name;

  @Field(
    title: 'Email Address',
    description: 'The user\'s email address',
    examples: ["user@example.com"]
  )
  final String email;

  @Field(
    title: 'Is Active',
    description: 'Whether the user account is active',
    examples: [true, false]
  )
  final bool isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isActive,
  });
}
```

### Field Annotation

The `@Field` annotation is the only annotation available and has three properties:

- `title` - A short, human-readable title for the field
- `description` - A longer description of the field's purpose or usage
- `examples` - A list of example values for the field

The annotation works with all Dart primitive types and complex types:
- `int` - Generates JSON schema type "integer"
- `String` - Generates JSON schema type "string"
- `double` - Generates JSON schema type "number"
- `bool` - Generates JSON schema type "boolean"
- `List<T>` - Generates JSON schema type "array"
- Custom objects - Generates JSON schema type "object"

### Complex Example

```dart
class Product {
  @Field(
    title: 'Product ID',
    description: 'Unique product identifier',
    examples: [1, 2, 3]
  )
  final int id;

  @Field(
    title: 'Product Name',
    description: 'Name of the product',
    examples: ["Laptop", "Smartphone", "Headphones"]
  )
  final String name;

  @Field(
    title: 'Price',
    description: 'Product price in USD',
    examples: [999.99, 699.99, 199.99]
  )
  final double price;

  @Field(
    title: 'Categories',
    description: 'Product categories',
    examples: [["Electronics", "Computers"], ["Audio", "Wireless"]]
  )
  final List<String> categories;

  @Field(
    title: 'Specifications',
    description: 'Technical specifications'
  )
  final ProductSpecs specs;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categories,
    required this.specs,
  });
}

class ProductSpecs {
  @Field(
    title: 'Brand',
    description: 'Product brand',
    examples: ["Apple", "Samsung", "Sony"]
  )
  final String brand;

  @Field(
    title: 'Model',
    description: 'Product model',
    examples: ["MacBook Pro", "Galaxy S23", "WH-1000XM5"]
  )
  final String model;

  ProductSpecs({
    required this.brand,
    required this.model,
  });
}
```

### Optional Fields

Fields that are nullable in Dart will be marked as optional in the JSON schema:

```dart
class User {
  @Field(
    title: 'Username',
    description: 'Required username'
  )
  final String username;

  @Field(
    title: 'Bio',
    description: 'Optional user biography'
  )
  final String? bio; // This will not be in the "required" list
}
```

### Build Runner Integration

To use with build_runner, create a `build.yaml` file in your project root:

```yaml
targets:
  $default:
    builders:
      dart_json_schema:
        generate_for:
          - lib/**/*.dart
```

Then run:
```bash
dart run build_runner build
```

## Configuration-Based Schema Generation

Create a `dart_json_schema.yaml` configuration file to specify which files should be treated as having the `@JsonSchema` annotation:

```yaml
dart_json_schema:
  include:
    - lib/models/**/*.dart        # Include all .dart files in lib/models/ and subdirectories
    - lib/entities/**/*.dart      # Include all .dart files in lib/entities/ and subdirectories
  exclude:
    - lib/models/internal/**/*.dart  # Exclude internal models
```

With this configuration, all public fields in classes in the specified files will be included in the generated schemas, even without any annotations. This is equivalent to adding the `@JsonSchema` annotation to those classes.

Files that don't match any include patterns will still be processed normally - classes with `@JsonSchema` or `@Field` annotations will generate schemas as before.

## Generated Schema Example

For the User class above, the generated JSON schema will look like:

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "User",
  "type": "object",
  "properties": {
    "id": {
      "type": "integer",
      "title": "User ID",
      "description": "Unique identifier for the user",
      "examples": [1, 2, 3]
    },
    "name": {
      "type": "string",
      "title": "User Name",
      "description": "The full name of the user",
      "examples": ["John Doe", "Jane Smith"]
    },
    "email": {
      "type": "string",
      "title": "Email Address",
      "description": "The user's email address",
      "examples": ["user@example.com"]
    },
    "isActive": {
      "type": "boolean",
      "title": "Is Active",
      "description": "Whether the user account is active",
      "examples": [true, false]
    }
  },
  "required": ["id", "name", "email", "isActive"]
}
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Publishing

For information about publishing these packages to pub.dev, see the [PUBLISHING_GUIDE.md](PUBLISHING_GUIDE.md) file.