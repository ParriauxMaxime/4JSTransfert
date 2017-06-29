GLOBALS "src/global.4gl"

FUNCTION setDefaultValueOverview()
    DEFINE Overview OverviewRecord

    LET Overview.font_size_ratio = '0.8';
    LET Overview.margin_ratio = '0.6';
    LET Overview.field_height_ratio = '0.7';
    LET Overview.radiobutton_size = '14px';
    LET Overview.checkbox_size = '14px';
    LET Overview.sidebar_always_visible_min_width = '1400px';
    LET Overview.sidebar_default_width = '300px';
    LET Overview.toggle_right_sidebar_min_width = '720px';
    LET Overview.primary_background_color = '$mt-grey-50';
    LET  Overview.secondary_background_color = '$mt-white';
    LET Overview.field_background_color = '$mt-white';
    LET Overview.field_disabled_background = 'rgba(0,0,0,0.4)';
    LET Overview.primary_color = '$mt-blue-700';
    LET Overview.primary_medium_color = '$mt-blue-500';
    LET Overview.primary_light_color = '$mt-blue-100';
    LET Overview.secondary_color = '$mt-grey-600';
    LET Overview.disabled_color = '$mt-grey-400';
    LET Overview.separator_color = '$mt-grey-400';
    LET Overview.header_color = '$mt-grey-100';
    LET Overview.message_color = '$mt-grey-800';
    LET Overview.error_color = '$mt-red-800';
    LET Overview.animation_duration = '0.7s';
    LET Overview.message_display_time = '2';
    LET Overview.desactivate_ending_popup = 'FALSE';
    LET Overview.config_name = "";
    RETURN Overview.*
END FUNCTION

FUNCTION setDefaultEditor()
    DEFINE editor  EditorRecord;
    LET editor.custom_footer = FALSE;
    LET editor.custom_header = FALSE;
    LET editor.custom_header_html = "<header>\n</header>";
    LET editor.custom_header_css  = "header {\n}";
    LET editor.custom_footer_html = "<footer>\n</footer>";
    LET editor.custom_footer_css  = "footer {\n}";
    RETURN editor.*
END FUNCTION

FUNCTION initLocalesCombobox(cb ui.ComboBox)
    DEFINE Locales LocalesRecord;

    CALL cb.addItem(1, 'en-US')
    LET Locales[1].LocaleCode = 'en-US';
    LET Locales[1].LocaleContent = "{}"
    RETURN Locales;
END FUNCTION

FUNCTION mainInit()
    DEFINE rec httpRecord;
    DEFINE cb ui.ComboBox

    LET cb = ui.ComboBox.forName('localecode')
    CALL setDefaultValueOverview() RETURNING rec.Overview.*;
    CALL setDefaultEditor() RETURNING rec.Editor.*
    CALL initLocalesCombobox(cb) RETURNING rec.Locales;
    RETURN rec.*;
END FUNCTION
