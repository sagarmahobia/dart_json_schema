
import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';
import 'user.dart';

class Order {
  @IntField(
    description: 'Unique identifier for the order',
    examples: [1001, 1002, 1003],
  )
  final int id;

  @ObjectField(
    description: 'The user who placed the order',
    examples: [
      {
        'id': 1,
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 30,
        'isActive': true,
        'registrationDate': '2023-01-15T10:00:00Z'
      }
    ],
  )
  final User user;

  @DateTimeField(
    description: 'Date and time when the order was placed',
    examples: ['2023-01-15T10:00:00Z', '2023-03-20T14:30:00Z'],
  )
  final String orderDate;

  @DoubleField(
    description: 'Total amount of the order',
    examples: [299.99, 599.50],
  )
  final double totalAmount;

  @ListField(
    description: 'List of products in the order',
    examples: [
      [
        {'id': 1, 'name': 'Laptop', 'price': 999.99, 'inStock': true}
      ]
    ],
  )
  final List<Map<String, dynamic>> products;

  const Order({
    required this.id,
    required this.user,
    required this.orderDate,
    required this.totalAmount,
    required this.products,
  });
}
