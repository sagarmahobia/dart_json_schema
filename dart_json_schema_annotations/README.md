# dart_json_schema_annotations

Annotations for the `dart_json_schema` package. This package provides the `@Field` annotation, which allows you to add metadata to model fields for JSON schema generation.

## Features

- **`@Field` Annotation**: Decorate your Dart model fields with `@Field` to include metadata such as `title`, `description`, and `examples`. This metadata is crucial for generating accurate and descriptive JSON schemas.
- **JSON Schema Generation**: Works in conjunction with the `dart_json_schema` package to enhance the generated schemas with detailed field-level information.
- **Simplified API**: Only one annotation to learn and use, making it easier to add metadata to your model fields.

## Getting started

To use this package, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  dart_json_schema_annotations: ^2.0.0
```

Then, run `dart pub get` to fetch the package.

## Usage

Import the package and use the `@Field` annotation on your model properties:

```dart
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

class Product {
  @Field(
    description: 'Unique identifier for the product',
    examples: [101, 102],
  )
  final int id;

  @Field(
    description: 'Name of the product',
    examples: ['Laptop', 'Mouse'],
  )
  final String name;

  @Field(
    description: 'Price of the product',
    examples: [1200.50, 25.99],
  )
  final double price;

  @Field(
    description: 'Availability status of the product',
    examples: [true, false],
  )
  final bool inStock;

  @Field(
    description: 'List of tags associated with the product',
    examples: [
      ['electronics', 'computers'],
      ['accessories']
    ],
  )
  final List<String> tags;

  @Field(
    description: 'Details about the product manufacturer',
    examples: [
      {'name': 'TechCorp', 'country': 'USA'},
      {'name': 'GlobalGadgets', 'country': 'China'}
    ],
  )
  final Map<String, dynamic> manufacturer;

  @Field(
    description: 'Category of the product',
    examples: ['Electronics', 'Office', 'Home'],
  )
  final String category;

  @Field(
    description: 'Date and time when the product was listed',
    examples: ['2023-01-15T10:00:00Z', '2023-03-20T14:30:00Z'],
  )
  final String listedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.inStock,
    required this.tags,
    required this.manufacturer,
    required this.category,
    required this.listedAt,
  });
}
```

## Additional information

For more information on how to use the generated JSON schemas or the `dart_json_schema` package, please refer to its documentation.