# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ecm-common.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: cmake
# @BLURB: Standalone CMake calling std. ECM macros to install common files only.
# @DESCRIPTION:
# This eclass is used for installing common files of packages using ECM macros,
# most of the time translations, but optionally also icons and kcfg files. This
# is mainly useful for packages split from a single upstream tarball, or for
# collision handling of slotted package versions, which need to share a common
# files package.
# Conventionally we will use ${PN}-common for these split packages.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_ECM_COMMON_ECLASS} ]]; then
_ECM_COMMON_ECLASS=1

inherit cmake

# @ECLASS_VARIABLE: KFMIN
# @DEFAULT_UNSET
# @DESCRIPTION:
# Minimum version of Frameworks to require.  Baseline value is 6.22.0.
: "${KFMIN:=6.22.0}"

ver_test ${KFMIN} -lt 5.240 && die "KF5 is unsupported!"

# @ECLASS_VARIABLE: ECM_I18N
# @PRE_INHERIT
# @DESCRIPTION:
# Will accept "true" (default) or "false".  If set to "false", do nothing.
# Otherwise, add kde-frameworks/ki18n:6 to BDEPEND, find KF6I18n and let
# ki18n_install(po) generate and install translations.
: "${ECM_I18N:=true}"

# @ECLASS_VARIABLE: ECM_HANDBOOK
# @PRE_INHERIT
# @DESCRIPTION:
# Will accept "true" or "false" (default).  If set to "false", do nothing.
# Otherwise, add "+handbook" to IUSE, add kde-frameworks/kdoctools:6 to BDEPEND
# find KF6DocTools in CMake, call add_subdirectory(ECM_HANDBOOK_DIRS)
# and let let kdoctools_install(po) generate and install translated docbook
# files.
: "${ECM_HANDBOOK:=false}"

# @ECLASS_VARIABLE: ECM_HANDBOOK_DIRS
# @PRE_INHERIT
# @DESCRIPTION:
# Default is "doc" which is correct for the vast majority of packages. Specifies
# one or more directories containing untranslated docbook file(s) relative to
# ${S} to be added via add_subdirectory.
if [[ ${ECM_HANDBOOK_DIRS} ]]; then
	[[ ${ECM_HANDBOOK_DIRS@a} == *a* ]] ||
		die "ECM_HANDBOOK_DIRS must be an array"
else
	ECM_HANDBOOK_DIRS=( doc )
fi

# @ECLASS_VARIABLE: ECM_INSTALL_FILES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of <file>:<destination_path> tuples to install by CMake via
# install(FILES <file> DESTINATION <destination_path>)
if [[ ${ECM_INSTALL_FILES} ]]; then
	[[ ${ECM_INSTALL_FILES@a} == *a* ]] ||
		die "ECM_INSTALL_FILES must be an array"
fi

# @ECLASS_VARIABLE: ECM_INSTALL_ICONS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of <icon>:<icon_install_dir> tuples to feed to ECMInstallIcons
# via ecm_install_icons(ICONS <icon> DESTINATION <icon_install_dir)
if [[ ${ECM_INSTALL_ICONS} ]]; then
	[[ ${ECM_INSTALL_ICONS@a} == *a* ]] ||
		die "ECM_INSTALL_ICONS must be an array"
fi

# @ECLASS_VARIABLE: ECM_KCM_TARGETS
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If empty, do nothing.  Otherwise, add kde-frameworks/kcmutils:6 to BDEPEND
# and set up the CMaḱeLists.txt according to the content of ECM_KCM_TARGETS:
# Array of <target>:<subdir> tuples to feed to ECMInstallIcons via
# ecmcommon_generate_desktop_file(<target> <subdir>), which is this eclass'
# adaptation of kcmutils_generate_desktop_file.
if [[ ${ECM_KCM_TARGETS} ]]; then
	[[ ${ECM_KCM_TARGETS@a} == *a* ]] ||
		die "ECM_KCM_TARGETS must be an array"
