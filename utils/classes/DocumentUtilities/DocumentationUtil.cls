public with sharing class DocumentationUtil
{
    private static DocumentValidationUtil validation_instance;
    private static DocumentGenerationUtil generation_instance;

    public DocumentValidationUtil Validation
    {
        get
        {
            if ( validation_instance == null)
            {
                validation_instance = new DocumentValidationUtil();
            }
            return validation_instance;
        }
        private set;
    }

    public DocumentGenerationUtil Generator
    {
        get
        {
            if ( generation_instance == null)
            {
                generation_instance = new DocumentGenerationUtil();
            }
            return generation_instance;
        }
        private set;
    }
}