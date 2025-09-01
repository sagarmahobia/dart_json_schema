/// A simple annotation for defining JSON schema properties.
///
/// This class provides common properties for defining JSON schema fields,
/// such as [title], [description], and [examples].
class Field {
  /// A short, human-readable title for the field.
  final String? title;

  /// A longer description of the field's purpose or usage.
  final String? description;

  /// A list of example values for the field.
  final List<dynamic>? examples;

  /// Creates a new [Field] instance.
  const Field({
    this.title,
    this.description,
    this.examples,
  });
}
