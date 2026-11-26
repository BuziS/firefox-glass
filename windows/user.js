// Firefox Glass - required settings (Windows). Install.bat copies this into your Firefox profile.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("widget.non-native-theme.use-theme-accent", true);
// No "... is now full screen" message
user_pref("full-screen-api.warning.timeout", 0);
user_pref("full-screen-api.warning.delay", -1);
// Neutral grey instead of the system accent for highlights and text selection
user_pref("ui.accentcolor", "#7c7c80");
user_pref("ui.accentcolortext", "#ffffff");
user_pref("ui.highlight", "#7c7c80");
user_pref("ui.highlighttext", "#ffffff");
user_pref("ui.selecteditem", "#7c7c80");
user_pref("ui.selecteditemtext", "#ffffff");
user_pref("ui.textSelectDisabledBackground", "#b0b0b4");
// Private windows use the same grey look (no purple)
user_pref("browser.theme.dark-private-windows", false);
