# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ecm.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: cmake virtualx
# @BLURB: Support eclass for packages that use KDE Frameworks with ECM.
# @DESCRIPTION:
# This eclass is intended to streamline the creation of ebuilds for packages
# that use cmake and KDE Frameworks' extra-cmake-modules, thereby following
# some of their packaging conventions. It is primarily intended for the three
# upstream release groups (Frameworks, Plasma, Gear) but also for any
# other package that follows similar conventions.
#
# This eclass unconditionally inherits cmake.eclass and all its public
# variables and helper functions (not phase functions) may be considered as part
# of this eclass's API.
#
# This eclass's phase functions are not intended to be mixed and matched, so if
# any phase functions are overridden the version here should also be called.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_ECM_ECLASS} ]]; then
_ECM_ECLASS=1

# @ECLASS_VARIABLE: CMAKE_ECM_MODE
# @DESCRIPTION:
# For proper description see cmake.eclass manpage.
CMAKE_ECM_MODE=true

inherit cmake flag-o-matic

if [[ ${EAPI} == 8 ]]; then
# @ECLASS_VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# For proper description see virtualx.eclass manpage.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: "${VIRTUALX_REQUIRED:=manual}"

inherit toolchain-funcs virtualx
fi

# @ECLASS_VARIABLE: ECM_NONGUI
# @DESCRIPTION:
# By default, for all CATEGORIES except kde-frameworks, set to "false", which
# assumes we are building a GUI application, and depend on breeze-icons or
# oxygen-icons.  If set to "true", do nothing.
: "${ECM_NONGUI:=false}"
if [[ ${CATEGORY} == kde-frameworks ]]; then
	ECM_NONGUI=true
fi

# @ECLASS_VARIABLE: ECM_DEBUG
# @DESCRIPTION:
# Add "debug" to IUSE. If !debug, add -DQT_NO_DEBUG to CPPFLAGS. If set to
# "false", do nothing.
: "${ECM_DEBUG:=true}"

# @ECLASS_VARIABLE: ECM_DESIGNERPLUGIN
# @DESCRIPTION:
# If set to "true", add "designer" to IUSE to toggle build of designer plugins
# and add the necessary BDEPEND. If set to "false", do nothing.
: "${ECM_DESIGNERPLUGIN:=false}"

# @ECLASS_VARIABLE: ECM_EXAMPLES
# @DESCRIPTION:
# By default unconditionally ignore a top-level examples subdirectory.
# If set to "true", add "examples" to IUSE to toggle adding that subdirectory.
: "${ECM_EXAMPLES:=false}"

# @ECLASS_VARIABLE: ECM_HANDBOOK
# @DESCRIPTION:
# Will accept "true", "false", "optional", "forceoptional", "forceoff".
# If set to "false" (default), do nothing.
# Otherwise, add "+handbook" to IUSE, add the appropriate dependency, and let
# KF6DocTools generate and install the handbook from docbook file(s) found in
# ECM_HANDBOOK_DIR. However if !handbook, disable build of ECM_HANDBOOK_DIR in
# CMakeLists.txt.
# If set to "optional", build with -DCMAKE_DISABLE_FIND_PACKAGE_KF6DocTools=ON
# when !handbook.
# If set to "forceoptional", remove a KF6DocTools dependency from the root
# CMakeLists.txt in addition to the above.
: "${ECM_HANDBOOK:=false}"

# @ECLASS_VARIABLE: ECM_HANDBOOK_DIR
# @DESCRIPTION:
# Specifies the directory containing the docbook file(s) relative to ${S} to
# be processed by KF6DocTools (kdoctools_install).
: "${ECM_HANDBOOK_DIR:=doc}"

# @ECLASS_VARIABLE: ECM_PO_DIRS
# @PRE_INHERIT
# @DESCRIPTION:
# Specifies directories of l10n files relative to ${S} to be processed by
# KF6I18n (ki18n_install). If IUSE nls exists and is disabled then disable
# build of these directories in CMakeLists.txt.
if [[ ${ECM_PO_DIRS} ]]; then
	[[ ${ECM_PO_DIRS@a} == *a* ]] ||
		die "ECM_PO_DIRS must be an array"
else
	ECM_PO_DIRS=( po poqm )
fi

