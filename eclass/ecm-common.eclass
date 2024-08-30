# Copyright 2024 Gentoo Authors
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
# Minimum version of Frameworks to require.  Default value for kde-frameworks
# is ${PV} and 6.0.0 baseline for everything else.
# If set to <5.240, it is assumed dependencies are fulfilled by KF5/Qt5
# alternatively, thus a block of SLOT=5 shadow dependencies added.
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: "${KFMIN:=$(ver_cut 1-2)}"
fi
: "${KFMIN:=6.0.0}"

# @ECLASS_VARIABLE: _KFSLOT
# @INTERNAL
# @DESCRIPTION:
# KDE Frameworks main slot dependency for consistently finding all KF5 or KF6
# in CMakeLists.txt.  Consistency over installed KF packages is established via
# BDEPEND, then detected in pkg_setup().
# Is passed as -DQT_MAJOR_VERSION=${_KFSLOT} in src_configure() too.
_KFSLOT=6

# @ECLASS_VARIABLE: KF5_BDEPEND
# @PRE_INHERIT
# @DESCRIPTION:
# Dynamic KF5 dependency list.
if [[ ${KF5_BDEPEND} ]]; then
	[[ ${KF5_BDEPEND@a} == *a* ]] ||
		die "KF5_BDEPEND must be an array"
else
	KF5_BDEPEND=( )
fi

# @ECLASS_VARIABLE: KF6_BDEPEND
# @PRE_INHERIT
# @DESCRIPTION:
# Dynamic KF6 dependency list.
if [[ ${KF6_BDEPEND} ]]; then
	[[ ${KF6_BDEPEND@a} == *a* ]] ||
		die "KF6_BDEPEND must be an array"
else
	KF6_BDEPEND=( )
fi

# @ECLASS_VARIABLE: ECM_I18N
# @PRE_INHERIT
# @DESCRIPTION:
# Will accept "true" (default) or "false".  If set to "false", do nothing.
# Otherwise, add kde-frameworks/ki18n:* to BDEPEND, find KF[56]I18n and let
# ki18n_install(po) generate and install translations.
: "${ECM_I18N:=true}"

# @ECLASS_VARIABLE: ECM_HANDBOOK
# @PRE_INHERIT
# @DESCRIPTION:
# Will accept "true" or "false" (default).  If set to "false", do nothing.
# Otherwise, add "+handbook" to IUSE, add kde-frameworks/kdoctools:* to BDEPEND
# find KF[56]DocTools in CMake, call add_subdirectory(ECM_HANDBOOK_DIRS)
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
# Array of <target>:<subdir> tuples to feed to ECMInstallIcons via
# ecmcommon_generate_desktop_file(<target> <subdir>), which is this
# eclass adaptation of kcmutils_generate_desktop_file.
if [[ ${ECM_KCM_TARGETS} ]]; then
	[[ ${ECM_KCM_TARGETS@a} == *a* ]] ||
		die "ECM_KCM_TARGETS must be an array"
fi

DESCRIPTION="Common files for ${PN/-common/}"

BDEPEND=">=kde-frameworks/extra-cmake-modules-${KFMIN}:*"

case ${ECM_I18N} in
	true)
		KF5_BDEPEND+=( "kde-frameworks/ki18n:5" )
		KF6_BDEPEND+=( "kde-frameworks/ki18n:6" )
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
		KF5_BDEPEND+=( "handbook? ( kde-frameworks/kdoctools:5 )" )
		KF6_BDEPEND+=( "handbook? ( kde-frameworks/kdoctools:6 )" )
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_HANDBOOK}"
		die "Value ${ECM_HANDBOOK} is not supported"
		;;
esac

if [[ ${ECM_KCM_TARGETS} ]]; then
	KF5_BDEPEND+=( "kde-frameworks/kcmutils:5" )
	KF6_BDEPEND+=( "kde-frameworks/kcmutils:6" )
fi

if $(ver_test ${KFMIN} -lt 5.240) && [[ ${KF6_BDEPEND} && ${KF5_BDEPEND} ]]; then
	BDEPEND+=" || ( ( ${KF6_BDEPEND[*]} ) ( ${KF5_BDEPEND[*]} ) )"
else
	BDEPEND+=" ${KF6_BDEPEND[*]}"
fi

