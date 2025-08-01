/// Annotation utilities for the dart_json_schema package.
///
/// This library provides utility functions for working with @Field annotations
/// in Dart models for JSON schema generation.

import 'field.dart';

/// The Field annotation class for adding metadata to model fields.
export 'field.dart';

/// Checks if a field has the `@Field` annotation.
///
/// This function is used by the schema generator to identify which fields
/// should be included in the JSON schema with their metadata.
bool hasFieldAnnotation(/* Annotation metadata */) {
  // In the context of static analysis, this check is performed by the
  // JsonSchemaGenerator when parsing the AST.
  // This function is provided for consistency but is not used in the
  // current implementation.
  return false;
}

/// Gets the Field annotation from a field's metadata.
///
/// This function would extract the Field annotation values during static analysis.
/// In the current implementation, this is handled directly by the generator.
Field? getFieldAnnotation(/* Annotation metadata */) {
  // This is handled by the JsonSchemaGenerator during AST parsing.
  return null;
}
