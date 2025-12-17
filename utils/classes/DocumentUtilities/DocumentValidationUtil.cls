public with sharing class DocumentValidationUtil
{
    private static SpanishDocumentValidation spain_instance;

    public LocaleValidation Locale
    {
        get
        {
            if ( Locale == null)
            {
                Locale = new LocaleValidation();
            }
            return Locale;
        }
        private set;
    }

    public class LocaleValidation
    {
        private LocaleValidation(){}
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
        if (String.isEmpty(email))
        {
            return false;
        }

        email = email.trim().toLowerCase();

        if(email.length() > 254)
        {
            return false;
        }

        return Pattern.matches('^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$', email);
    }

}
