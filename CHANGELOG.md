
## 0.0.4

### Repository & Documentation Updates
- **Fixed GitHub repository URL** - Updated homepage and repository URLs in pubspec.yaml to point to correct GitHub repository
- **Enhanced CHANGELOG.md** - Added comprehensive release notes with detailed migration guide and breaking changes documentation
- **Improved documentation clarity** - Updated README.md and CHANGELOG.md for better developer experience

## 0.0.3

### Major Changes
- **Complete migration to typed field annotations system** - Replaced generic `@Field` annotation with type-specific annotations for better type safety and validation
- **Added comprehensive typed field annotations**:
  - `@IntField` - Integer fields with min/max validation
  - `@StringField` - String fields with min/max length validation
  - `@DoubleField` - Double/float fields with min/max validation
  - `@BooleanField` - Boolean fields
  - `@ListField` - List/array fields with item type specification
  - `@ObjectField` - Object fields with nested schema support
  - `@EnumField` - Enum fields with value validation
  - `@DateTimeField` - DateTime fields with format validation

### Improvements
- **Enhanced JSON schema generator** - Updated to properly handle new typed annotations and generate more accurate schemas
- **Added build_runner support** - Full integration with Dart's build system for automatic code generation
- **Improved type safety** - Strong typing throughout the annotation system prevents runtime errors
- **Better validation** - More precise validation rules based on field types
- **Updated documentation** - Comprehensive README with detailed examples and migration guide

### Breaking Changes
- **Generic `@Field` annotation is now deprecated** - Use type-specific annotations instead
- **Schema generation API updated** - New generator handles typed annotations natively

### Migration Guide
- Replace `@Field()` with appropriate typed annotation (e.g., `@StringField()`, `@IntField()`)
- Update field types to match annotation types for better validation
- No changes required in existing model class structure

## 0.0.2

- Initial release.
