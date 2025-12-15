public with sharing class DocumentValidationUtil
{
    private static SpanishDocumentValidation spain_instance;

    public LocaleValidations Locale
    {
        get
        {
            if ( Locale == null)
            {
                Locale = new LocaleValidations();
            }
            return Locale;
        }
        private set;
    }

    public class LocaleValidations
    {
        private LocaleValidations(){}
        public SpanishDocumentValidation Spain
        {
            get
            {
                if ( spain_instance == null)
                {
                    spain_instance = new SpanishDocumentValidation();
                }
                return spain_instance;
            }
            private set;
        }
    }

    public Boolean isEmailValid(String email)
    {
        return true;
    }

}