# @ECLASS_VARIABLE: ECM_PYTHON_BINDINGS
# @DESCRIPTION:
# Default value is "false", which means do nothing.
# If set to "off", pass -DBUILD_PYTHON_BINDINGS=OFF to mycmakeargs.
# No other value is implemented as python bindings are not supported in Gentoo.
: "${ECM_PYTHON_BINDINGS:=false}"

# @ECLASS_VARIABLE: ECM_QTHELP
# @DEFAULT_UNSET
# @DESCRIPTION:
# Default value for all CATEGORIES except kde-frameworks is "false".
# If set to "true", add "doc" to IUSE, add the appropriate dependency, let
# -DBUILD_QCH=ON generate and install Qt compressed help files when USE=doc.
# If set to "false", do nothing.
if [[ ${CATEGORY} = kde-frameworks ]]; then
# TODO: Implement KF 6.15 changes how API documentation is built. See also:
#   https://mail.kde.org/pipermail/distributions/2025-June/001595.html
	: "${ECM_QTHELP:=false}"
fi
: "${ECM_QTHELP:=false}"

# @ECLASS_VARIABLE: ECM_REMOVE_FROM_INSTALL
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array of <paths> to remove from install image.
if [[ ${ECM_REMOVE_FROM_INSTALL} ]]; then
	[[ ${ECM_REMOVE_FROM_INSTALL@a} == *a* ]] ||
		die "ECM_REMOVE_FROM_INSTALL must be an array"
fi

# @ECLASS_VARIABLE: ECM_TEST
# @DEFAULT_UNSET
# @DESCRIPTION:
# Will accept "true", "false" or "forceoptional".
# Default value is "false", except for CATEGORY=kde-frameworks where it is
# set to "true". If set to "false", do nothing.
# For any other value, add "test" to IUSE. If set to "forceoptional", ignore
# "appiumtests", "autotests", "test", "tests" subdirs from root CMakeLists.txt
# when USE=!test.
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: "${ECM_TEST:=true}"
fi
: "${ECM_TEST:=false}"

# @ECLASS_VARIABLE: KFMIN
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Minimum version of Frameworks to require. Default value for kde-frameworks
# is ${PV} and 6.22.0 baseline for everything else.  KF5 is unsupported.
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: "${KFMIN:=$(ver_cut 1-2)}"
fi
: "${KFMIN:=6.22.0}"

if ver_test ${KFMIN} -lt 6.9 && [[ ${ECM_NONGUI} == false ]]; then
	inherit xdg
fi

ver_test ${KFMIN} -lt 5.240 && die "KF5 is unsupported!"

# @ECLASS_VARIABLE: KDE_GCC_MINIMAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# Minimum version of active GCC to require. This is checked in
# ecm_pkg_pretend and ecm_pkg_setup.
[[ ${KDE_GCC_MINIMAL} ]] && ver_test ${KFMIN} -ge 6.9 &&
	die "KDE_GCC_MINIMAL has been banned with KFMIN >=6.9.0."

case ${ECM_NONGUI} in
	true) ;;
	false)
		# gui applications need breeze or oxygen for basic iconset, bug #564838
		RDEPEND+=" || (
			kde-frameworks/breeze-icons:*
			kde-frameworks/oxygen-icons:*
		)"
		;;
	*)
		eerror "Unknown value for \${ECM_NONGUI}"
		die "Value ${ECM_NONGUI} is not supported"
		;;
esac

case ${ECM_DEBUG} in
	true)
		IUSE+=" debug"
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_DEBUG}"
		die "Value ${ECM_DEBUG} is not supported"
		;;
esac

case ${ECM_DESIGNERPLUGIN} in
	true)
		IUSE+=" designer"
		BDEPEND+=" designer? ( dev-qt/qttools:6[designer] )"
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_DESIGNERPLUGIN}"
		die "Value ${ECM_DESIGNERPLUGIN} is not supported"
		;;
esac

case ${ECM_EXAMPLES} in
	true)
		IUSE+=" examples"
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_EXAMPLES}"
		die "Value ${ECM_EXAMPLES} is not supported"
		;;
esac

case ${ECM_HANDBOOK} in
	true|optional|forceoptional)
		IUSE+=" +handbook"
		BDEPEND+=" handbook? ( >=kde-frameworks/kdoctools-${KFMIN}:6 )"
		;;
	false|forceoff) ;;
	*)
		eerror "Unknown value for \${ECM_HANDBOOK}"
		die "Value ${ECM_HANDBOOK} is not supported"
		;;
