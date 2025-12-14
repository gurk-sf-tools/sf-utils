public with sharing class DocumentGenerationUtil
{
    private static SpanishDocumentGenerator spain_instance;

    public SpanishDocumentGenerator Spain
    {
        get
        {
            if ( spain_instance == null)
            {
                spain_instance = new SpanishDocumentGenerator();
            }
            return spain_instance;
        }
        private set;
    }
}