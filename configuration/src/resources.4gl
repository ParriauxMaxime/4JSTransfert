IMPORT os
IMPORT util
GLOBALS 'global.4gl'

-- Let file to be imported in $pwd/../resources/$SESSION_TOKEN/*.jpg
FUNCTION importFiles(rec httpRecord)
    DEFINE  recOpenFiles    RECORD
                    path        STRING,
                    NAME        STRING,
                    wildcards   STRING,
                    caption     STRING
            END RECORD;
    DEFINE  result          STRING,
            i               INTEGER;
    DEFINE tmp DYNAMIC ARRAY OF STRING;

    LET recOpenFiles.wildcards = "*";
    LET recOpenFiles.caption = "Select files";

    CALL ui.Interface.frontCall("standard", "openFiles", [recOpenFiles.path, recOpenFiles.NAME, recOpenFiles.wildcards, recOpenFiles.caption], [result])
    DISPLAY result
    CALL util.JSON.parse(result, tmp);
    FOR i=1 TO tmp.getLength()
        LET rec.Resources[i].files = tmp[i]
        CALL fgl_getfile(rec.Resources[i].files, '../resources/'||rec.Token||'/'||rec.Resources[i].files)
        MESSAGE SFMT("File %1: %2 ", i, rec.Resources[i].files)
        LET rec.Resources[i].filesURI = os.Path.pwd(), "/../resources/", rec.Token, '/', rec.Resources[i].files;
    END FOR
    CALL util.JSON.stringify(rec.Resources) RETURNING tmp[1];
    DISPLAY tmp[1];
    RETURN rec.*;
END FUNCTION
