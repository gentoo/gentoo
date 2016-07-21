--- src/main.c.orig	2011-09-30 09:57:00.000000000 +0200
+++ src/main.c	2011-12-28 16:07:59.000000000 +0100
@@ -112,7 +112,7 @@ char *esc_key(void)
 static void get_alrm(int dummy)
 {
   (void)dummy;
-  errno = ETIME;
+  errno = ETIMEDOUT;
   longjmp(albuf, 1);
 }
 
