@IsTest
private class SpanishDocumentValidationTest
{
    @IsTest
    static void test_isNUSSValid()
    {
        String valid1 = '281234567840';
        System.assertEquals(true, SpanishDocumentValidation.isNUSSValid(valid1), 'Expected valid SSN 1');

        String valid2 = '010000000182';
        System.assertEquals(true, SpanishDocumentValidation.isNUSSValid(valid2), 'Expected valid SSN 2');

        // Invalid: Empty
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid(''), 'Too short should be invalid');
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid(null), 'Too short should be invalid');
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid('   '), 'Too short should be invalid');
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid('            '), '12 spaces should be invalid');

        // Invalid: wrong length
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid('123'), 'Too short should be invalid');

        // Invalid: non-digits
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid('28A234567874'), 'Non-digit should be invalid');

        // Invalid: province 00
        // numeric control would compute but province 00 is not allowed
        String invalidProvince = '001234567801';
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid(invalidProvince), 'Province 00 should be invalid');

        // Invalid: wrong control digits for valid numeric part
        // Using valid1's numeric but alter control
        System.assertEquals(false, SpanishDocumentValidation.isNUSSValid('281234567800'), 'Wrong control should be invalid');
    }
    /**
     * Valid DNI samples that should pass the validator.
     * The DNI control letter equals 'TRWAGMYFPDXBNJZSQVHLCKE'[num % 23]
     */
    @IsTest
    static void testIsDNIValid_withValidSamples() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();
        // 12345678 % 23 = 14 => letter 'Z'
        System.assertEquals(true, svc.isDNIValid('12345678Z'), 'Expected valid DNI 12345678Z');
        // 00000000 % 23 = 0 => letter 'T'
        System.assertEquals(true, svc.isDNIValid('00000000T'), 'Expected valid DNI 00000000T');
        // 00000001 % 23 = 1 => letter 'R'
        System.assertEquals(true, svc.isDNIValid('00000001R'), 'Expected valid DNI 00000001R');
        // 00000002 % 23 = 2 => letter 'W'
        System.assertEquals(true, svc.isDNIValid('00000002W'), 'Expected valid DNI 00000002W');
        // Case-insensitive letter
        System.assertEquals(true, svc.isDNIValid('12345678z'), 'Expected lower-case letter to be accepted (auto upper-cased)');
    }

    /**
     * Inputs that should be rejected due to format, length, charset or checksum letter.
     */
    @IsTest
    static void testIsDNIValid_withInvalidSamples() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        // Blank / null / whitespace
        System.assertEquals(false, svc.isDNIValid(null), 'Null should be invalid');
        System.assertEquals(false, svc.isDNIValid(''), 'Empty should be invalid');
        System.assertEquals(false, svc.isDNIValid('   '), 'Whitespace should be invalid');
        System.assertEquals(false, svc.isDNIValid('         '), '9 Whitespace should be invalid');

        // Invalid length (not 9)
        System.assertEquals(false, svc.isDNIValid('1234567Z'), 'Length 8 should be invalid');
        System.assertEquals(false, svc.isDNIValid('123456789Z'), 'Length 10 should be invalid');

        // Non-numeric in numeric part
        System.assertEquals(false, svc.isDNIValid('1234A678Z'), 'Non-numeric in numeric part should be invalid');

        // Invalid final letter (checksum mismatch for numeric part 12345678 => expected Z, not A)
        System.assertEquals(false, svc.isDNIValid('12345678A'), 'Invalid checksum letter should be rejected');

        // Invalid ending character not a letter
        System.assertEquals(false, svc.isDNIValid('123456789'), 'Missing letter (all digits) should be invalid');

        // Leading/trailing spaces should not match strict regex
        System.assertEquals(false, svc.isDNIValid(' 12345678Z'), 'Leading space should be invalid');
        System.assertEquals(false, svc.isDNIValid('12345678Z '), 'Trailing space should be invalid');
    }

    /**
     * Edge cases around uppercasing and regex boundary.
     */
    @IsTest
    static void testIsDNIValid_edgeCases() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        // Lowercase letter should be accepted because implementation uppercases input first
        System.assertEquals(true, svc.isDNIValid('00000000t'), 'Lowercase T on valid numeric part should be accepted');

        // Mixed case in letter (already covered), ensure numbers padded are handled (regex requires exactly 8 digits)
        System.assertEquals(false, svc.isDNIValid('0123456Z'), 'Only 7 digits should be invalid');
        System.assertEquals(false, svc.isDNIValid('001234567Z'), '9 digits should be invalid');
    }

    /**
     * Valid NIE samples that should pass the validator.
     * Rules:
     *  - Format: ^[XYZ][0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKE]$
     *  - Control letter computed from numericPart (X->0, Y->1, Z->2) + 7 digits, mod 23 into 'TRWAGMYFPDXBNJZSQVHLCKE'
     */
    @IsTest
    static void testIsNIEValid_withValidSamples() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        // Helper mapping: index -> letter in "TRWAGMYFPDXBNJZSQVHLCKE"
        // We'll pick numbers where mod is easily verified by construction.

        // X0000000T: numeric 0, 0 % 23 = 0 -> T
        System.assertEquals(true, svc.isNIEValid('X0000000T'), 'Expected valid NIE X0000000T');

        // Y0000000Z: numeric 10000000, 10000000 % 23 = 14 -> Z
        System.assertEquals(true, svc.isNIEValid('Y0000000Z'), 'Expected valid NIE Y0000000Z');

        // Z0000000M: numeric 20000000, 20000000 % 23 = 5 -> M
        System.assertEquals(true, svc.isNIEValid('Z0000000M'), 'Expected valid NIE Z0000000M');

        // Otro válido con cálculo explícito:
        // numericPart = 0 + 1234567 = 1234567; 1234567 % 23 = 19 -> 'L'
        System.assertEquals(true, svc.isNIEValid('X1234567l'), 'Lowercase control letter should be accepted (auto uppercased)');
    }

    /**
     * Invalid NIE samples due to format, content or checksum.
     */
    @IsTest
    static void testIsNIEValid_withInvalidSamples() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        // Blank / null / whitespace
        System.assertEquals(false, svc.isNIEValid(null), 'Null should be invalid');
        System.assertEquals(false, svc.isNIEValid(''), 'Empty should be invalid');
        System.assertEquals(false, svc.isNIEValid('   '), 'Whitespace should be invalid');
        System.assertEquals(false, svc.isNIEValid('         '), '9 Whitespace should be invalid');

        // Invalid length
        System.assertEquals(false, svc.isNIEValid('X123456Z'), 'Only 8 chars should be invalid');
        System.assertEquals(false, svc.isNIEValid('X12345678ZZ'), 'Length 11 should be invalid');

        // Wrong prefix (must be X/Y/Z uppercase after uppercasing)
        System.assertEquals(false, svc.isNIEValid('A1234567T'), 'Prefix not X/Y/Z should be invalid');
        System.assertEquals(false, svc.isNIEValid('x123456t'), 'Too short (missing one digit) should be invalid even if prefix lowercased');

        // Non-digit in numeric zone
        System.assertEquals(false, svc.isNIEValid('X12345A7T'), 'Non-digit in numeric part should be invalid');

        // Invalid checksum letter for a known numeric mapping
        // For X0000000 expected T, provide A
        System.assertEquals(false, svc.isNIEValid('X0000000A'), 'Checksum mismatch should be invalid');

        // All digits (missing trailing letter)
        System.assertEquals(false, svc.isNIEValid('X12345678'), 'Missing letter should be invalid');

        // Leading/trailing spaces
        System.assertEquals(false, svc.isNIEValid(' X0000000T'), 'Leading space should be invalid');
        System.assertEquals(false, svc.isNIEValid('X0000000T '), 'Trailing space should be invalid');
    }

    /**
     * Bulk and edge cases for NIE.
     */
    @IsTest
    static void testIsNIEValid_bulkAndEdgeCases() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        // Bulk valid samples
        List<String> validNIEs = new List<String>{
            'X0000000T', // 0 % 23 = 0 -> T
            'Y0000000Z', // 10000000 % 23 = 14 -> Z
            'Z0000000M'  // 20000000 % 23 = 5 -> M
        };
        for (String nie : validNIEs) {
            System.assertEquals(true, svc.isNIEValid(nie), 'Valid NIE should pass: ' + nie);
        }

        // Bulk invalid samples
        List<String> invalidNIEs = new List<String>{
            'X1234567A', // wrong checksum
            'B1234567T', // wrong prefix
            'X1234567',  // missing letter
            'X12345678', // 8 digits after X, wrong format
            'X12345A7T'  // non-digit
        };
        for (String nie : invalidNIEs) {
            System.assertEquals(false, svc.isNIEValid(nie), 'Invalid NIE should fail: ' + String.valueOf(nie));
        }
    }

    /**
     * CIF validation tests based on implementation in SpanishDocumentValidation.isCIFValid:
     * - Format: ^[ABCDEFGHJKLMNPQRSUVW][0-9]{7}[0-9A-J]$
     * - Control:
     *   * initial A,B,E,H => numeric control (digitControl)
     *   * initial K,P,Q,S,N,W => letter control (lettersMap[digitControl], lettersMap='JABCDEFGHI')
     *   * others accept either the digit or its letter equivalent
     */
    @IsTest
    static void testIsCIFValid_withValidSamples() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        // Helper to ensure coverage across control types:

        // Tipo que requiere control numérico
        System.assertEquals(true, svc.isCIFValid('A58818501'), 'Expected valid CIF A58818501 (numeric control)'); // Telefónica
        System.assertEquals(true, svc.isCIFValid('B99286320'), 'Expected valid CIF B99286320 (numeric control)'); // Aragón Open Data
        System.assertEquals(true, svc.isCIFValid('E12345674'), 'Expected valid CIF E12345674 (numeric control)');
        System.assertEquals(true, svc.isCIFValid('H12345674'), 'Expected valid CIF H12345674 (numeric control)');

        // Tipo que requiere control letra (K,P,Q,S,N,W)
        System.assertEquals(true, svc.isCIFValid('Q5000000I'), 'Expected valid CIF Q5000000I (letter control)'); // corregido, control letra calculado
        System.assertEquals(true, svc.isCIFValid('P2345670J'), 'Expected valid CIF P2345670J (letter control)'); // ejemplo correcto
        System.assertEquals(true, svc.isCIFValid('S1234567D'), 'Expected valid CIF S1234567D (letter control)'); // control recalculado
        System.assertEquals(true, svc.isCIFValid('N2345678C'), 'Expected valid CIF N2345678C (letter control)'); // control recalculado

        // Tipo que acepta control numérico o letra (C,D,F,G,J,L,M,R,U,V)
        System.assertEquals(true, svc.isCIFValid('C46908521'), 'Expected valid CIF C46908521 (either control type set)');
        System.assertEquals(true, svc.isCIFValid('D87654323'), 'Expected valid CIF D87654323 (either control type set)'); // control recalculado
        System.assertEquals(true, svc.isCIFValid('F98765431'), 'Expected valid CIF F98765431 (either control type set)'); // control recalculado
        System.assertEquals(true, svc.isCIFValid('L12345674'), 'Expected valid CIF L12345674 (either control type set)'); // control recalculado

        // Otros casos válidos
        System.assertEquals(true, svc.isCIFValid('J12345674'), 'Expected valid CIF J12345674 (numeric control)'); // control recalculado
        System.assertEquals(true, svc.isCIFValid('R12345674'), 'Expected valid CIF R12345674 (either control type set)'); // control recalculado

    }

    @IsTest
    static void testIsCIFValid_withInvalidSamples() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        // Blank / null / whitespace / wrong length
        System.assertEquals(false, svc.isCIFValid(null), 'Null should be invalid');
        System.assertEquals(false, svc.isCIFValid(''), 'Empty should be invalid');
        System.assertEquals(false, svc.isCIFValid('   '), 'Whitespace should be invalid');
        System.assertEquals(false, svc.isCIFValid('A1234567'), 'Length 8 should be invalid');
        System.assertEquals(false, svc.isCIFValid('A123456789'), 'Length 10 should be invalid');

        // Wrong initial letter (not in allowed set)
        System.assertEquals(false, svc.isCIFValid('Z1234567L'), 'Initial Z is not allowed');

        // Non-digit in middle 7 digits
        System.assertEquals(false, svc.isCIFValid('A12A4567L'), 'Non-digit in numeric part should be invalid');

        // Wrong last char type/charset
        System.assertEquals(false, svc.isCIFValid('A1234567K'), 'Last letter K is outside A-J range');
        System.assertEquals(false, svc.isCIFValid('A1234567-'), 'Last char must be digit or A-J');

        // Checksum mismatch for numeric-control required types (e.g., A)
        // Tweak last digit to break checksum on a known-good numeric-control CIF
        System.assertEquals(false, svc.isCIFValid('A58818502'), 'Checksum mismatch should be invalid for numeric-control CIF');

        // Checksum mismatch for letter-control required types (e.g., Q)
        System.assertEquals(false, svc.isCIFValid('Q5000000A'), 'Checksum mismatch should be invalid for letter-control CIF');

        // Leading/trailing spaces should be rejected (trimmed, but regex requires exact format)
        System.assertEquals(false, svc.isCIFValid(' A58818501'), 'Leading space invalid');
        System.assertEquals(false, svc.isCIFValid('A58818501 '), 'Trailing space invalid');
    }

    @IsTest
    static void testIsCIFValid_bulk() {
        SpanishDocumentValidation svc = new SpanishDocumentValidation();

        List<String> valid = new List<String>{
            'A58818501',
            'Q5000000I',
            'C46908521'
        };
        for (String cif : valid) {
            System.assertEquals(true, svc.isCIFValid(cif), 'Expected valid CIF: ' + cif);
        }

        List<String> invalid = new List<String>{
            'A58818502', // checksum mismatch
            'Z1234567L', // invalid initial letter
            'A12A4567L', // non-digit in digits block
            'A1234567K', // last letter out of allowed range
            'A1234567-', // invalid last character
            'A1234567',  // too short
            'A123456789' // too long
        };
        for (String cif : invalid) {
            System.assertEquals(false, svc.isCIFValid(cif), 'Expected invalid CIF: ' + String.valueOf(cif));
        }
    }
}
