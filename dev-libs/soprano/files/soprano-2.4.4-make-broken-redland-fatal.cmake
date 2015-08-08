diff -ru cmake/modules/FindRedland.cmake cmake/modules/FindRedland.cmake
--- cmake/modules/FindRedland.cmake	2009-12-18 15:33:44.000000000 +0100
+++ cmake/modules/FindRedland.cmake	2010-07-06 03:25:55.421484970 +0200
@@ -108,7 +108,7 @@
     if(NOT "${_TEST_EXITCODE}" EQUAL 0)
       set(_REDLAND_VERSION_OK)
       message(STATUS "${_OUTPUT}")
-      message(STATUS "Redland with broken NEEDED section detected, disabling")
+      message(SEND_ERROR "Broken Redland detected, rebuild it now. If problem persists, report bug at bugs.gentoo.org.")
     endif(NOT "${_TEST_EXITCODE}" EQUAL 0)
   endif(_REDLAND_STORAGE_LIBS)
 
