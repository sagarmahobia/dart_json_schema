import 'package:dart_json_schema_annotations/dart_json_schema_annotations.dart';

/// An annotation for defining an integer field in a JSON schema.
///
/// Extends [Field] with a type parameter of [int].
class IntField extends Field<int> {
  /// Creates a new [IntField] instance.
  const IntField({
    super.title,
    super.description,
    super.examples,
  });
}

/// An annotation for defining a string field in a JSON schema.
///
/// Extends [Field] with a type parameter of [String].
class StringField extends Field<String> {
  /// Creates a new [StringField] instance.
  const StringField({
    super.title,
    super.description,
    super.examples,
  });
}

/// An annotation for defining a double field in a JSON schema.
///
/// Extends [Field] with a type parameter of [double].
class DoubleField extends Field<double> {
  /// Creates a new [DoubleField] instance.
  const DoubleField({
    super.title,
    super.description,
    super.examples,
  });
}

/// An annotation for defining a boolean field in a JSON schema.
///
/// Extends [Field] with a type parameter of [bool].
class BooleanField extends Field<bool> {
  /// Creates a new [BooleanField] instance.
  const BooleanField({
    super.title,
    super.description,
    super.examples,
  });
}

/// An annotation for defining a list field in a JSON schema.
///
/// Extends [Field] with a type parameter of [List<dynamic>].
class ListField extends Field<List<dynamic>> {
  /// Creates a new [ListField] instance.
  const ListField({
    super.title,
    super.description,
    super.examples,
  });
}

/// An annotation for defining an object field in a JSON schema.
///
/// Extends [Field] with a type parameter of [Map<String, dynamic>].
class ObjectField extends Field<Map<String, dynamic>> {
  /// Creates a new [ObjectField] instance.
  const ObjectField({
    super.title,
    super.description,
    super.examples,
  });
}

/// An annotation for defining an enum field in a JSON schema.
///
/// Extends [Field] with a type parameter of [String].
class EnumField extends Field<String> {
  /// Creates a new [EnumField] instance.
  const EnumField({
    super.title,
    super.description,
    super.examples,
  });
}

/// An annotation for defining a date-time field in a JSON schema.
///
/// Extends [Field] with a type parameter of [String].
class DateTimeField extends Field<String> {
  /// Creates a new [DateTimeField] instance.
  const DateTimeField({
    super.title,
    super.description,
    super.examples,
  });
}

