--- eject.c.orig	Tue May  3 14:59:19 2005
+++ eject.c	Tue May  3 15:01:30 2005
@@ -133,7 +133,7 @@
     int sts;
     struct stat sb;
 
-    if (asprintf(device, "/dev/%sc", name) == -1)
+    if (asprintf(device, "/dev/%s", name) == -1)
 	return sts;
     if (vflag || nflag) {
 	printf("%s: using device %s\n", program, device);
