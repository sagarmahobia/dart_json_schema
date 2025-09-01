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