esac

case ${ECM_PYTHON_BINDINGS} in
	off|false) ;;
	true) ;& # TODO if you really really want
	*)
		eerror "Unknown value for \${ECM_PYTHON_BINDINGS}"
		die "Value ${ECM_PYTHON_BINDINGS} is not supported"
		;;
esac

case ${ECM_QTHELP} in
	true)
		IUSE+=" doc"
		COMMONDEPEND+=" doc? ( dev-qt/qt-docs:6 )"
		BDEPEND+=" doc? (
			>=app-text/doxygen-1.8.13-r1
			dev-qt/qttools:6[assistant]
		)"
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_QTHELP}"
		die "Value ${ECM_QTHELP} is not supported"
		;;
esac

case ${ECM_TEST} in
	optional)
		eerror "Banned value for \${ECM_TEST}"
		die "Value ${ECM_TEST} was only supported in KF5"
		;;
	true|false|forceoptional) ;;
	*)
		eerror "Unknown value for \${ECM_TEST}"
		die "Value ${ECM_TEST} is not supported"
		;;
esac

BDEPEND+="
	dev-libs/libpcre2:*
	>=kde-frameworks/extra-cmake-modules-${KFMIN}:*
"
if [[ ${ECM_TEST} != false ]]; then
	IUSE+=" test"
	RESTRICT+=" !test? ( test )"
fi
RDEPEND+=" >=kde-frameworks/kf-env-6"
COMMONDEPEND+=" dev-qt/qtbase:6"

DEPEND+=" ${COMMONDEPEND}"
RDEPEND+=" ${COMMONDEPEND}"
unset COMMONDEPEND

# @FUNCTION: _ecm_handbook_optional
# @INTERNAL
# @DESCRIPTION:
# Use with ECM_HANDBOOK=optional; ticks either -DBUILD_DOC if available,
# or -DCMAKE_DISABLE_FIND_PACKAGE_KF6DocTools
_ecm_handbook_optional() {
	if grep -Eq "option.*BUILD_DOC" CMakeLists.txt; then
		echo "-DBUILD_DOC=$(usex handbook)"
	else
		echo "-DCMAKE_DISABLE_FIND_PACKAGE_KF6DocTools=$(usex !handbook)"
	fi
}

# @FUNCTION: _ecm_buildqch_optional
# @INTERNAL
# @DESCRIPTION:
# Used with ECM_QTHELP; ticks -DBUILD_QCH only if available.
_ecm_buildqch_optional() {
	if use doc; then
		echo "-DBUILD_QCH=ON"
	elif grep -Eq "option.*BUILD_QCH" CMakeLists.txt; then
		echo "-DBUILD_QCH=OFF"
	fi
}

# @FUNCTION: _ecm_disable_unwanted
# @INTERNAL
# @DESCRIPTION:
# Disable unwanted CMake options if they are present.
_ecm_disable_unwanted() {
	if grep -Eq "option.*ENABLE_PCH" CMakeLists.txt; then
		echo "-DENABLE_PCH=OFF"
	fi
	if grep -Eq "option.*WARNINGS_AS_ERRORS" CMakeLists.txt; then
		echo "-DWARNINGS_AS_ERRORS=OFF"
	fi
}

# @FUNCTION: _ecm_strip_handbook_translations
# @INTERNAL
# @DESCRIPTION:
# If LINGUAS is defined, enable only the requested translations when required.
_ecm_strip_handbook_translations() {
	if ! [[ -v LINGUAS ]]; then
		return
	fi

	local lang po
	for po in ${ECM_PO_DIRS[*]}; do
		if [[ -d ${po} ]] ; then
			pushd ${po} > /dev/null || die
			for lang in *; do
				if [[ -e ${lang} ]] && ! has ${lang/.po/} ${LINGUAS} ; then
					case ${lang} in
						cmake_modules | \
						CMakeLists.txt | \
						${PN}.pot)	;;
						*) rm -r ${lang} || die	;;
					esac
					if [[ -e CMakeLists.txt ]] ; then
						cmake_comment_add_subdirectory ${lang}
						sed -e "/add_subdirectory([[:space:]]*${lang}\/.*[[:space:]]*)/d" \
							-i CMakeLists.txt || die
					fi
				fi
			done
			popd > /dev/null || die
		fi
	done
}

