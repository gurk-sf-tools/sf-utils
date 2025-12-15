public with sharing class DocumentGenerationUtil
{
    private static SpanishDocumentGenerator spain_instance;

    public LocaleGeneration Locale
    {
        get
        {
            if ( Locale == null)
            {
                Locale = new LocaleGeneration();
            }
            return Locale;
        }
        private set;
    }

    public class LocaleGeneration
    {
        private LocaleGeneration(){}
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



}