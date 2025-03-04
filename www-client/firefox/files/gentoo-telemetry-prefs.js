/* Include strong telemetry blockage via '-telemetry' use flag, many settings are 
   from arkenfox/user.js */
pref("datareporting.policy.dataSubmissionEnabled",   false);
pref("datareporting.healthreport.uploadEnabled",     false);
pref("toolkit.telemetry.unified",                    false);
pref("toolkit.telemetry.enabled",                    false);
pref("toolkit.telemetry.server",                     "data:,");
pref("toolkit.telemetry.archive.enabled",            false);
pref("toolkit.telemetry.newProfilePing.enabled",     false);
pref("toolkit.telemetry.shutdownPingSender.enabled", false);
pref("toolkit.telemetry.updatePing.enabled",         false);
pref("toolkit.telemetry.bhrPing.enabled",            false);
pref("toolkit.telemetry.firstShutdownPing.enabled",  false);
pref("toolkit.telemetry.coverage.opt-out",           true);
pref("toolkit.coverage.opt-out",                     true);
pref("toolkit.coverage.endpoint.base",               "");
pref("toolkit.telemetry.dap_helper",                 "");
pref("toolkit.telemetry.dap_leader",                 "");
