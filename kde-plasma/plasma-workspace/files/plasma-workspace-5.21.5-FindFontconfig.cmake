# SPDX-FileCopyrightText: 2006, 2007 Laurent Montel <montel@kde.org>
# SPDX-FileCopyrightText: 2018 Volker Krause <vkrause@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindFontconfig
--------------

Try to find Fontconfig.
Once done this will define the following variables:

``Fontconfig_FOUND``
    True if Fontconfig is available
``Fontconfig_INCLUDE_DIRS``
    The include directory to use for the Fontconfig headers
``Fontconfig_LIBRARIES``
    The Fontconfig libraries for linking
``Fontconfig_DEFINITIONS``
    Compiler switches required for using Fontconfig
``Fontconfig_VERSION``
    The version of Fontconfig that has been found

If ``Fontconfig_FOUND`` is TRUE, it will also define the following
imported target:

``Fontconfig::Fontconfig``

Since 5.57.0.
#]=======================================================================]

# use pkg-config to get the directories and then use these values
# in the FIND_PATH() and FIND_LIBRARY() calls
find_package(PkgConfig QUIET)
pkg_check_modules(PC_FONTCONFIG QUIET fontconfig)

set(Fontconfig_DEFINITIONS ${PC_FONTCONFIG_CFLAGS_OTHER})

find_path(Fontconfig_INCLUDE_DIRS fontconfig/fontconfig.h
    PATHS
    ${PC_FONTCONFIG_INCLUDE_DIRS}
    /usr/X11/include
)

find_library(Fontconfig_LIBRARIES NAMES fontconfig
    PATHS
    ${PC_FONTCONFIG_LIBRARY_DIRS}
)

set(Fontconfig_VERSION ${PC_FONTCONFIG_VERSION})
if (NOT Fontconfig_VERSION)
    find_file(Fontconfig_VERSION_HEADER
        NAMES "fontconfig/fontconfig.h"
        HINTS ${Fontconfig_INCLUDE_DIRS}
    )
    mark_as_advanced(Fontconfig_VERSION_HEADER)
    if (Fontconfig_VERSION_HEADER)
        file(READ ${Fontconfig_VERSION_HEADER} _fontconfig_version_header_content)
        string(REGEX MATCH "#define FC_MAJOR[ \t]+[0-9]+" Fontconfig_MAJOR_VERSION_MATCH ${_fontconfig_version_header_content})
        string(REGEX MATCH "#define FC_MINOR[ \t]+[0-9]+" Fontconfig_MINOR_VERSION_MATCH ${_fontconfig_version_header_content})
        string(REGEX MATCH "#define FC_REVISION[ \t]+[0-9]+" Fontconfig_PATCH_VERSION_MATCH ${_fontconfig_version_header_content})
        string(REGEX REPLACE ".*FC_MAJOR[ \t]+(.*)" "\\1" Fontconfig_MAJOR_VERSION ${Fontconfig_MAJOR_VERSION_MATCH})
        string(REGEX REPLACE ".*FC_MINOR[ \t]+(.*)" "\\1" Fontconfig_MINOR_VERSION ${Fontconfig_MINOR_VERSION_MATCH})
        string(REGEX REPLACE ".*FC_REVISION[ \t]+(.*)" "\\1" Fontconfig_PATCH_VERSION ${Fontconfig_PATCH_VERSION_MATCH})
        set(Fontconfig_VERSION "${Fontconfig_MAJOR_VERSION}.${Fontconfig_MINOR_VERSION}.${Fontconfig_PATCH_VERSION}")
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Fontconfig
    FOUND_VAR Fontconfig_FOUND
    REQUIRED_VARS Fontconfig_LIBRARIES Fontconfig_INCLUDE_DIRS
    VERSION_VAR Fontconfig_VERSION
)
mark_as_advanced(Fontconfig_LIBRARIES Fontconfig_INCLUDE_DIRS)

if(Fontconfig_FOUND AND NOT TARGET Fontconfig::Fontconfig)
    add_library(Fontconfig::Fontconfig UNKNOWN IMPORTED)
    set_target_properties(Fontconfig::Fontconfig PROPERTIES
        IMPORTED_LOCATION "${Fontconfig_LIBRARIES}"
        INTERFACE_INCLUDE_DIRECTORIES "${Fontconfig_INCLUDE_DIRS}"
        INTERFACE_COMPILER_DEFINITIONS "${Fontconfig_DEFINITIONS}"
    )
endif()

# backward compatibility, remove in kf6
set(FONTCONFIG_INCLUDE_DIR "${Fontconfig_INCLUDE_DIRS}")
set(FONTCONFIG_LIBRARIES "${Fontconfig_LIBRARIES}")
set(FONTCONFIG_DEFINITIONS "${Fontconfig_DEFINITIONS}")
mark_as_advanced(FONTCONFIG_INCLUDE_DIR FONTCONFIG_LIBRARIES FONTCONFIG_DEFINITIONS)

include(FeatureSummary)
set_package_properties(Fontconfig PROPERTIES
    URL "https://www.fontconfig.org/"
    DESCRIPTION "Fontconfig is a library for configuring and customizing font access"
)
