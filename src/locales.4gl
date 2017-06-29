GLOBALS 'src/global.4gl'

FUNCTION addLocale(rec httpRecord)
    DEFINE localeToAdd STRING;
    DEFINE c ui.ComboBox;

    LET c = ui.ComboBox.forName('localecode')
    PROMPT 'Standard Localization Code: ' FOR localeToAdd
    DISPLAY 'nb ='||rec.Locales.getLength();
    LET rec.Locales[rec.Locales.getLength() + 1].LocaleCode = localeToAdd
    DISPLAY 'nb +1 ='||rec.Locales.getLength();
    LET rec.Locales[rec.Locales.getLength()].LocaleContent = '{}';
    CALL c.addItem(c.getItemCount() + 1, localeToAdd)
END FUNCTION
