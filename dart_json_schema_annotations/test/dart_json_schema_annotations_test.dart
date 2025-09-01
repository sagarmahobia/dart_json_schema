import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('Field annotation', () {
    test('can be instantiated with all parameters', () {
      final field = Field(
        title: 'User Age',
        description: 'Age of the user in years',
        examples: [25, 30, 35],
      );

      expect(field.title, 'User Age');
      expect(field.description, 'Age of the user in years');
      expect(field.examples, [25, 30, 35]);
    });

    test('can be instantiated with no parameters', () {
      final field = Field();

      expect(field.title, null);
      expect(field.description, null);
      expect(field.examples, null);
    });

    test('can be instantiated with only title', () {
      final field = Field(
        title: 'Email Address',
      );

      expect(field.title, 'Email Address');
      expect(field.description, null);
      expect(field.examples, null);
    });

    test('can be instantiated with only description', () {
      final field = Field(
        description: 'User email address',
      );

      expect(field.title, null);
      expect(field.description, 'User email address');
      expect(field.examples, null);
    });

    test('can be instantiated with only examples', () {
      final field = Field(
        examples: ['john@example.com', 'jane@example.com'],
      );

      expect(field.title, null);
      expect(field.description, null);
      expect(field.examples, ['john@example.com', 'jane@example.com']);
    });

    test('handles different types of examples', () {
      final field = Field(
        title: 'Mixed Examples',
        examples: [1, 'string', true, 3.14],
      );

      expect(field.title, 'Mixed Examples');
      expect(field.examples, [1, 'string', true, 3.14]);
    });
  });
}