# @FUNCTION: _ecm-common_preamble
# @INTERNAL
# @DESCRIPTION:
# Create a CMakeLists.txt file with minimum ECM setup.
_ecm-common_preamble() {
	cat > CMakeLists.txt <<- _EOF_ || die
		cmake_minimum_required(VERSION 3.16)
		project(${PN} VERSION ${PV})

		find_package(ECM "${KFMIN}" REQUIRED NO_MODULE)
		set(CMAKE_MODULE_PATH \${ECM_MODULE_PATH})

		# Set by pkg_setup(); Use this if need to differ between KF5 or KF6
		set(KFSLOT ${_KFSLOT})
		set(KDE_INSTALL_DOCBUNDLEDIR "${EPREFIX}/usr/share/help" CACHE PATH "")

		include(KDEInstallDirs)
		include(ECMOptionalAddSubdirectory) # commonly used
		include(FeatureSummary)
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
# Find KF[56]I18n and call ki18n_install(po).
_ecm-common_i18n() {
	[[ ${ECM_I18N} == true ]] || return
	cat >> CMakeLists.txt <<- _EOF_ || die
		find_package(KF\${KFSLOT}I18n REQUIRED)
		ki18n_install(po)
	_EOF_
}

# @FUNCTION: _ecm-common_docs
# @INTERNAL
# @DESCRIPTION:
# Find KF[56]DocTools, call kdoctools_install(po) and
# add_subdirectory(${ECM_HANDBOOK_DIRS})
_ecm-common_docs() {
	{ in_iuse handbook && use handbook; } || return

	cat >> CMakeLists.txt <<- _EOF_ || die
		find_package(KF\${KFSLOT}DocTools REQUIRED)
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
# Find KF[56]KCMUtils and iterate through ECM_KCM_TARGETS to generate
# desktop files out of json.
_ecm-common_generate_desktop_file() {
	[[ ${ECM_KCM_TARGETS} ]] || return

	cat >> CMakeLists.txt <<- _EOF_ || die
		find_package(KF\${KFSLOT}KCMUtils REQUIRED)
		# extracted from kcmutils_generate_desktop_file(kcm_target)
		function(ecmcommon_generate_desktop_file kcm_target subdir)
			set(IN_FILE \${CMAKE_CURRENT_SOURCE_DIR}/\${subdir}\${kcm_target}.json)
			set(OUT_FILE \${CMAKE_CURRENT_BINARY_DIR}/\${kcm_target}.desktop)
			add_custom_target(\${kcm_target}-kcm-desktop-gen ALL
				COMMAND KF\${KFSLOT}::kcmdesktopfilegenerator \${IN_FILE} \${OUT_FILE}
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
# Just calls feature_summary
_ecm-common_summary() {
	cat >> CMakeLists.txt <<- _EOF_ || die

		feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
	_EOF_
}

# @FUNCTION: _ecm-common-check_deps
# @INTERNAL
# @DESCRIPTION:
# Check existence of requested KF6 dependencies.
_ecm-common-check_deps() {
	local chk=0
	case ${1} in
		i18n)
			if [[ ${ECM_I18N} ]]; then
				chk=$(has_version -b "kde-frameworks/ki18n:6")
			fi
			;;
		doctools)
			if [[ ${ECM_HANDBOOK} ]] && in_iuse handbook; then
				if use handbook; then
					chk=$(has_version -b "kde-frameworks/kdoctools:6")
				fi
			fi
			;;
		kcmutils)
			if [[ ${ECM_KCM_TARGETS} ]]; then
				chk=$(has_version -b "kde-frameworks/kcmutils:6")
			fi
			;;
		*)
			eerror "Unknown value for _ecm-common-check_deps()"
			die "Value ${1} is not supported"
			;;
	esac
	return ${chk}
}

# @FUNCTION: ecm-common-check_deps
# @DESCRIPTION:
# Override this to add more KF6 has_version checks to pkg_setup(),
# corresponding with any additional KF6_BDEPEND defined pre-inherit.
# If false, we'll assume KF5 dependencies are fulfilled via BDEPEND.
ecm-common-check_deps() {
	return 0
}

# @FUNCTION: ecm-common_pkg_setup
# @DESCRIPTION:
# If KFMIN is not lower than 5.240 (default is 6.0.0), do nothing.
# Otherwise, dDetermine which of KF5 or KF6-based depgraph is complete,
# preferring KF6.  The result is stored in _KFSLOT, which is then handed
# to CMakeLists.txt as KFSLOT var for further use.
ecm-common_pkg_setup() {
	$(ver_test ${KFMIN} -ge 5.240) && return

	if _ecm-common-check_deps i18n && _ecm-common-check_deps doctools &&
		_ecm-common-check_deps kcmutils && ecm-common-check_deps
	then
		_KFSLOT=6
	else
		_KFSLOT=5
	fi
}

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
# Passes -DQT_MAJOR_VERSION=${_KFSLOT} only.
ecm-common_src_configure() {
	# necessary for at least KF6KCMUtils
	local mycmakeargs=( -DQT_MAJOR_VERSION=${_KFSLOT} )
	cmake_src_configure
}

fi

EXPORT_FUNCTIONS pkg_setup src_prepare src_configure
