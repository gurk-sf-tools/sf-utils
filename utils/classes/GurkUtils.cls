public with sharing class GurkUtils
{
    private static DocumentUtils documents_instance;

    public static DocumentUtils Documents
    {
        get
        {
            if ( documents_instance == null)
            {
                documents_instance = new DocumentUtils();
            }
            return documents_instance;
        }
        private set;
    }
}