# @FUNCTION: _ecm_punt_kfqt_module
# @INTERNAL
# @USAGE: <prefix> <dependency>
# @DESCRIPTION:
# Removes a specified dependency from a find_package call with multiple
# components.
_ecm_punt_kfqt_module() {
	local prefix=${1}
	local dep=${2}

	[[ ! -e "CMakeLists.txt" ]] && return

	# FIXME: dep=WebKit will result in 'Widgets' over 'WebKitWidgets' (no regression)
	pcre2grep -Mni "(?s)find_package\s*\(\s*${prefix}(\d+|\\$\{\w*\})[^)]*?${dep}.*?\)" \
		CMakeLists.txt > "${T}/bogus${dep}"

	# pcre2grep returns non-zero on no matches/error
	[[ $? -ne 0 ]] && return

	local length=$(wc -l "${T}/bogus${dep}" | cut -d " " -f 1)
	local first=$(head -n 1 "${T}/bogus${dep}" | cut -d ":" -f 1)
	local last=$(( length + first - 1))

	sed -e "${first},${last}s/${dep}//" -i CMakeLists.txt || die

	if [[ ${length} -eq 1 ]] ; then
		sed -e "/find_package\s*(\s*${prefix}\([0-9]\|\${[A-Z0-9_]*}\)\(\s\+\(REQUIRED\|CONFIG\|COMPONENTS\|\${[A-Z0-9_]*}\)\)\+\s*)/Is/^/# '${dep}' removed by ecm.eclass - /" \
			-i CMakeLists.txt || die
	fi
}

# @FUNCTION: ecm_punt_kf_module
# @USAGE: <modulename>
# @DESCRIPTION:
# Removes a Frameworks (KF - matching any single-digit version)
# module from a find_package call with multiple components.
ecm_punt_kf_module() {
	_ecm_punt_kfqt_module kf ${1}
}

# @FUNCTION: ecm_punt_qt_module
# @USAGE: <modulename>
# @DESCRIPTION:
# Removes a Qt (matching any single-digit version) module from a
# find_package call with multiple components.
ecm_punt_qt_module() {
	_ecm_punt_kfqt_module qt ${1}
}

# @FUNCTION: ecm_punt_bogus_dep
# @USAGE: <dependency> or <prefix> <dependency>
# @DESCRIPTION:
# Removes a specified dependency from a find_package call, optionally
# supports prefix for find_package with multiple components.
ecm_punt_bogus_dep() {

	if [[ "$#" == 2 ]] ; then
		local prefix=${1}
		local dep=${2}
	elif [[ "$#" == 1 ]] ; then
		local dep=${1}
	else
		die "${FUNCNAME[0]} must be passed either one or two arguments"
	fi

	if [[ ! -e "CMakeLists.txt" ]]; then
		return
	fi

	if [[ -z ${prefix} ]]; then
		sed -e "/find_package\s*(\s*${dep}\(\s\+\(REQUIRED\|CONFIG\|COMPONENTS\|\${[A-Z0-9_]*}\)\)\+\s*)/Is/^/# removed by ecm.eclass - /" \
			-i CMakeLists.txt || die
		return
	else
		pcre2grep -Mni "(?s)find_package\s*\(\s*${prefix}[^)]*?${dep}.*?\)" CMakeLists.txt > "${T}/bogus${dep}"
	fi

	# pcre2grep returns non-zero on no matches/error
	if [[ $? -ne 0 ]] ; then
		return
	fi

	local length=$(wc -l "${T}/bogus${dep}" | cut -d " " -f 1)
	local first=$(head -n 1 "${T}/bogus${dep}" | cut -d ":" -f 1)
	local last=$(( length + first - 1))

	sed -e "${first},${last}s/${dep}//" -i CMakeLists.txt || die

	if [[ ${length} -eq 1 ]] ; then
		sed -e "/find_package\s*(\s*${prefix}\(\s\+\(REQUIRED\|CONFIG\|COMPONENTS\|\${[A-Z0-9_]*}\)\)\+\s*)/Is/^/# removed by ecm.eclass - /" -i CMakeLists.txt || die
	fi
}

# @FUNCTION: _ecm_punt_kdoctools_install
# @INTERNAL
# @DESCRIPTION:
# Disables kdoctools_install(po) call.
_ecm_punt_kdoctools_install() {
	sed -e "s/^ *kdoctools_install.*(\s*po.*)/#& # disabled by ecm.eclass/" \
		-i CMakeLists.txt || die
}

