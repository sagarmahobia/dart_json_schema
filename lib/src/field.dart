
/// An annotation to add metadata to model fields for JSON schema generation.
class Field {
  /// A human-readable title for the field.
  final String? title;

  /// A description of the field.
  final String? description;

  /// A list of example values for the field.
  final List<dynamic>? examples;

  /// Creates a new [Field] annotation.
  const Field({
    this.title,
    this.description,
    this.examples,
  });
}
