# Utilities Folder

This folder contains utility classes for the Salesforce project, separate from the main force-app structure.

## Structure

- **GurkUtils.cls** - Main utility class that provides access to other utility classes
- **DocumentUtils.cls** - Utility class for document-related operations
- **DocumentValidationUtil.cls** - Utility class for document validation operations
- **DocumentGenerationUtil.cls** - Utility class for document generation operations
- **SpanishDocumentGenerator.cls** - Specific generator utilities for Spanish documents

## Usage

Access the utilities using the following patterns:

```apex
// Access DocumentUtils
GurkUtils.Documents;

// Access DocumentValidationUtil
GurkUtils.Documents.validation;

// Access SpanishDocumentValidation
GurkUtils.Documents.validation.Spain;

// Validate DNI
Boolean isValid = GurkUtils.Documents.validation.Spain.isDNIValid('12345678Z');

// Validate NIE
Boolean isValid = GurkUtils.Documents.validation.Spain.isNIEValid('X1234567Z');

// Validate CIF
Boolean isValid = GurkUtils.Documents.validation.Spain.isCIFValid('A12345678');

// Access DocumentGenerationUtil
GurkUtils.Documents.generator;

// Access SpanishDocumentGenerator
GurkUtils.Documents.generator.Spain;

// Generate DNI
String dni = GurkUtils.Documents.generator.Spain.generateDNI();

// Generate NIE
String nie = GurkUtils.Documents.generator.Spain.generateNIE();

// Generate CIF
String cif = GurkUtils.Documents.generator.Spain.generateCIF();
```

## Project Configuration

This directory is configured as a separate package directory in `sfdx-project.json`, allowing it to be deployed independently from the main force-app directory.
Add the following code into the sfdx-project.json file in the projects packageDirectories list section:

{
"path": "utils",
"default": false
}
