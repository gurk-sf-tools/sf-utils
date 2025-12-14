public with sharing class GurkUtils
{
    private static DocumentationUtil documents_instance;

    public static DocumentationUtil Documents
    {
        get
        {
            if ( documents_instance == null)
            {
                documents_instance = new DocumentationUtil();
            }
            return documents_instance;
        }
        private set;
    }
}