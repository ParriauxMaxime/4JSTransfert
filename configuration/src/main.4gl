IMPORT util
IMPORT FGL initialValue
IMPORT FGL REST
IMPORT FGL customization
IMPORT FGL locales
IMPORT FGL resources
IMPORT FGL validator
IMPORT FGL server
IMPORT XML
IMPORT com
IMPORT os
GLOBALS 'global.4gl'

--gsform -M -i -keep gui.4fd POUR COMPILER 4FD TO .per

MAIN
    DEFINE  URL             STRING,
            rec             httpRecord,
            localeCM        STRING,
            prevLocaleCode  INTEGER,
            LocaleCode      INTEGER,
            gbcName         STRING,
            validation      BOOLEAN;

    OPEN FORM Theme FROM "Theme"
    DISPLAY FORM Theme
    LET URL = getServerURL();
    DISPLAY URL;
    CALL mainInit() RETURNING rec.*
    CALL initiateRequest(URL, rec.*) RETURNING rec.*;
    LET LocaleCode = 1;
    LET localeCM = rec.Locales[localeCode].LocaleContent;

    DIALOG ATTRIBUTES(UNBUFFERED)
        INPUT BY NAME rec.Overview.* ATTRIBUTES(WITHOUT DEFAULTS)
                
            ON CHANGE config_name, font_size_ratio, margin_ratio, field_height_ratio, radiobutton_size,
            checkbox_size, primary_background_color, secondary_background_color, field_background_color, 
            field_disabled_background,	primary_color, primary_medium_color, primary_light_color, secondary_color,
            disabled_color, separator_color, header_color, message_color, error_color, sidebar_always_visible_min_width, sidebar_default_width,
            toggle_right_sidebar_min_width, animation_duration,	desactivate_ending_popup
                CALL validateDataType(URL, rec.*) RETURNING validation;
                IF validation == FALSE THEN
                    CALL DIALOG.setActionActive('build', FALSE)
                ELSE
                    CALL DIALOG.setActionActive('build', TRUE)
                END IF
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


        DISPLAY ARRAY rec.Resources TO Resources.*
        END DISPLAY
       -- DISPLAY ARRAY rec.Resources.filesURI TO resourcesPath.*
        --END DISPLAY
        
        BEFORE DIALOG
            LET gbcName = NULL;
            CALL DIALOG.setActionActive('download', FALSE);
            CALL DIALOG.setActionActive('preview', FALSE)

        ON ACTION import_files
            CALL importFiles(rec.*) RETURNING rec.*;

        ON ACTION Import ATTRIBUTES(TEXT="Import")
            CALL importCustomization(URL, rec.*, ui.ComboBox.forName('localecode')) RETURNING rec.*

        ON ACTION build ATTRIBUTES(TEXT="Build")
           CALL buildCustomization(URL, rec.*) RETURNING gbcName;
            IF gbcName IS NOT NULL THEN
                CALL DIALOG.setActionActive('download', TRUE)
                CALL DIALOG.setActionActive('preview', TRUE)
            END IF

        ON ACTION Download ATTRIBUTES(TEXT='Download')
            CALL downloadCustomization(URL, rec.*);

        ON ACTION preview ATTRIBUTES(TEXT="Preview")
            CALL ui.Interface.frontCall("standard", "launchURL", [ getGasURL()||"/ua/r/gwc-demo?gbc=" || gbcName ], [])

        ON ACTION LocalesAdd
            CALL addLocale(rec.*)

        ON ACTION CANCEL
            EXIT DIALOG

    END DIALOG
END MAIN
