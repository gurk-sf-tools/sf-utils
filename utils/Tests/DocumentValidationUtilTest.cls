@IsTest
private class DocumentValidationUtilTest {
    /**
     * Tests the local method isEmailValid in DocumentValidationUtil.
     * Focus only on local functionality (no locale-dependent methods).
     */
    @IsTest
    static void test_isEmailValid_validSamples() {
        DocumentValidationUtil util = new DocumentValidationUtil();

        // Basic valid emails
        System.assertEquals(true, util.isEmailValid('user@example.com'), 'Expected valid email');
        System.assertEquals(true, util.isEmailValid('USER@EXAMPLE.COM'), 'Uppercase should be accepted (lowercased internally)');
        System.assertEquals(true, util.isEmailValid('user.name+tag@sub.domain.co'), 'Dots, plus, subdomain should be accepted');
        System.assertEquals(true, util.isEmailValid(' a.b-c_d+1@sub.domain.io '), 'Trim should be applied before validation');
    }

    @IsTest
    static void test_isEmailValid_invalidSamples() {
        DocumentValidationUtil util = new DocumentValidationUtil();

        // Null/blank
        System.assertEquals(false, util.isEmailValid(null), 'Null should be invalid');
        System.assertEquals(false, util.isEmailValid(''), 'Empty should be invalid');
        System.assertEquals(false, util.isEmailValid('   '), 'Whitespace should be invalid');

        // Missing parts
        System.assertEquals(false, util.isEmailValid('plainaddress'), 'Missing @ and domain should be invalid');
        System.assertEquals(false, util.isEmailValid('user@'), 'Missing domain should be invalid');
        System.assertEquals(false, util.isEmailValid('@domain.com'), 'Missing local part should be invalid');
        System.assertEquals(false, util.isEmailValid('user@domain'), 'Missing TLD dot should be invalid');

        // Spaces or invalid characters
        System.assertEquals(false, util.isEmailValid('user name@domain.com'), 'Space in local part should be invalid');
        System.assertEquals(false, util.isEmailValid('user@domain .com'), 'Space in domain should be invalid');

        // Length over 254 (enforced in method)
        String longLocal = String.valueOf('a').repeat(200);
        String longDomain = String.valueOf('b').repeat(60) + '.com';
        String tooLongEmail = longLocal + '@' + longDomain; // > 254
        System.assertEquals(false, util.isEmailValid(tooLongEmail), 'Emails longer than 254 chars should be invalid');
    }

    /**
     * Guard: accessing Locale and Spain properties should not affect email validation.
     * Verifies lazy initialization pattern works and does not throw.
     * Only ensures the getters are callable; does not test Spain-specific validators here.
     */
    @IsTest
    static void test_locale_getters_noSideEffects() {
        DocumentValidationUtil util = new DocumentValidationUtil();

        // Access nested getters to ensure lazy init does not throw
        DocumentValidationUtil.LocaleValidation localeAccessor = util.Locale;
        System.assertNotEquals(null, localeAccessor, 'Locale accessor should be initialized');

        // Access Spain instance (do not call its methods here to keep scope within "local methods only" request)
        SpanishDocumentValidation spain = localeAccessor.Spain;
        System.assertNotEquals(null, spain, 'Spain instance should be lazily initialized');

        // Ensure local email validation still works after accessing nested properties
        System.assertEquals(true, util.isEmailValid('user@test.io'), 'Email validation should remain functional');
    }
}