# @FUNCTION: ecm_punt_po_install
# @DESCRIPTION:
# Disables handling of po subdirectories, typically when the package
# is outsourcing common files to a ${PN}-common split package.
ecm_punt_po_install() {
	_ecm_punt_kdoctools_install
	sed -e "s/^ *ki18n_install.*(\s*po.*)/#& # disabled by ecm.eclass/" \
		-i CMakeLists.txt || die
}

if [[ ${EAPI} == 8 ]]; then
# @FUNCTION: _ecm_deprecated_check_gcc_version
# @INTERNAL
# @DESCRIPTION:
# Determine if the current GCC version is acceptable, otherwise die.
_ecm_deprecated_check_gcc_version() {
	if ver_test ${KFMIN} -ge 6.9; then
		eqawarn "QA Notice: ecm_pkg_${1} has become a no-op."
		eqawarn "It is no longer being exported with KFMIN >=6.9.0."
	else
		[[ ${MERGE_TYPE} != binary && -v KDE_GCC_MINIMAL ]] &&
			tc-check-min_ver gcc ${KDE_GCC_MINIMAL}
	fi
}

# @FUNCTION: ecm_pkg_pretend
# @DESCRIPTION:
# Checks if the active compiler meets the minimum version requirements.
# Phase function is only exported if KFMIN is <6.9.0 and KDE_GCC_MINIMAL
# is defined.
ecm_pkg_pretend() {
	debug-print-function ${FUNCNAME} "$@"
	_ecm_deprecated_check_gcc_version pretend
}

# @FUNCTION: ecm_pkg_setup
# @DESCRIPTION:
# Checks if the active compiler meets the minimum version requirements.
# Phase function is only exported if KFMIN is <6.9.0.
ecm_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"
	_ecm_deprecated_check_gcc_version setup
}
fi

# @FUNCTION: ecm_src_prepare
# @DESCRIPTION:
# Wrapper for cmake_src_prepare with lots of extra logic for magic
# handling of linguas, tests, handbook etc.
ecm_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	cmake_src_prepare

	# only build examples when required
	if ! { in_iuse examples && use examples; } ; then
		cmake_comment_add_subdirectory examples
	fi

	# only enable handbook when required
	if [[ ${ECM_HANDBOOK} == forceoff ]] ||
		{ [[ ${ECM_HANDBOOK} = forceoptional ]] && in_iuse handbook && ! use handbook; }
	then
		ecm_punt_kf_module DocTools
		_ecm_punt_kdoctools_install
	fi
	if [[ ${ECM_HANDBOOK} == forceoff ]] ||
		{ in_iuse handbook && ! use handbook; }
	then
		cmake_comment_add_subdirectory ${ECM_HANDBOOK_DIR}
	fi

	# drop translations when nls is not wanted
	if in_iuse nls && ! use nls ; then
		local po
		for po in ${ECM_PO_DIRS}; do
			rm -rf ${po} || die
		done
	fi

	# limit playing field of locale stripping to kde-*/ categories
	if [[ ${CATEGORY} = kde-* ]] ; then
		_ecm_strip_handbook_translations
	fi

	# only build unit tests when required
	if ! { in_iuse test && use test; } ; then
		if has kde.org ${INHERITED} && [[ ${ECM_TEST} != forceoptional ]]; then
			cmake_comment_add_subdirectory appiumtests autotests test tests
		fi
	fi

	# in frameworks, tests = manual tests so never build them
	if has frameworks.kde.org ${INHERITED}; then
		cmake_comment_add_subdirectory tests
	fi

	# disable upstream git hooks (program detection, hook installation ...)
	if [[ -d .git ]]; then
		if grep -Eq "\s*set.*GIT_SOURCE_TARBALL TRUE" CMakeLists.txt; then
			sed -e "/\s*set.*GIT_SOURCE_TARBALL/s/TRUE/FALSE/" -i CMakeLists.txt || die
		fi
	fi
}