fi

DESCRIPTION="Common files for ${PN/-common/}"

BDEPEND="
	>=dev-build/cmake-3.31.9-r1
	dev-qt/qtbase:6
	>=kde-frameworks/extra-cmake-modules-${KFMIN}:*
"

case ${ECM_I18N} in
	true)
		BDEPEND+=" kde-frameworks/ki18n:6"
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_I18N}"
		die "Value ${ECM_I18N} is not supported"
		;;
esac

case ${ECM_HANDBOOK} in
	true)
		IUSE+=" +handbook"
		BDEPEND+=" handbook? ( kde-frameworks/kdoctools:6 )"
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_HANDBOOK}"
		die "Value ${ECM_HANDBOOK} is not supported"
		;;
esac

if [[ ${ECM_KCM_TARGETS} ]]; then
	BDEPEND+=" kde-frameworks/kcmutils:6"
fi

# @FUNCTION: _ecm-common_preamble
# @INTERNAL
# @DESCRIPTION:
# Create a CMakeLists.txt file with minimum ECM setup.
_ecm-common_preamble() {
	cat > CMakeLists.txt <<- _EOF_ || die
		cmake_minimum_required(VERSION 3.31)
		project(${PN} VERSION ${PV})

		find_package(ECM "${KFMIN}" REQUIRED NO_MODULE)
		set(CMAKE_MODULE_PATH \${ECM_MODULE_PATH})

		# TODO EAPI-9: No longer used after KF5 cleanup.
		set(KFSLOT 6)
		set(KDE_INSTALL_DOCBUNDLEDIR "${EPREFIX}/usr/share/help" CACHE PATH "")

		include(KDEInstallDirs)
		include(ECMOptionalAddSubdirectory) # commonly used
		include(ECMFeatureSummary)
	_EOF_

	if [[ ${ECM_INSTALL_ICONS} ]]; then
		cat >> CMakeLists.txt <<- _EOF_ || die
			include(ECMInstallIcons)
		_EOF_
	fi
}

# @FUNCTION: _ecm-common_i18n
# @INTERNAL
# @DESCRIPTION:
# Find KF6I18n and call ki18n_install(po).
_ecm-common_i18n() {
	[[ ${ECM_I18N} == true ]] || return
	cat >> CMakeLists.txt <<- _EOF_ || die
		find_package(KF6I18n REQUIRED)
		ki18n_install(po)
	_EOF_
}

# @FUNCTION: _ecm-common_docs
# @INTERNAL
# @DESCRIPTION:
# Find KF6DocTools, call kdoctools_install(po) and
# add_subdirectory(${ECM_HANDBOOK_DIRS})
_ecm-common_docs() {
	{ in_iuse handbook && use handbook; } || return

	cat >> CMakeLists.txt <<- _EOF_ || die
		find_package(KF6DocTools REQUIRED)
		kdoctools_install(po)
	_EOF_

	local i
	for i in "${ECM_HANDBOOK_DIRS[@]}"; do
		if [[ -d ${i} ]]; then
			cat >> CMakeLists.txt <<- _EOF_ || die
				add_subdirectory(${i})
			_EOF_
		fi
	done
}

