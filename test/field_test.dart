
import 'package:dart_json_schema/dart_json_schema.dart';
import 'package:test/test.dart';

void main() {
  test('Field annotation stores values', () {
    const field = Field(
      title: 'Test Title',
      description: 'Test Description',
      examples: ['a', 'b'],
    );

    expect(field.title, 'Test Title');
    expect(field.description, 'Test Description');
    expect(field.examples, ['a', 'b']);
  });
}
