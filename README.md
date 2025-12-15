# Utilities Folder

This folder contains utility classes for the Salesforce project, separate from the main `force-app` structure. It is deployable independently as its own package directory.

## Structure

- Utils.cls — Main facade entry point (GurkUtils) to access sub-modules
- DocumentUtilities/
  - DocumentationUtil.cls — Helpers to produce human-readable documentation messages
  - DocumentGenerationUtil.cls — Random/valid Spanish document number generators (DNI/NIE/CIF)
  - DocumentValidationUtil.cls — Validation helpers and orchestration
  - Locale/es/
    - SpanishDocumentGenerator.cls — Spain-specific document number generators
    - SpanishDocumentValidation.cls — Spain-specific validators (DNI/NIE/CIF)
- Tests/
  - SpanishDocumentValidationTest.cls — Unit tests for Spain validators

## Usage (Apex)

Use the actual classes and properties provided by the codebase:

```apex
// Root facade
Utils.Documentation;

// Validation access
Utils.Documentation.Validation;

// Spain-specific validators
Utils.Documentation.Validation.Locale.Spain;

// Validate DNI
Boolean isValidDni = Utils.Documentation.Validation.Locale.Spain.isDNIValid('12345678Z');

// Validate NIE
Boolean isValidNie = Utils.Documentation.Validation.Locale.Spain.isNIEValid('X1234567Z');

// Validate CIF
Boolean isValidCif = Utils.Documentation.Validation.Locale.Spain.isCIFValid('A12345678');

// Generators access
Utils.Documentation.Generation;
Utils.Documentation.Generation.Locale.Spain;

// Generate DNI
String dni = Utils.Documentation.Generation.Locale.Spain.generateDNI();

// Generate NIE
String nie = Utils.Documentation.Generation.Locale.Spain.generateNIE();

// Generate CIF
String cif = Utils.Documentation.Generation.Locale.Spain.generateCIF();
```

## Quick Start

- Login to target org:
  - `sf org login web`
- Deploy only this utils package directory:
  - `sf project deploy start --source-dir utils`
- Run tests:
  - `sf apex run test --tests SpanishDocumentValidationTest`

Notes:

- Always use `sf` CLI (not `sfdx`).
- This `utils` directory can be deployed independently from `force-app`.

## Project Configuration

Ensure `sfdx-project.json` includes the `utils` package directory:

```json
{
  "path": "utils",
  "default": false
}
```
