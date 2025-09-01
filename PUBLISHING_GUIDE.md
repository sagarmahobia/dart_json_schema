# Publishing Guide for dart_json_schema Packages

This guide explains how to publish both `dart_json_schema` and `dart_json_schema_annotations` packages to pub.dev.

## Package Structure

This repository contains two packages:
1. `dart_json_schema_annotations` - Annotations library (published first)
2. `dart_json_schema` - Main package with CLI tool and generator (published second)

## Publishing Process

Since `dart_json_schema` depends on `dart_json_schema_annotations`, packages must be published in order:

### 1. Publish dart_json_schema_annotations First

```bash
cd dart_json_schema_annotations
dart pub publish
```

### 2. Update and Publish dart_json_schema

After the annotations package is published:

1. Update the version dependency in `dart_json_schema/pubspec.yaml`:
   ```yaml
   dependencies:
     dart_json_schema_annotations: ^NEW_VERSION
   ```

2. Publish the main package:
   ```bash
   cd ..
   dart pub publish
   ```

## Local Development

During development, use path dependencies for easier testing:

In `dart_json_schema/pubspec.yaml`:
```yaml
dependencies:
  dart_json_schema_annotations:
    path: ./dart_json_schema_annotations
```

**Important**: Switch back to version dependencies before publishing:
```yaml
dependencies:
  dart_json_schema_annotations: ^1.0.0  # Latest published version
```

## Pre-Publishing Checklist

Before publishing, ensure:

1. All code changes are committed to git
2. CHANGELOG.md is updated with release notes
3. Version numbers are correct in pubspec.yaml
4. All tests pass: `dart test`
5. Code analysis passes: `dart analyze`
6. Dry-run publish works: `dart pub publish --dry-run`

## Automated Publishing Script

You can use this script to automate the process:

```bash
#!/bin/bash
# publish_both.sh

echo "Publishing dart_json_schema_annotations..."
cd dart_json_schema_annotations
dart pub publish

echo "Publishing dart_json_schema..."
cd ..
dart pub publish
```

Note: You'll still need to manually update version dependencies between publishes if both packages have changes.

## Version Management

When making changes:
- Minor/patch changes to annotations: Update only `dart_json_schema_annotations`
- Breaking changes to annotations: Update both packages and their version dependencies
- Changes to main package only: Update only `dart_json_schema`

Always follow semantic versioning (SemVer) guidelines.