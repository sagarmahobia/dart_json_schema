import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

class User {
  @Field(
    description: 'Unique identifier for the user',
    examples: [1, 2, 3],
  )
  final int id;

  @Field(
    description: 'The user\'s full name',
    examples: ['John Doe', 'Jane Smith'],
  )
  final String name;

  @Field(
    description: 'User\'s email address',
    examples: ['john@example.com', 'jane@example.com'],
  )
  final String email;

  @Field(
    description: 'User\'s age in years',
    examples: [25, 30, 45],
  )
  final int age;

  @Field(
    description: 'Whether the user account is active',
    examples: [true, false],
  )
  final bool isActive;

  @Field(
    description: 'Date when the user registered',
    examples: ['2023-01-15T10:00:00Z', '2023-03-20T14:30:00Z'],
  )
  final String registrationDate;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.isActive,
    required this.registrationDate,
  });
}