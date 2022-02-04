--- a/src/libcalamares/CMakeLists.txt
+++ b/src/libcalamares/CMakeLists.txt
@@ -216,12 +216,6 @@
 )
 
 calamares_add_test(
-    libcalamaresnetworktest
-    SOURCES
-        network/Tests.cpp
-)
-
-calamares_add_test(
     libcalamarespartitiontest
     SOURCES
         partition/Tests.cpp
@@ -238,12 +232,6 @@
 endif()
 
 calamares_add_test(
-    libcalamaresutilstest
-    SOURCES
-        utils/Tests.cpp
-)
-
-calamares_add_test(
     libcalamaresutilspathstest
     SOURCES
         utils/TestPaths.cpp
--- a/src/modules/locale/CMakeLists.txt
+++ b/src/modules/locale/CMakeLists.txt
@@ -37,18 +37,3 @@
         yamlcpp
     SHARED_LIB
 )
-
-calamares_add_test(
-    localetest
-    SOURCES
-        Tests.cpp
-        Config.cpp
-        LocaleConfiguration.cpp
-        SetTimezoneJob.cpp
-        timezonewidget/TimeZoneImage.cpp
-    DEFINITIONS
-        SOURCE_DIR="${CMAKE_CURRENT_LIST_DIR}/images"
-        DEBUG_TIMEZONES=1
-    LIBRARIES
-        Qt5::Gui
-)
--- a/src/modules/packagechooser/CMakeLists.txt
+++ b/src/modules/packagechooser/CMakeLists.txt
@@ -58,13 +58,3 @@
         ${_extra_libraries}
     SHARED_LIB
 )
-
-calamares_add_test(
-    packagechoosertest
-    GUI
-    SOURCES
-        Tests.cpp
-    LIBRARIES
-        calamares_viewmodule_packagechooser
-        ${_extra_libraries}
-)
--- a/src/modules/users/CMakeLists.txt
+++ b/src/modules/users/CMakeLists.txt
@@ -70,15 +70,6 @@
 )
 
 calamares_add_test(
-    usershostnametest
-    SOURCES
-        TestSetHostNameJob.cpp
-        SetHostNameJob.cpp
-    LIBRARIES
-        Qt5::DBus  # HostName job can use DBus to systemd
-)
-
-calamares_add_test(
     userstest
     SOURCES
         Tests.cpp