# @FUNCTION: _ecm-common_generate_desktop_file
# @INTERNAL
# @DESCRIPTION:
# Find KF6KCMUtils and iterate through ECM_KCM_TARGETS to generate
# desktop files out of json.
_ecm-common_generate_desktop_file() {
	[[ ${ECM_KCM_TARGETS} ]] || return

	cat >> CMakeLists.txt <<- _EOF_ || die
		find_package(KF6KCMUtils REQUIRED)
		# extracted from kcmutils_generate_desktop_file(kcm_target)
		function(ecmcommon_generate_desktop_file kcm_target subdir)
			set(IN_FILE \${CMAKE_CURRENT_SOURCE_DIR}/\${subdir}\${kcm_target}.json)
			set(OUT_FILE \${CMAKE_CURRENT_BINARY_DIR}/\${kcm_target}.desktop)
			add_custom_target(\${kcm_target}-kcm-desktop-gen ALL
				COMMAND KF6::kcmdesktopfilegenerator \${IN_FILE} \${OUT_FILE}
				DEPENDS \${IN_FILE})
			install(FILES \${OUT_FILE} DESTINATION \${KDE_INSTALL_APPDIR})
		endfunction()
	_EOF_

	local i
	for i in "${ECM_KCM_TARGETS[@]}"; do
		cat >> CMakeLists.txt <<- _EOF_ || die
			ecmcommon_generate_desktop_file(${i%:*} ${i#*:})
		_EOF_
	done
}

# @FUNCTION: _ecm-common_ecm_install_icons
# @INTERNAL
# @DESCRIPTION:
# Installs icons listed in ECM_INSTALL_ICONS using ecm_install_icons
_ecm-common_ecm_install_icons() {
	[[ ${ECM_INSTALL_ICONS} ]] || return
	local i
	for i in "${ECM_INSTALL_ICONS[@]}"; do
		cat >> CMakeLists.txt <<- _EOF_ || die
			ecm_install_icons(ICONS ${i%:*} DESTINATION ${i#*:})
		_EOF_
	done
}

# @FUNCTION: _ecm-common_ecm_install_files
# @INTERNAL
# @DESCRIPTION:
# Installs files listed in ECM_INSTALL_FILES using install(FILES ...)
_ecm-common_ecm_install_files() {
	[[ ${ECM_INSTALL_FILES} ]] || return
	local i
	for i in "${ECM_INSTALL_FILES[@]}"; do
		cat >> CMakeLists.txt <<- _EOF_ || die
			install(FILES ${i%:*} DESTINATION ${i#*:})
		_EOF_
	done
}

# @FUNCTION: ecm-common_inject_heredoc
# @DESCRIPTION:
# Override this to inject custom Heredoc into the root CMakeLists.txt
ecm-common_inject_heredoc() {
	debug-print-function ${FUNCNAME} "$@"
}

# @FUNCTION: _ecm-common_summary
# @INTERNAL
# @DESCRIPTION:
# Just calls ecm_feature_summary
_ecm-common_summary() {
	cat >> CMakeLists.txt <<- _EOF_ || die

		ecm_feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
	_EOF_
}

# @FUNCTION: ecm-common-check_deps
# @DESCRIPTION:
# No-op function since KF5 support was dropped.
ecm-common-check_deps() {
	return 0
}

if [[ ${EAPI} == 8 ]]; then
# @FUNCTION: ecm-common_pkg_setup
# @DESCRIPTION:
# No-op function since KF5 support was dropped.
ecm-common_pkg_setup() { :; }
fi

# @FUNCTION: ecm-common_src_prepare
# @DESCRIPTION:
# Wrapper for cmake_src_prepare with a Heredoc replacing the standard
# root CMakeLists.txt file to only generate and install translations.
ecm-common_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	_ecm-common_preamble
	_ecm-common_i18n
	_ecm-common_docs
	_ecm-common_generate_desktop_file
	_ecm-common_ecm_install_icons
	_ecm-common_ecm_install_files
	ecm-common_inject_heredoc
	_ecm-common_summary

	cmake_src_prepare
}

# @FUNCTION: ecm-common_src_configure
# @DESCRIPTION:
# Passes -DQT_MAJOR_VERSION=6 only.
ecm-common_src_configure() {
	# necessary for at least KF6KCMUtils
	local cmakeargs=( -DQT_MAJOR_VERSION=6 )

	# allow the ebuild to override what we set here
	mycmakeargs=("${cmakeargs[@]}" "${mycmakeargs[@]}")

	cmake_src_configure
}

fi

if [[ ${EAPI} == 8 ]]; then
	EXPORT_FUNCTIONS pkg_setup
fi

EXPORT_FUNCTIONS src_prepare src_configure
