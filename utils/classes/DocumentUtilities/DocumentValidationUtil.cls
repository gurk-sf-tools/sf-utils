public with sharing class DocumentValidationUtil
{
    private static SpanishDocumentValidation spain_instance;
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

    public Boolean isEmailValid(String email)
    {
        return true;
    }

}
