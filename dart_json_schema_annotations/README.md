# dart_json_schema_annotations

Annotations for the `dart_json_schema` package. This package provides the `@Field` and `@JsonSchema` annotations, which allow you to add metadata to model fields and classes for JSON schema generation.

## Features

- **`@Field` Annotation**: Decorate your Dart model fields with `@Field` to include metadata such as `title`, `description`, and `examples`. This metadata is crucial for generating accurate and descriptive JSON schemas.
- **`@JsonSchema` Annotation**: Apply to classes to automatically generate schemas for all public fields without requiring field-level annotations.
- **JSON Schema Generation**: Works in conjunction with the `dart_json_schema` package to enhance the generated schemas with detailed field-level information.
- **Simplified API**: Only one annotation to learn and use, making it easier to add metadata to your model fields.

## Getting started

To use this package, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  dart_json_schema_annotations: ^2.1.0
```

Then, run `dart pub get` to fetch the package.

## Usage

### Field-Level Annotations

Import the package and use the `@Field` annotation on your model properties:

```dart
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

class Product {
  @Field(
    title: 'Product ID',
    description: 'Unique identifier for the product',
    examples: [101, 102],
  )
  final int id;

  @Field(
    title: 'Product Name',
    description: 'Name of the product',
    examples: ['Laptop', 'Mouse'],
  )
  final String name;

  @Field(
    title: 'Price',
    description: 'Price of the product',
    examples: [1200.50, 25.99],
  )
  final double price;

  @Field(
    title: 'Availability',
    description: 'Availability status of the product',
    examples: [true, false],
  )
  final bool inStock;

  @Field(
    title: 'Tags',
    description: 'List of tags associated with the product',
    examples: [
      ['electronics', 'computers'],
      ['accessories']
    ],
  )
  final List<String> tags;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.inStock,
    required this.tags,
  });
}
```

### Class-Level Annotations

Use the `@JsonSchema` annotation to automatically generate schemas for all public fields:

```dart
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

@JsonSchema()
class User {
  final int id;
  final String name;
  final String email;
  final int age;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.isActive,
  });
}
```

The `@JsonSchema` annotation treats all public fields (those not starting with `_`) as if they have the `@Field` annotation with no additional metadata.

## Additional information

For more information on how to use the generated JSON schemas or the `dart_json_schema` package, please refer to its documentation.