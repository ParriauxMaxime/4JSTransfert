IMPORT com
IMPORT util
IMPORT os
GLOBALS 'global.4gl'

FUNCTION POSTTextRequest(url STRING, rec httpRecord)
    DEFINE  req com.HttpRequest,
            res com.HttpResponse,
            doc STRING;

            LET req = com.HttpRequest.Create(url);
            CALL req.setMethod("POST");
            TRY
                CALL req.doTextRequest(util.JSON.stringify(rec));
                LET res = req.getResponse()
                IF res.getStatusCode() != 200 AND res.getStatusCode() != 201 THEN
                    DISPLAY  "HTTP Error ("||res.getStatusCode()||") ";
                    LET doc = NULL;
                ELSE
                    LET doc = res.getTextResponse()
                END IF
            CATCH
                ERROR 'Connection Failed, check your network'
                RETURN NULL
            END TRY
            RETURN doc;
END FUNCTION

FUNCTION POSTValidationRequest(url STRING, rec httpRecord)
    DEFINE  req com.HttpRequest,
            res com.HttpResponse;
    DEFINE tmp STRING;
    
        LET req = com.HttpRequest.Create(url);
        CALL req.setMethod("POST");
        TRY
            CALL req.doTextRequest(util.JSON.stringify(rec));
            LET res = req.getResponse()
            IF res.getStatusCode() == 200 THEN
                RETURN NULL
            ELSE
                LET tmp = res.getTextResponse();
                DISPLAY tmp
                RETURN tmp
            END IF
        CATCH
            RETURN 'Connection Failed, check your network'
        END TRY
END FUNCTION

FUNCTION POSTZipRequest(url STRING, filepath STRING)
    DEFINE req com.HttpRequest,
            res com.HttpResponse,
            doc STRING

            LET req = com.HttpRequest.Create(url)
            CALL req.setMethod('POST')
            TRY
                CALL req.doFileRequest(filepath)
                LET res = req.getResponse()
                IF res.getStatusCode() != 200 THEN
                    DISPLAY "HTTP Error (" || res.getStatusCode() || ")";
                    LET doc = NULL
                ELSE
                    LET doc = res.getTextResponse()
                END IF
            CATCH
                ERROR 'Connection Failed, check your network'
            END TRY
            RETURN doc
END FUNCTION

FUNCTION POSTTokenRequest(url STRING)
    DEFINE token STRING;
    DEFINE tmp STRING;
    DEFINE rec httpRecord;

    LET tmp = url,'/token'
    CALL POSTTextRequest(tmp, rec.*) RETURNING token;
    RETURN token;
END FUNCTION

-- Check if node server is launched.
FUNCTION initiateRequest(URL STRING, rec httpRecord)
    DEFINE bool     BOOLEAN;

    LABEL _entryPoint:
    CALL POSTTokenRequest(URL) RETURNING rec.Token;
    IF rec.Token IS NULL THEN
        ERROR 'Server disconnected'
        SLEEP 1;
        MENU
            ON ACTION reconnect ATTRIBUTES(TEXT="Reconnect")
                GOTO _entryPoint;
            ON ACTION EXIT
                EXIT PROGRAM
        END MENU
    ELSE
        LET bool = os.Path.exists('./resources');
        IF bool == FALSE THEN
            LET bool = os.Path.mkdir('../resources');
        END IF
        LET bool = os.Path.mkdir('../resources/'||rec.Token);
        IF bool == FALSE THEN
            ERROR 'ERROR while creating directory'
        END IF
        MESSAGE 'Server connected.';
    END IF
    RETURN rec.*;
END FUNCTION
