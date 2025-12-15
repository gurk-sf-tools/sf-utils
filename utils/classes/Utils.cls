public with sharing class Utils
{
    private static DocumentationUtil documentations_instance;

    public static DocumentationUtil Documentations
    {
        get
        {
            if ( documentations_instance == null)
            {
                documentations_instance = new DocumentationUtil();
            }
            return documentations_instance;
        }
        private set;
    }
}