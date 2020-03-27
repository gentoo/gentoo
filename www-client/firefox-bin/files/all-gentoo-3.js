// Ensure preference can't be changed by users
lockPref("app.update.auto", false);
lockPref("app.update.enabled", false);

// Allow user to change based on needs
defaultPref("browser.display.use_system_colors", true);
defaultPref("spellchecker.dictionary_path", "/usr/share/myspell");
defaultPref("browser.shell.checkDefaultBrowser", false);
defaultPref("intl.locale.requested", "");

// Preferences that should be reset every session
pref("browser.EULA.override", true);

// We believe in user choice - disable DNS-over-HTTPS by default
defaultPref("network.trr.mode", 5);

// Normandy web service allows upstream to push changes
// like changed default preferences or even add-ons to users
// without the need to re-release a new version. Because this
// happens without any user prompt we believe this should be
// disabled by default.
defaultPref("app.normandy.enabled", false);
