IMPORT util
IMPORT FGL initialValue
IMPORT FGL REST
IMPORT FGL customization
IMPORT FGL locales
IMPORT FGL resources
IMPORT XML
IMPORT com
IMPORT os
GLOBALS 'src/global.4gl'

--gsform -M -i -keep gui.4fd POUR COMPILER 4FD TO .per

MAIN
    DEFINE  URL             STRING,
            rec             httpRecord,
            localeCM        STRING,
            prevLocaleCode  INTEGER,
            LocaleCode      INTEGER,
            gbcName         STRING;

    OPEN FORM Theme FROM "Theme"
    DISPLAY FORM Theme
    LET URL = 'http://localhost:3000';
    CALL mainInit() RETURNING rec.*
    CALL initiateRequest(URL, rec.*) RETURNING rec.*;
    LET LocaleCode = 1;
    LET localeCM = rec.Locales[localeCode].LocaleContent;

    DIALOG ATTRIBUTES(UNBUFFERED)
        INPUT BY NAME rec.Overview.* ATTRIBUTES(WITHOUT DEFAULTS)
        END INPUT

        INPUT BY NAME rec.Editor.* ATTRIBUTES(WITHOUT DEFAULTS)
        END INPUT

        INPUT BY NAME LocaleCode ATTRIBUTES(WITHOUT DEFAULTS)
            BEFORE INPUT
                LET prevLocaleCode = LocaleCode;
            ON CHANGE localeCode
                LET rec.Locales[prevLocaleCode].LocaleContent = localeCM;
                LET prevLocaleCode = localeCode;
                LET localeCM = rec.Locales[localeCode].LocaleContent;
                NEXT FIELD localeCM;
        END INPUT

        INPUT BY NAME localeCM ATTRIBUTES(WITHOUT DEFAULTS)
            BEFORE INPUT
                LET localeCM = rec.Locales[localeCode].LocaleContent;
        END INPUT


        DISPLAY ARRAY rec.Resources.filesURI TO resources.*
        END DISPLAY

        BEFORE DIALOG
            LET gbcName = NULL;
            CALL DIALOG.setActionActive('download', FALSE);
            CALL DIALOG.setActionActive('preview', FALSE)

        ON ACTION import_files
            CALL importFiles(rec.*) RETURNING rec.*;

        ON ACTION importCusto ATTRIBUTES(TEXT="Import")
            CALL importCustomization(URL, rec.*, ui.ComboBox.forName('localecode')) RETURNING rec.*

        ON ACTION sendToServer ATTRIBUTES(TEXT="Build")
           CALL buildCustomization(URL, rec.*) RETURNING gbcName;
            IF gbcName IS NOT NULL THEN
                CALL DIALOG.setActionActive('download', TRUE)
                CALL DIALOG.setActionActive('preview', TRUE)
            END IF

        ON ACTION Download ATTRIBUTES(TEXT='Download')
            CALL downloadCustomization(URL, rec.*);

        ON ACTION preview ATTRIBUTES(TEXT="Preview")
            CALL ui.Interface.frontCall("standard", "launchURL", [ "http://localhost:6394/ua/r/gwc-demo?gbc=" || gbcName ], [])

        ON ACTION LocalesAdd
            CALL addLocale(rec.*)

        ON ACTION CANCEL
            EXIT DIALOG

    END DIALOG
END MAIN
