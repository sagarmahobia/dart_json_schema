# dart_json_schema

A Dart package for generating JSON schemas from Dart model classes using annotations.

## Features

- Generate JSON schemas from Dart classes
- Support for primitive types (String, int, double, bool)
- Support for complex types (List, custom objects)
- Support for optional and required fields
- Typed field annotations for better type safety
- Build runner integration

## Installation

Add these dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  dart_json_schema_annotations: ^1.0.0

dev_dependencies:
  dart_json_schema: ^1.0.0
  build_runner: ^2.4.0
```

## Usage

### Basic Usage

1. Create your model classes with annotations:

```dart
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

class User {
  @IntField(
    title: 'User ID',
    description: 'Unique identifier for the user',
    examples: [1, 2, 3]
  )
  final int id;

  @StringField(
    title: 'User Name',
    description: 'The full name of the user',
    examples: ["John Doe", "Jane Smith"]
  )
  final String name;

  @StringField(
    title: 'Email Address',
    description: 'The user\'s email address',
    examples: ["user@example.com"]
  )
  final String email;

  @BooleanField(
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

2. Run the generator:

```bash
# Using the CLI
dart run dart_json_schema

# Using build_runner
dart run build_runner build
```

### Available Annotations

#### @IntField
For integer fields.

```dart
@IntField(
  title: 'Age',
  description: 'User age in years',
  examples: [25, 30, 35]
)
final int age;
```

#### @StringField
For string fields.

```dart
@StringField(
  title: 'Username',
  description: 'Unique username',
  examples: ["johndoe", "janesmith"]
)
final String username;
```

#### @DoubleField
For floating-point number fields.

```dart
@DoubleField(
  title: 'Price',
  description: 'Product price in USD',
  examples: [19.99, 29.99, 49.99]
)
final double price;
```

#### @BooleanField
For boolean fields.

```dart
@BooleanField(
  title: 'Enabled',
  description: 'Feature toggle status',
  examples: [true, false]
)
final bool enabled;
```

#### @ListField
For list/array fields.

```dart
@ListField(
  title: 'Tags',
  description: 'List of tags associated with the item',
  examples: [["tag1", "tag2"], ["important", "urgent"]]
)
final List<String> tags;
```

#### @ObjectField
For nested object fields.

```dart
@ObjectField(
  title: 'Address',
  description: 'User\'s physical address'
)
final Address address;
```

#### @EnumField
For enum fields.

```dart
@EnumField(
  title: 'Status',
  description: 'Current status of the order',
  examples: ["pending", "processing", "completed"]
)
final OrderStatus status;
```

#### @DateTimeField
For date/time fields.

```dart
@DateTimeField(
  title: 'Created At',
  description: 'When the record was created',
  examples: ["2023-01-01T00:00:00Z"]
)
final DateTime createdAt;
```

### Complex Example

```dart
class Product {
  @IntField(
    title: 'Product ID',
    description: 'Unique product identifier',
    examples: [1, 2, 3]
  )
  final int id;

  @StringField(
    title: 'Product Name',
    description: 'Name of the product',
    examples: ["Laptop", "Smartphone", "Headphones"]
  )
  final String name;

  @DoubleField(
    title: 'Price',
    description: 'Product price in USD',
    examples: [999.99, 699.99, 199.99]
  )
  final double price;

  @ListField(
    title: 'Categories',
    description: 'Product categories',
    examples: [["Electronics", "Computers"], ["Audio", "Wireless"]]
  )
  final List<String> categories;

  @ObjectField(
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
  @StringField(
    title: 'Brand',
    description: 'Product brand',
    examples: ["Apple", "Samsung", "Sony"]
  )
  final String brand;

  @StringField(
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
  @StringField(
    title: 'Username',
    description: 'Required username'
  )
  final String username;

  @StringField(
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

### Migration Guide

If you're upgrading from the generic `@Field` annotation to the new typed annotations:

**Before:**
```dart
@Field(
  type: FieldType.string,
  title: 'Name',
  description: 'User name',
  examples: ["John", "Jane"]
)
final String name;
```

**After:**
```dart
@StringField(
  title: 'Name',
  description: 'User name',
  examples: ["John", "Jane"]
)
final String name;
```

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
