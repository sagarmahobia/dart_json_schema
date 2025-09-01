import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';
import 'package:test/test.dart';

void main() {
 

  group('IntField annotation', () {
    test('can be instantiated with all parameters', () {
      final intField = IntField(
        title: 'Age',
        description: 'User age',
        examples: [25, 30, 35],
      );

      expect(intField.title, 'Age');
      expect(intField.description, 'User age');
      expect(intField.examples, [25, 30, 35]);
    });

    test('can be instantiated with no parameters', () {
      final intField = IntField();

      expect(intField.title, null);
      expect(intField.description, null);
      expect(intField.examples, null);
    });
  });

  group('StringField annotation', () {
    test('can be instantiated with all parameters', () {
      final stringField = StringField(
        title: 'Email',
        description: 'User email',
        examples: ['john@example.com', 'jane@example.com'],
      );

      expect(stringField.title, 'Email');
      expect(stringField.description, 'User email');
      expect(stringField.examples, ['john@example.com', 'jane@example.com']);
    });

    test('can be instantiated with no parameters', () {
      final stringField = StringField();

      expect(stringField.title, null);
      expect(stringField.description, null);
      expect(stringField.examples, null);
    });
  });

  group('DoubleField annotation', () {
    test('can be instantiated with all parameters', () {
      final doubleField = DoubleField(
        title: 'Price',
        description: 'Item price',
        examples: [10.99, 20.00],
      );

      expect(doubleField.title, 'Price');
      expect(doubleField.description, 'Item price');
      expect(doubleField.examples, [10.99, 20.00]);
    });

    test('can be instantiated with no parameters', () {
      final doubleField = DoubleField();

      expect(doubleField.title, null);
      expect(doubleField.description, null);
      expect(doubleField.examples, null);
    });
  });

  group('DoubleField annotation', () {
    test('can be instantiated with all parameters', () {
      final doubleField = DoubleField(
        title: 'Price',
        description: 'Item price',
        examples: [10.99, 20.00],
      );

      expect(doubleField.title, 'Price');
      expect(doubleField.description, 'Item price');
      expect(doubleField.examples, [10.99, 20.00]);
    });

    test('can be instantiated with no parameters', () {
      final doubleField = DoubleField();

      expect(doubleField.title, null);
      expect(doubleField.description, null);
      expect(doubleField.examples, null);
    });
  });


  group('BooleanField annotation', () {
    test('can be instantiated with all parameters', () {
      final booleanField = BooleanField(
        title: 'Is Active',
        description: 'User active status',
        examples: [true, false],
      );

      expect(booleanField.title, 'Is Active');
      expect(booleanField.description, 'User active status');
      expect(booleanField.examples, [true, false]);
    });

    test('can be instantiated with no parameters', () {
      final booleanField = BooleanField();

      expect(booleanField.title, null);
      expect(booleanField.description, null);
      expect(booleanField.examples, null);
    });
  });

  group('ListField annotation', () {
    test('can be instantiated with all parameters', () {
      final listField = ListField(
        title: 'Tags',
        description: 'List of tags',
        examples: [
          ['tag1', 'tag2'],
          ['tag3']
        ],
      );

      expect(listField.title, 'Tags');
      expect(listField.description, 'List of tags');
      expect(listField.examples, [
        ['tag1', 'tag2'],
        ['tag3']
      ]);
    });

    test('can be instantiated with no parameters', () {
      final listField = ListField();

      expect(listField.title, null);
      expect(listField.description, null);
      expect(listField.examples, null);
    });
  });

  group('ObjectField annotation', () {
    test('can be instantiated with all parameters', () {
      final objectField = ObjectField(
        title: 'Address',
        description: 'User address',
        examples: [
          {'street': '123 Main St', 'city': 'Anytown'},
          {'street': '456 Oak Ave', 'city': 'Otherville'}
        ],
      );

      expect(objectField.title, 'Address');
      expect(objectField.description, 'User address');
      expect(objectField.examples, [
        {'street': '123 Main St', 'city': 'Anytown'},
        {'street': '456 Oak Ave', 'city': 'Otherville'}
      ]);
    });

    test('can be instantiated with no parameters', () {
      final objectField = ObjectField();

      expect(objectField.title, null);
      expect(objectField.description, null);
      expect(objectField.examples, null);
    });
  });

  group('EnumField annotation', () {
    test('can be instantiated with all parameters', () {
      final enumField = EnumField(
        title: 'Status',
        description: 'Current status',
        examples: ['active', 'inactive'],
      );

      expect(enumField.title, 'Status');
      expect(enumField.description, 'Current status');
      expect(enumField.examples, ['active', 'inactive']);
    });

    test('can be instantiated with no parameters', () {
      final enumField = EnumField();

      expect(enumField.title, null);
      expect(enumField.description, null);
      expect(enumField.examples, null);
    });
  });

  group('DateTimeField annotation', () {
    test('can be instantiated with all parameters', () {
      final dateTimeField = DateTimeField(
        title: 'Created At',
        description: 'Creation timestamp',
        examples: ['2023-01-01T12:00:00Z'],
      );

      expect(dateTimeField.title, 'Created At');
      expect(dateTimeField.description, 'Creation timestamp');
      expect(dateTimeField.examples, ['2023-01-01T12:00:00Z']);
    });

    test('can be instantiated with no parameters', () {
      final dateTimeField = DateTimeField();

      expect(dateTimeField.title, null);
      expect(dateTimeField.description, null);
      expect(dateTimeField.examples, null);
    });
  });
 

  
}
