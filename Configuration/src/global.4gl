GLOBALS
    TYPE OverviewRecord RECORD
        config_name                         STRING,
        font_size_ratio                     STRING,
        margin_ratio                        STRING,
        field_height_ratio                  STRING,
        radiobutton_size                    STRING,
        checkbox_size                       STRING,
        primary_background_color            STRING,
        secondary_background_color          STRING,
        field_background_color              STRING,
        field_disabled_background           STRING,
        primary_color                       STRING,
        primary_medium_color                STRING,
        primary_light_color                 STRING,
        secondary_color                     STRING,
        disabled_color                      STRING,
        separator_color                     STRING,
        header_color                        STRING,
        message_color                       STRING,
        error_color                         STRING,
        sidebar_always_visible_min_width    STRING,
        sidebar_default_width               STRING,
        toggle_right_sidebar_min_width      STRING,
        animation_duration                  STRING,
        message_display_time                STRING,
        desactivate_ending_popup            STRING
    END RECORD

    TYPE EditorRecord RECORD
        importFiles                         STRING,
        custom_header                       BOOLEAN,
        custom_header_html                  STRING,
        custom_header_css                   STRING,
        custom_footer                       BOOLEAN,
        custom_footer_html                  STRING,
        custom_footer_css                   STRING
   END RECORD

    TYPE ResourcesRecord RECORD
        files DYNAMIC ARRAY OF STRING,
        filesURI DYNAMIC ARRAY OF STRING
   END RECORD

   TYPE LocalesRecord DYNAMIC ARRAY OF RECORD
        LocaleCode STRING,
        LocaleContent STRING
        END RECORD;

   TYPE httpRecord RECORD
        Token STRING,
        Overview OverviewRecord,
        Editor  EditorRecord,
        Resources ResourcesRecord,
        Locales LocalesRecord
    END RECORD
END GLOBALS
