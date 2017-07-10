IMPORT util
IMPORT FGL REST
GLOBALS 'global.4gl'

--fglcomp --java-option=-Xss2m <module> (SEGV Java fix)

FUNCTION validateDataType(URL STRING, rec httpRecord)
    DEFINE result STRING
    DEFINE recDisconnected httpRecord;
    
    CALL PostValidationRequest(URL||"/validation", rec.*) RETURNING result
    IF result IS NULL THEN
        RETURN TRUE
    ELSE
        IF result == "Connection Failed, check your network" THEN
            ERROR result
            CALL initiaterequest(URL, rec.*) RETURNING recDisconnected.*
        ELSE
            DISPLAY result;
            ERROR result||' are invalid input'
            RETURN FALSE
        END IF
    END IF
END FUNCTION


