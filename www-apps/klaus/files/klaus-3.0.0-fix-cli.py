https://github.com/jonashaag/klaus/pull/333

From a7f0a5511c4ee25e82ea704b90482c24f16f5bff Mon Sep 17 00:00:00 2001
From: Louis Sautier <sautier.louis@gmail.com>
Date: Sun, 16 Jun 2024 15:23:35 +0200
Subject: [PATCH] cli: fix startup with --ctags, fixes #330

It had been broken by 36a6d2c617f1120.
--- a/klaus/cli.py
+++ b/klaus/cli.py
@@ -102,9 +102,9 @@ def main():
         args.site_name = "%s:%d" % (args.host, args.port)
 
     if args.ctags != "none":
-        from klaus.ctagsutils import check_have_exuberant_ctags
+        from klaus.ctagsutils import check_have_compatible_ctags
 
-        if not check_have_exuberant_ctags():
+        if not check_have_compatible_ctags():
             print(
                 "ERROR: Exuberant ctags not installed (or 'ctags' binary isn't *Exuberant* ctags)",
                 file=sys.stderr,
