
import 'package:dart_json_schema/dart_json_schema.dart';

class Product {
  @Field(
    title: "Product ID",
    description: "Unique identifier for the product",
    examples: [100, 200, 300]
  )
  final int id;

  @Field(
    title: "Product Name",
    description: "The name of the product",
    examples: ["Laptop", "Smartphone"]
  )
  final String name;

  @Field(
    title: "Price",
    description: "The price of the product",
    examples: [999.99, 499.99]
  )
  final double price;

  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}
