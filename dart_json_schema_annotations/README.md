# dart_json_schema_annotations

Annotations for the `dart_json_schema` package. This package provides the `@Field` annotation, which allows you to add metadata to model fields for JSON schema generation.

## Features

- **`@Field` Annotation**: Decorate your Dart model fields with `@Field` to include metadata such as `name`, `description`, `example`, `defaultValue`, `minimum`, `maximum`, `minLength`, `maxLength`, `pattern`, `format`, `enum`, `readOnly`, `writeOnly`, and `deprecated`. This metadata is crucial for generating accurate and descriptive JSON schemas.
- **JSON Schema Generation**: Works in conjunction with the `dart_json_schema` package to enhance the generated schemas with detailed field-level information.

- **Typed Field Annotations**: For convenience and type safety, the package also provides specific field annotations for common Dart types, such as `@IntField`, `@StringField`, `@DoubleField`, `@BooleanField`, `@ListField`, `@ObjectField`, `@EnumField`, and `@DateTimeField`. These extend the base `@Field` annotation and can be used to clearly indicate the expected type of the field in the JSON schema.

## Getting started

To use this package, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  dart_json_schema_annotations: ^1.0.0
```

Then, run `dart pub get` to fetch the package.

## Usage

Import the package and use the `@Field` annotation or the more specific typed field annotations on your model properties:

```dart
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

class Product {
  @IntField(
    description: 'Unique identifier for the product',
    examples: [101, 102],
  )
  final int id;

  @StringField(
    description: 'Name of the product',
    examples: ['Laptop', 'Mouse'],
  )
  final String name;

  @DoubleField(
    description: 'Price of the product',
    examples: [1200.50, 25.99],
  )
  final double price;

  @BooleanField(
    description: 'Availability status of the product',
    examples: [true, false],
  )
  final bool inStock;

  @ListField(
    description: 'List of tags associated with the product',
    examples: [
      ['electronics', 'computers'],
      ['accessories']
    ],
  )
  final List<String> tags;

  @ObjectField(
    description: 'Details about the product manufacturer',
    examples: [
      {'name': 'TechCorp', 'country': 'USA'},
      {'name': 'GlobalGadgets', 'country': 'China'}
    ],
  )
  final Map<String, dynamic> manufacturer;

  @EnumField(
    description: 'Category of the product',
    examples: ['Electronics', 'Office', 'Home'],
  )
  final String category;

  @DateTimeField(
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