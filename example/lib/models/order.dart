
import 'package:dart_json_schema/dart_json_schema.dart';
import 'user.dart';

class Order {
  @Field(
    title: "Order ID",
    description: "Unique identifier for the order"
  )
  final int id;

  @Field(
    title: "User",
    description: "The user who placed the order"
  )
  final User user;

  const Order({
    required this.id,
    required this.user,
  });
}
