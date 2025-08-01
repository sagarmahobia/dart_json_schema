
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
