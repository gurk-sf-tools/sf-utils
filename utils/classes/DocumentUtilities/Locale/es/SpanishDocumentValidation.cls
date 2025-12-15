/**
 * SpanishDocumentValidation
 * Utility for validating Spanish document numbers.
 */
public with sharing class SpanishDocumentValidation
{
    public Boolean isDNIValid(String dni)
    {
        if (String.isEmpty(dni) || dni.length() != 9)
        {
            return false;
        }

        dni = dni.trim().toUpperCase();

        if ( ! Pattern.matches('[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKE]$', dni))
        {
			return false;
		}

		String numericPart = dni.substring(0, 8);
		String letter = dni.substring(8);

        Integer numericPartNumber = Integer.valueOf(numericPart);

		if ( ! isValidLetterForDocument(numericPartNumber, letter))
        {
			return false;
		}

        return true;
    }

    public Boolean isNIEValid(String nie)
    {
        if( String.isEmpty(nie) || nie.length() != 9)
        {
            return false;
        }

        nie = nie.trim().toUpperCase();

		if ( ! Pattern.matches('^[XYZ][0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKE]$', nie))
        {
			return false;
		}

		String prefix = nie.substring(0, 1);

        // Se coge la parte numérica sin letras
        String numberPart = nie.substring(1, 8);
		String numericPart;

        switch on prefix
        {
            when 'X'
            {
                numericPart = '0' + numberPart;
            }
            when 'Y'
            {
                numericPart = '1' + numberPart;
            }
            when 'Z'
            {
                numericPart = '2' + numberPart;
            }
            when else
            {
                return false;
            }
        }

		String letter = nie.substring(8);
        Integer numericPartNumber = Integer.valueOf(numericPart);

		if ( ! isValidLetterForDocument(numericPartNumber, letter))
        {
			return false;
		}

        return true;
    }

    public Boolean isCIFValid(String cif)
    {
        if (String.isBlank(cif) || cif.length() != 9)
        {
            return false;
        }

        cif = cif.trim().toUpperCase();

        // Formato básico: letra + 7 números + dígito/letra
        if ( ! Pattern.matches('^[ABCDEFGHJKLMNPQRSUVW][0-9]{7}[0-9A-J]$', cif))
        {
            return false;
        }

        String initialLetter = cif.substring(0,1);
        String digits = cif.substring(1,8);
        String controlChar = cif.substring(8,9);

        // Suma de pares
        Integer sumEven = 0;
        for (Integer i = 1; i < digits.length(); i += 2)
        {
            sumEven += Integer.valueOf(digits.substring(i, i+1));
        }

        // Suma de impares
        Integer sumOdd = 0;
        for (Integer i = 0; i < digits.length(); i += 2)
        {
            Integer val = Integer.valueOf(digits.substring(i, i+1)) * 2;
            sumOdd += (val / 10) + Math.mod(val, 10);
        }

        Integer total = sumEven + sumOdd;
        Integer digitControl = Math.mod(10 - Math.mod(total, 10), 10);

        // Según tipo de empresa, control puede ser letra o número
        String lettersMap = 'JABCDEFGHI'; // 0→J,1→A,...,9→I
        String expectedControl;

        // Letras que usan número siempre como control
        Set<String> numberControlLetters = new Set<String>{'A','B','E','H'};
        // Letras que usan letra siempre
        Set<String> letterControlLetters = new Set<String>{'K','P','Q','S','N','W'};
        // Resto pueden ser número o letra
        if (numberControlLetters.contains(initialLetter))
        {
            expectedControl = String.valueOf(digitControl);
        }
        else if (letterControlLetters.contains(initialLetter))
        {
            expectedControl = lettersMap.substring(digitControl, digitControl+1);
        }
        else
        {
            expectedControl = String.valueOf(digitControl);
            String letterEquivalent = lettersMap.substring(digitControl,digitControl+1);
            // acepta número o letra
            if (controlChar == letterEquivalent)
            {
                return true;
            }
        }

        Boolean isValidationCorrect = controlChar == expectedControl;

        return isValidationCorrect;
    }

    private static Boolean isValidLetterForDocument(Integer numericPart, String letter)
    {
        String letters = 'TRWAGMYFPDXBNJZSQVHLCKE';
		Integer remainder = Math.mod(numericPart, 23);

        return letters.substring(remainder, remainder + 1) == letter;
    }

}