# @FUNCTION: ecm_src_configure
# @DESCRIPTION:
# Wrapper for cmake_src_configure with extra logic for magic handling of
# handbook, tests etc.
ecm_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	if in_iuse debug && ! use debug; then
		append-cppflags -DQT_NO_DEBUG
	fi

	local cmakeargs

	if in_iuse test; then
		cmakeargs+=( $(usev !test -DBUILD_TESTING=OFF) )
	fi

	if [[ ${ECM_HANDBOOK} = optional ]] ; then
		cmakeargs+=( $(_ecm_handbook_optional) )
	fi

	if [[ ${ECM_QTHELP} = true ]]; then
		cmakeargs+=( $(_ecm_buildqch_optional) )
	fi

	# disable upstream CMake settings ... currently mostly PIM
	if has gear.kde.org ${INHERITED}; then
		cmakeargs+=( $(_ecm_disable_unwanted) )
	fi

	if in_iuse designer && [[ ${ECM_DESIGNERPLUGIN} = true ]]; then
		cmakeargs+=( -DBUILD_DESIGNERPLUGIN=$(usex designer) )
	fi

	if [[ ${ECM_PYTHON_BINDINGS} == off ]]; then
		cmakeargs+=( -DBUILD_PYTHON_BINDINGS=OFF )
	fi

	# Common ECM configure parameters (invariants)
	local ecm_config=${BUILD_DIR}/gentoo_ecm_config.cmake
	cat > ${ecm_config} <<- _EOF_ || die
		# Gentoo downstream-added ECM options
		set(ECM_DISABLE_QMLPLUGINDUMP ON CACHE BOOL "") # bug #835995, *-disable-qmlplugindump.patch
		set(ECM_DISABLE_APPSTREAMTEST ON CACHE BOOL "") # *-disable-appstreamtest.patch
		set(ECM_DISABLE_GIT ON CACHE BOOL "") # *-disable-git-commit-hooks.patch

		set(BUILD_WITH_QT6 ON CACHE BOOL "") # QtVersionOption.cmake: Hard-require Qt6
		# KDEInstallDirs6 section
		set(KDE_INSTALL_USE_QT_SYS_PATHS ON CACHE BOOL "") # install mkspecs in same dir as Qt stuff
		# move handbook outside of doc dir, bug #667138
		set(KDE_INSTALL_DOCBUNDLEDIR "${EPREFIX}/usr/share/help" CACHE PATH "")
		set(KDE_INSTALL_INFODIR "${EPREFIX}/usr/share/info" CACHE PATH "")
		set(KDE_INSTALL_LIBDIR $(get_libdir) CACHE PATH "Output directory for libraries")
		set(KDE_INSTALL_MANDIR "${EPREFIX}/usr/share/man" CACHE PATH "")

		# TODO: Ask upstream why LIBEXECDIR is set to EXECROOTDIR/LIBDIR/libexec, bug #928345
		set(KDE_INSTALL_LIBEXECDIR "${EPREFIX}/usr/libexec" CACHE PATH "")
	_EOF_

	# allow the ebuild to override what we set here
	mycmakeargs=(
		-C "${ecm_config}"
		"${cmakeargs[@]}"
		"${mycmakeargs[@]}"
	)

	cmake_src_configure
}

# @FUNCTION: ecm_src_compile
# @DESCRIPTION:
# Wrapper for cmake_src_compile. Currently doesn't do anything extra, but
# is included as part of the API just in case it's needed in the future.
ecm_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake_src_compile "$@"
}

# @FUNCTION: ecm_src_test
# @DESCRIPTION:
# Wrapper for cmake_src_test with extra logic for magic handling of dbus
# and virtualx.
ecm_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	_test_runner() {
		if [[ -n "${VIRTUALDBUS_TEST}" ]]; then
			export $(dbus-launch)
		fi

		# KDE_DEBUG stops crash handlers from launching and hanging the test phase
		KDE_DEBUG=1 cmake_src_test "$@"
	}

	local -x QT_QPA_PLATFORM=offscreen

	# When run as normal user during ebuild development with the ebuild command,
	# tests tend to access the session DBUS. This however is not possible in a
	# real emerge or on the tinderbox.
	# make sure it does not happen, so bad tests can be recognized and disabled
	unset DBUS_SESSION_BUS_ADDRESS DBUS_SESSION_BUS_PID

	if [[ ${EAPI} == 8 ]] && [[ ${VIRTUALX_REQUIRED} = always || ${VIRTUALX_REQUIRED} = test ]]; then
		virtx _test_runner "$@"
	else
		_test_runner "$@"
	fi

	if [[ -n "${DBUS_SESSION_BUS_PID}" ]] ; then
		kill ${DBUS_SESSION_BUS_PID}
	fi
}

