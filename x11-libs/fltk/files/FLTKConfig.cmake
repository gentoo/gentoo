#-----------------------------------------------------------------------------
#
# FLTKConfig.cmake - FLTK CMake configuration file for external projects.
#
# This file is configured by FLTK and used by the UseFLTK.cmake module
# to load FLTK's settings for an external project.

# The FLTK source tree.
# SET(FLTK_SOURCE_DIR "@FLTK_SOURCE_DIR@")

# The FLTK include file directories.
SET(FLUID_COMMAND "/usr/bin/fluid")
SET(FLTK_EXECUTABLE_DIRS "/usr/bin")
SET(FLTK_LIBRARY_DIRS "/usr/lib")
SET(FLTK_LIBRARIES "fltk_images;fltk_gl;fltk_forms;fltk")
SET(FLTK_INCLUDE_DIRS "/usr/include")

# The C and C++ flags added by FLTK to the cmake-configured flags.
SET(FLTK_REQUIRED_C_FLAGS "")
SET(FLTK_REQUIRED_CXX_FLAGS "")

# The FLTK version number
SET(FLTK_VERSION_MAJOR "1")
SET(FLTK_VERSION_MINOR "1")
SET(FLTK_VERSION_PATCH "7")

# Is FLTK using shared libraries?
SET(FLTK_BUILD_SHARED_LIBS "ON")
# SET(FLTK_BUILD_SETTINGS_FILE "@FLTK_BUILD_SETTINGS_FILE@")

# The location of the UseFLTK.cmake file.
SET(FLTK11_USE_FILE "/usr/share/cmake/Modules/FLTKUse.cmake")

# # The ExodusII library dependencies.
# IF(NOT FLTK_NO_LIBRARY_DEPENDS)
#   INCLUDE("@FLTK_LIBRARY_DEPENDS_FILE@")
# ENDIF(NOT FLTK_NO_LIBRARY_DEPENDS)
