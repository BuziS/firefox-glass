// Firefox Glass - required settings (macOS). Copy into your Firefox profile folder next to the "chrome" folder.
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("widget.non-native-theme.use-theme-accent", true);
user_pref("widget.macos.titlebar-blend-mode.behind-window", false);
// No "... is now full screen" message
user_pref("full-screen-api.warning.timeout", 0);
user_pref("full-screen-api.warning.delay", -1);
// Neutral grey instead of the system blue for accents and text selection
user_pref("ui.accentcolor", "#7c7c80");
user_pref("ui.accentcolortext", "#ffffff");
user_pref("ui.highlight", "#7c7c80");
user_pref("ui.highlighttext", "#ffffff");
user_pref("ui.selecteditem", "#7c7c80");
user_pref("ui.selecteditemtext", "#ffffff");
user_pref("ui.-moz-mac-focusring", "#8e8e93");
user_pref("ui.textSelectDisabledBackground", "#b0b0b4");
// Keep native macOS right-click menus (Firefox-drawn menus lose labels on Firefox 161)
user_pref("widget.macos.native-context-menus", true);
// Private windows use the same grey look (no purple)
user_pref("browser.theme.dark-private-windows", false);