# @FUNCTION: ecm_src_install
# @DESCRIPTION:
# Wrapper for cmake_src_install. Drops executable bit from .desktop files
# installed inside /usr/share/applications. This is set by cmake when install()
# is called in PROGRAM form, as seen in many kde.org projects.
# In case kde.org.eclass is detected, in case KDE_ORG_NAME != PN, tries real
# hard to detect, then rename, metainfo.xml appdata files to something unique
# including SLOT if else than "0" (basically KDE_ORG_NAME -> PN+SLOT).
ecm_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	cmake_src_install "$@"

	local f
	# bug 621970
	if [[ -d "${ED}"/usr/share/applications ]]; then
		for f in "${ED}"/usr/share/applications/*.desktop; do
			if [[ -x ${f} ]]; then
				einfo "Removing executable bit from ${f#${ED}}"
				fperms a-x "${f#${ED}}"
			fi
		done
	fi

	mv_metainfo() {
		if [[ -f ${1} ]]; then
			mv -v ${1} ${1/${2}/${3}} || die
		fi
	}

	if has kde.org ${INHERITED} && [[ -d "${ED}"/usr/share/metainfo/ ]]; then
		if [[ ${KDE_ORG_NAME} != ${PN} ]]; then
			local ecm_metainfo mainslot=${SLOT%/*}
			pushd "${ED}"/usr/share/metainfo/ > /dev/null || die
			for ecm_metainfo in find * -type f -iname "*metainfo.xml"; do
				case ${ecm_metainfo} in
					*${KDE_ORG_NAME}*)
						mv_metainfo ${ecm_metainfo} ${KDE_ORG_NAME} ${PN}${mainslot/0*/}
						;;
					*${KDE_ORG_NAME/-/_}*)
						mv_metainfo ${ecm_metainfo} ${KDE_ORG_NAME/-/_} ${PN}${mainslot/0*/}
						;;
					org.kde.*)
						mv_metainfo ${ecm_metainfo} "org.kde." "org.kde.${PN}${mainslot/0*/}-"
						;;
				esac
			done
			popd > /dev/null || die
		fi
	fi

	for f in "${ECM_REMOVE_FROM_INSTALL[@]}"; do
		rm -r "${ED}"${f} || die
	done
}

if [[ ${EAPI} == 8 ]]; then
# @FUNCTION: _ecm_nongui_deprecated
# @INTERNAL
# @DESCRIPTION:
# Carryall for ecm_pkg_preinst, ecm_pkg_postinst and ecm_pkg_postrm.
_ecm_nongui_deprecated() {
	if ver_test ${KFMIN} -ge 6.9; then
		eqawarn "QA Notice: ecm_pkg_${1} has become a no-op."
		eqawarn "It is no longer being exported with KFMIN >=6.9.0."
	else
		case ${ECM_NONGUI} in
			false) xdg_pkg_${1} ;;
			*) ;;
		esac
	fi
}

# @FUNCTION: ecm_pkg_preinst
# @DESCRIPTION:
# Sets up environment variables required in ecm_pkg_postinst.
# Phase function is only exported if KFMIN is <6.9.0.
ecm_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"
	_ecm_nongui_deprecated preinst
}

# @FUNCTION: ecm_pkg_postinst
# @DESCRIPTION:
# Updates the various XDG caches (icon, desktop, mime) if necessary.
# Phase function is only exported if KFMIN is <6.9.0.
ecm_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"
	_ecm_nongui_deprecated postinst
}

# @FUNCTION: ecm_pkg_postrm
# @DESCRIPTION:
# Updates the various XDG caches (icon, desktop, mime) if necessary.
# Phase function is only exported if KFMIN is <6.9.0.
ecm_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"
	_ecm_nongui_deprecated postrm
}
fi

fi

if ver_test ${KFMIN} -lt 6.9; then
	EXPORT_FUNCTIONS pkg_setup pkg_preinst pkg_postinst pkg_postrm
	if [[ -v ${KDE_GCC_MINIMAL} ]]; then
		EXPORT_FUNCTIONS pkg_pretend
	fi
fi

EXPORT_FUNCTIONS src_prepare src_configure src_test src_install
