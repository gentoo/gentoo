--- a/configure.ac
+++ b/configure.ac
@@ -82,11 +82,6 @@
 dnl PKGCONFIG preparations
 dnl ======================
 
-if test -z $PKG_CONFIG_PATH; then
-	PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
-fi
-
-export PKG_CONFIG_PATH
 
 
 dnl ===============
@@ -639,10 +634,10 @@
 
 AC_MSG_CHECKING(for gcc optimization flags)
 old_cflags=$CFLAGS
-CFLAGS="$CFLAGS -O2 -funroll-loops -finline-functions -ffast-math -Wall"
+CFLAGS="$CFLAGS -Wall"
 AC_TRY_COMPILE([#include <stdio.h>],
 [ printf ("hello, world"); ],
-[ EXTRA_OPT_CFLAGS="$CFLAGS -O2 -funroll-loops -finline-functions -ffast-math -Wall"],[ EXTRA_OPT_CFLAGS=""])
+[ EXTRA_OPT_CFLAGS="$CFLAGS -Wall"],[ EXTRA_OPT_CFLAGS=""])
 CFLAGS=$old_cflags
 AC_MSG_RESULT([$EXTRA_OPT_CFLAGS])
 
--- a/output/jack/Makefile.am
+++ b/output/jack/Makefile.am
@@ -24,7 +24,6 @@
 
 AM_CXXFLAGS = $(COMMON_FLAGS) $(JACK_CFLAGS)
 
-AM_CFLAGS = $(AM_CXXFLAGS)
 
 libdir = $(ADDON_DIR)/output
 
