IMPORT os
IMPORT util
GLOBALS 'src/global.4gl'

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

    LET recOpenFiles.wildcards = "*.jpg";
    LET recOpenFiles.caption = "Select files";

    CALL ui.Interface.frontCall("standard", "openFiles", [recOpenFiles.path, recOpenFiles.NAME, recOpenFiles.wildcards, recOpenFiles.caption], [result])
    CALL util.JSON.parse(result, rec.Resources.files);
    FOR i=1 TO rec.Resources.files.getLength()
        CALL fgl_getfile(rec.Resources.files[i], '../resources/'||rec.Token||'/'||rec.Resources.files[i])
        MESSAGE SFMT("File %1: %2 ", i, rec.Resources.files[i])
        LET rec.Resources.filesURI[i] = os.Path.pwd(), "/../resources/", rec.Token, '/', rec.Resources.files[i];
    END FOR
    RETURN rec.*;
END FUNCTION
