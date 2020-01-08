#.rst:
# FindPROJ4
# --------
#
# Find the proj includes and library.
#
# IMPORTED Targets
# ^^^^^^^^^^^^^^^^
#
# This module defines :prop_tgt:`IMPORTED` target ``PROJ4::proj``,
# if Proj.4 has been found.
#
# Result Variables
# ^^^^^^^^^^^^^^^^
#
# This module defines the following variables:
#
# ::
#
#   PROJ4_INCLUDE_DIRS   - where to find proj_api.h, etc.
#   PROJ4_LIBRARIES      - List of libraries when using libproj.
#   PROJ4_FOUND          - True if libproj found.
#
# ::
#
#   PROJ4_VERSION        - The version of libproj found (x.y.z)
#   PROJ4_VERSION_MAJOR  - The major version of libproj
#   PROJ4_VERSION_MINOR  - The minor version of libproj
#   PROJ4_VERSION_PATCH  - The patch version of libproj
#   PROJ4_VERSION_TWEAK  - always 0
#   PROJ4_VERSION_COUNT  - The number of version components, always 3
#
# Hints
# ^^^^^
#
# A user may set ``PROJ4_ROOT`` to a libproj installation root to tell this
# module where to look exclusively.

#=============================================================================
# Copyright 2016 Kai Pastor
#
#
# This file was derived from CMake 3.5's module FindZLIB.cmake
# which has the following terms:
#
# Copyright 2001-2011 Kitware, Inc.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# * Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# * The names of Kitware, Inc., the Insight Consortium, or the names of
#   any consortium members, or of any contributors, may not be used to
#   endorse or promote products derived from this software without
#   specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHORS OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#=============================================================================

# Search PROJ4_ROOT exclusively if it is set.
if(PROJ4_ROOT)
  set(_PROJ4_SEARCH PATHS ${PROJ4_ROOT} NO_DEFAULT_PATH)
else()
  set(_PROJ4_SEARCH)
endif()

find_path(PROJ4_INCLUDE_DIR NAMES proj_api.h ${_PROJ4_SEARCH} PATH_SUFFIXES include)
mark_as_advanced(PROJ4_INCLUDE_DIR)

if(PROJ4_INCLUDE_DIR AND EXISTS "${PROJ4_INCLUDE_DIR}/proj_api.h")
    file(STRINGS "${PROJ4_INCLUDE_DIR}/proj_api.h" PROJ4_H REGEX "^#define PJ_VERSION [0-9]+$")

    string(REGEX REPLACE "^.*PJ_VERSION ([0-9]).*$" "\\1" PROJ4_VERSION_MAJOR "${PROJ4_H}")
    string(REGEX REPLACE "^.*PJ_VERSION [0-9]([0-9]).*$" "\\1" PROJ4_VERSION_MINOR  "${PROJ4_H}")
    string(REGEX REPLACE "^.*PJ_VERSION [0-9][0-9]([0-9]).*$" "\\1" PROJ4_VERSION_PATCH "${PROJ4_H}")
    set(PROJ4_VERSION "${PROJ4_VERSION_MAJOR}.${PROJ4_VERSION_MINOR}.${PROJ4_VERSION_PATCH}")
    set(PROJ4_VERSION_COUNT 3)
endif()

# Allow PROJ4_LIBRARY to be set manually, as the location of the proj library
if(NOT PROJ4_LIBRARY)
  set(PROJ4_NAMES proj)
  set(PROJ4_NAMES_DEBUG projd)
  if(WIN32 AND DEFINED PROJ4_VERSION_MAJOR AND DEFINED PROJ4_VERSION_MINOR)
	  list(APPEND PROJ4_NAMES proj_${PROJ4_VERSION_MAJOR}_${PROJ4_VERSION_MINOR})
	  list(APPEND PROJ4_NAMES projd_${PROJ4_VERSION_MAJOR}_${PROJ4_VERSION_MINOR})
  endif()
  find_library(PROJ4_LIBRARY_RELEASE NAMES ${PROJ4_NAMES} ${_PROJ4_SEARCH} PATH_SUFFIXES lib)
  find_library(PROJ4_LIBRARY_DEBUG NAMES ${PROJ4_NAMES_DEBUG} ${_PROJ4_SEARCH} PATH_SUFFIXES lib)
  include(SelectLibraryConfigurations)
  select_library_configurations(PROJ4)
endif()

# handle the QUIETLY and REQUIRED arguments and set PROJ4_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PROJ4
  REQUIRED_VARS
    PROJ4_LIBRARY
    PROJ4_INCLUDE_DIR
  VERSION_VAR
    PROJ4_VERSION
)

if(PROJ4_FOUND)
    set(PROJ4_INCLUDE_DIRS ${PROJ4_INCLUDE_DIR})

    if(NOT PROJ4_LIBRARIES)
      set(PROJ4_LIBRARIES ${PROJ4_LIBRARY})
    endif()

    if(NOT TARGET PROJ4::proj)
      add_library(PROJ4::proj UNKNOWN IMPORTED)
      set_target_properties(PROJ4::proj PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${PROJ4_INCLUDE_DIRS}")

      if(PROJ4_LIBRARY_RELEASE)
        set_property(TARGET PROJ4::proj APPEND PROPERTY
          IMPORTED_CONFIGURATIONS RELEASE)
        set_target_properties(PROJ4::proj PROPERTIES
          IMPORTED_LOCATION_RELEASE "${PROJ4_LIBRARY_RELEASE}")
      endif()

      if(PROJ4_LIBRARY_DEBUG)
        set_property(TARGET PROJ4::proj APPEND PROPERTY
          IMPORTED_CONFIGURATIONS DEBUG)
        set_target_properties(PROJ4::proj PROPERTIES
          IMPORTED_LOCATION_DEBUG "${PROJ4_LIBRARY_DEBUG}")
      endif()

      if(NOT PROJ4_LIBRARY_RELEASE AND NOT PROJ4_LIBRARY_DEBUG)
        set_property(TARGET PROJ4::proj APPEND PROPERTY
          IMPORTED_LOCATION "${PROJ4_LIBRARY}")
      endif()
    endif()
endif()
