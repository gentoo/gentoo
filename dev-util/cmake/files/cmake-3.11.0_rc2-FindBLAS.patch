--- a/Modules/FindBLAS.cmake
+++ b/Modules/FindBLAS.cmake
@@ -4,6 +4,10 @@
 #
 # Find BLAS library
 #
+# Version modified for Gentoo Linux.
+# If a valid PkgConfig configuration is found, this overrides and cancels
+# all further checks.
+#
 # This module finds an installed fortran library that implements the
 # BLAS linear-algebra interface (see http://www.netlib.org/blas/).  The
 # list of libraries searched for is taken from the autoconf macro file,
@@ -50,6 +54,9 @@
 # (To distribute this file outside of CMake, substitute the full
 #  License text for the above reference.)
 
+# first, try PkgConfig
+set(BLA_PREFER_PKGCONFIG On)
+
 include(${CMAKE_CURRENT_LIST_DIR}/CheckFunctionExists.cmake)
 include(${CMAKE_CURRENT_LIST_DIR}/CheckFortranFunctionExists.cmake)
 
