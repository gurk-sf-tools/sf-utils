public with sharing class Utils
{
    private static DocumentationUtil documentation_instance;

    public static DocumentationUtil Documentation
    {
        get
        {
            if ( documentation_instance == null)
            {
                documentation_instance = new DocumentationUtil();
            }
            return documentation_instance;
        }
        private set;
    }
}