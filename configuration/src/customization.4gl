IMPORT com
IMPORT os
IMPORT util

GLOBALS "global.4gl"

FUNCTION buildCustomization(URL STRING, rec httpRecord)
    DEFINE result STRING;
    MESSAGE 'build initiated'
    CALL POSTTextRequest(URL||'/build', rec.*) RETURNING result;
    IF result IS NULL THEN
    END IF
    MESSAGE 'build terminated';
    RETURN result
END FUNCTION

FUNCTION downloadCustomization(URL STRING, rec httpRecord)
    DEFINE  customName STRING,
            req com.HttpRequest,
            res com.HttpResponse,
            doc STRING;
    LET customName = SFMT('%1-%2', rec.Overview.config_name, rec.Token);
    LET req = com.HttpRequest.Create(URL||'/download')
    CALL req.setMethod('POST')
    TRY
        CALL req.doTextRequest(customName);
        LET res = req.getResponse()
        IF res.getStatusCode() != 200 THEN
            DISPLAY "HTTP Error (" || res.getStatusCode() || ")";
            LET doc = NULL
        ELSE
            LET doc = res.getFileResponse()
            DISPLAY doc;
            CALL fgl_putfile(doc, '/home');
        END IF
    CATCH
        ERROR 'Connection Failed, check your network'
    END TRY
END FUNCTION

FUNCTION importCustomization(URL, rec, combobox)
    DEFINE  recOpenFile    RECORD
                    path        STRING,
                    NAME        STRING,
                    wildcards   STRING,
                    caption     STRING
            END RECORD;
    DEFINE  result          STRING,
            URL             STRING,
            combobox        ui.ComboBox,
            i               INTEGER,
            rec             httpRecord;

    LET recOpenFile.wildcards = "*.zip";
    LET recOpenFile.caption = "Select file";
    CALL ui.Interface.frontCall("standard", "openFile", [recOpenFile.path, recOpenFile.NAME, recOpenFile.wildcards, recOpenFile.caption], [result])
    IF result IS NOT NULL THEN 
        CALL fgl_getfile(result, '../resources/'||rec.Token||'/'||result)
        MESSAGE SFMT("File %1", result)
        LET result = os.Path.pwd(), "/../resources/", rec.Token, '/', result;
        CALL POSTZipRequest(URL||'/import', result) RETURNING result;
        IF result IS NULL THEN
            ERROR 'Cannot upload resources to server'
        ELSE
            MESSAGE 'Resources uploaded';
        END IF
        CALL util.JSON.parse(result, rec);
        CALL combobox.clear();
        DISPLAY combobox.getItemCount();
        DISPLAY 'ICI'||util.JSON.stringify(rec.Locales);
        FOR i = 1 TO rec.Locales.getLength()
            DISPLAY 'add '||rec.Locales[i].LocaleCode||'...'||rec.Locales[i].LocaleContent;
            CALL combobox.addItem(i, rec.Locales[i].LocaleCode);
        END FOR
    END IF
        RETURN rec.*;
END FUNCTION
