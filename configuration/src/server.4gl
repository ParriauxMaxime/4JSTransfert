IMPORT os

FUNCTION getServerURL() 
    DEFINE t TEXT
    DEFINE str STRING
    
    LOCATE t IN MEMORY
    CALL t.readFile('../../shared/server')
    LET str = t
    DISPLAY str.subString(1, str.getLength() - 1)
    RETURN str.subString(1, str.getLength() - 1);
END FUNCTION

FUNCTION getGasURL() 
    DEFINE t TEXT
    DEFINE str STRING

    LOCATE t IN MEMORY
    CALL t.readFile('../../shared/gas')
    LET str = t
    DISPLAY str.subString(1, str.getLength() - 1)
    RETURN str.subString(1, str.getLength() - 1);
END FUNCTION