From 87ae04cee2627740bd93a56ec307a516f7459c04 Mon Sep 17 00:00:00 2001
From: "Azamat H. Hackimov" <azamat.hackimov@gmail.com>
Date: Wed, 1 Jul 2026 02:33:22 +0300
Subject: [PATCH] Revert 1a29aa8 commit

--- a/cmd/moor/moor.go
+++ b/cmd/moor/moor.go
@@ -277,26 +277,6 @@ func pumpToStdout(inputFilenames ...string) error {
 	return nil
 }
 
-func russiaNotSupported() {
-	if !strings.HasPrefix(strings.ToLower(os.Getenv("LANG")), "ru_ru") {
-		// Not russia
-		return
-	}
-
-	if os.Getenv("CRIMEA") == "Ukraine" {
-		// It is!
-		return
-	}
-
-	fmt.Fprintln(os.Stderr, "ERROR: russia not supported (but Russian is!)")
-	fmt.Fprintln(os.Stderr)
-	fmt.Fprintln(os.Stderr, "Options for using moor in Russian:")
-	fmt.Fprintln(os.Stderr, "* Change your language setting to ru_UA.UTF-8")
-	fmt.Fprintln(os.Stderr, "* Set CRIMEA=Ukraine in your environment")
-	fmt.Fprintln(os.Stderr, "* russia leaves Ukraine")
-	os.Exit(1)
-}
-
 // For git output and man pages, disable line numbers by default.
 //
 // Before paging, "man" first checks the terminal width and formats the man page
@@ -640,7 +620,6 @@ func main() {
 	logsRequested := false
 	log.SetOutput(&loglines)
 	twin.SetLogger(&util.TwinLogger{})
-	russiaNotSupported()
 
 	defer func() {
 		err := recover()
-- 
2.53.0

