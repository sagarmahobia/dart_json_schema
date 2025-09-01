
## 2.1.0

### New Features
- **Configuration-Based Schema Generation**: Added support for specifying files to be treated as if they have the `@JsonSchema` annotation through a configuration file (`dart_json_schema.yaml`). This allows generating schemas for all public fields in classes without requiring any annotations.
- **Pattern Matching**: Configuration supports glob patterns for including/excluding files (e.g., `lib/models/**/*.dart`)

### Improvements
- **Enhanced CLI**: Added `-c/--config` option to specify configuration file path
- **Backward Compatibility**: Existing annotation-based approach continues to work unchanged

## 2.0.0

- **Breaking Change**: Simplified to single Field annotation without generics
- Removed all typed field annotations (IntField, StringField, etc.)
- Field annotation now has only three properties: title, description, and examples

## 1.0.1

- Fixed repository URLs in documentation
- Improved README with clearer examples

## 1.0.0

- Initial release with typed field annotations
- Support for primitive types (String, int, double, bool)
- Support for complex types (List, custom objects)
- Support for optional and required fields
- Build runner integration
