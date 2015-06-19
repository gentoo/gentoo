pref("app.update.enabled", false);
pref("app.update.autoInstallEnabled", false);
pref("browser.display.use_system_colors",   true);
pref("intl.locale.matchOS", true);
pref("mail.shell.checkDefaultClient", false);

# Disable global indexing by default
pref("mailnews.database.global.indexer.enabled", false);

# Do not switch to Smart Folders after upgrade to 3.0b4
pref("mail.folder.views.version", "1")
