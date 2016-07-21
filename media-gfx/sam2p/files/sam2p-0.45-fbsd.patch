--- gensio.cpp.orig	Fri Feb  7 02:24:56 2003
+++ gensio.cpp	Fri Feb  7 02:25:11 2003
@@ -491,11 +491,7 @@
 /* --- */
 
 
-#if HAVE_lstat_in_sys_stat
-#  define PTS_lstat lstat
-#else
 #  define PTS_lstat stat
-#endif
 
 /** @param fname must start with '/' (dir separator)
  * @return true if file successfully created
