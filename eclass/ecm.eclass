# Copyright 1999-2025 Gentoo Authors
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
# By default, for all CATEGORIES except kde-frameworks, assume we are building
# a GUI application. Add dependency on kde-frameworks/breeze-icons or
# kde-frameworks/oxygen-icons. With KFMIN lower than 6.9.0, inherit xdg.eclass,
# run pkg_preinst, pkg_postinst and pkg_postrm. If set to "true", do nothing.
: "${ECM_NONGUI:=false}"
if [[ ${CATEGORY} == kde-frameworks ]]; then
	ECM_NONGUI=true
fi

# @ECLASS_VARIABLE: ECM_KDEINSTALLDIRS
# @DESCRIPTION:
# Assume the package is using KDEInstallDirs macro and switch
# KDE_INSTALL_USE_QT_SYS_PATHS to ON. If set to "false", do nothing.
: "${ECM_KDEINSTALLDIRS:=true}"

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
# KF${_KFSLOT}DocTools generate and install the handbook from docbook file(s)
# found in ECM_HANDBOOK_DIR. However if !handbook, disable build of
# ECM_HANDBOOK_DIR in CMakeLists.txt.
# If set to "optional", build with
# -DCMAKE_DISABLE_FIND_PACKAGE_KF${_KFSLOT}DocTools=ON when !handbook. In case
# package requires KF5KDELibs4Support, see next:
# If set to "forceoptional", remove a KF${_KFSLOT}DocTools dependency from the
# root CMakeLists.txt in addition to the above.
: "${ECM_HANDBOOK:=false}"

# @ECLASS_VARIABLE: ECM_HANDBOOK_DIR
# @DESCRIPTION:
# Specifies the directory containing the docbook file(s) relative to ${S} to
# be processed by KF${_KFSLOT}DocTools (kdoctools_install).
: "${ECM_HANDBOOK_DIR:=doc}"

# @ECLASS_VARIABLE: ECM_PO_DIRS
# @PRE_INHERIT
# @DESCRIPTION:
# Specifies directories of l10n files relative to ${S} to be processed by
# KF${_KFSLOT}I18n (ki18n_install). If IUSE nls exists and is disabled then
# disable build of these directories in CMakeLists.txt.
if [[ ${ECM_PO_DIRS} ]]; then
	[[ ${ECM_PO_DIRS@a} == *a* ]] ||
		die "ECM_PO_DIRS must be an array"
else
	ECM_PO_DIRS=( po poqm )
fi

# @ECLASS_VARIABLE: ECM_PYTHON_BINDINGS
# @DESCRIPTION:
# Default value is "false", which means do nothing.
# If set to "off", pass -DBUILD_PYTHON_BINDINGS=OFF to mycmakeargs, and also
# disable cmake finding Python3, PySide6 and Shiboken6 to make it quiet.
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
	: "${ECM_QTHELP:=true}"
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
# Will accept "true", "false", "forceoptional", and "forceoptional-recursive".
# For KF5-based ebuilds, additionally accepts "optional".
# Default value is "false", except for CATEGORY=kde-frameworks where it is
# set to "true". If set to "false", do nothing.
# For any other value, add "test" to IUSE. If set to "forceoptional", ignore
# "autotests", "test", "tests" subdirs from top-level CMakeLists.txt when
# USE=!test. If set to "forceoptional-recursive", make autotest(s), unittest(s)
# and test(s) subdirs from *any* CMakeLists.txt in ${S} and below conditional
# on BUILD_TESTING when USE=!test. This is always meant as a short-term fix and
# creates ${T}/${P}-tests-optional.patch to refine and submit upstream.
# For KF5-based ebuilds:
# Additionally DEPEND on dev-qt/qttest:5 if USE=test, but punt Qt5Test
# dependency if set to "forceoptional*" with USE=!test.
# If set to "optional", build with -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=ON
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
# is ${PV} and 5.116.0 baseline for everything else.
# If set to >=5.240, KF6/Qt6 is assumed thus SLOT=6 dependencies added and
# -DQT_MAJOR_VERSION=6 added to cmake args.
if [[ ${CATEGORY} = kde-frameworks ]]; then
	: "${KFMIN:=$(ver_cut 1-2)}"
fi
: "${KFMIN:=5.116.0}"

if ver_test ${KFMIN} -lt 6.9 && [[ ${ECM_NONGUI} == false ]]; then
	inherit xdg
fi

# @ECLASS_VARIABLE: _KFSLOT
# @INTERNAL
# @DESCRIPTION:
# KDE Frameworks and Qt main slot dependency, implied by KFMIN version, *not*
# necessarily the package's SLOT. This is being used throughout the eclass to
# depend on either :5 or :6 Qt/KF packages as well as setting correctly
# prefixed cmake args.
: "${_KFSLOT:=5}"
if [[ ${CATEGORY} == kde-frameworks ]]; then
	ver_test ${KFMIN} -ge 5.240 && _KFSLOT=6
else
	if [[ ${KFMIN/.*} == 6 ]] || $(ver_test ${KFMIN} -ge 5.240); then
		_KFSLOT=6
	fi
fi

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
		if [[ ${_KFSLOT} == 6 ]]; then
			BDEPEND+=" designer? ( dev-qt/qttools:${_KFSLOT}[designer] )"
		else
			BDEPEND+=" designer? ( dev-qt/designer:${_KFSLOT} )"
		fi
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
		BDEPEND+=" handbook? ( >=kde-frameworks/kdoctools-${KFMIN}:${_KFSLOT} )"
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
		COMMONDEPEND+=" doc? ( dev-qt/qt-docs:${_KFSLOT} )"
		BDEPEND+=" doc? ( >=app-text/doxygen-1.8.13-r1 )"
		if [[ ${_KFSLOT} == 6 ]]; then
			BDEPEND+=" dev-qt/qttools:${_KFSLOT}[assistant]"
		else
			BDEPEND+=" doc? ( dev-qt/qthelp:${_KFSLOT} )"
		fi
		;;
	false) ;;
	*)
		eerror "Unknown value for \${ECM_QTHELP}"
		die "Value ${ECM_QTHELP} is not supported"
		;;
esac

case ${ECM_TEST} in
	optional)
		if [[ ${_KFSLOT} != 5 ]]; then
			eerror "Banned value for \${ECM_TEST}"
			die "Value ${ECM_TEST} is only supported in KF5"
		fi
		;;
	true|forceoptional|forceoptional-recursive) ;;
	false) ;;
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
if [[ ${_KFSLOT} == 6 ]]; then
	RDEPEND+=" >=kde-frameworks/kf-env-6"
	COMMONDEPEND+=" dev-qt/qtbase:${_KFSLOT}"
else
	RDEPEND+=" >=kde-frameworks/kf-env-4"
	COMMONDEPEND+=" dev-qt/qtcore:${_KFSLOT}"
	if [[ ${ECM_TEST} != false ]]; then
		DEPEND+=" test? ( dev-qt/qttest:5 )"
	fi
fi

DEPEND+=" ${COMMONDEPEND}"
RDEPEND+=" ${COMMONDEPEND}"
unset COMMONDEPEND

# @FUNCTION: _ecm_handbook_optional
# @DESCRIPTION:
# Use with ECM_HANDBOOK=optional; ticks either -DBUILD_DOC if available,
# or -DCMAKE_DISABLE_FIND_PACKAGE_KF${_KFSLOT}DocTools
_ecm_handbook_optional() {
	if grep -Eq "option.*BUILD_DOC" CMakeLists.txt; then
		echo "-DBUILD_DOC=$(usex handbook)"
	else
		echo "-DCMAKE_DISABLE_FIND_PACKAGE_KF${_KFSLOT}DocTools=$(usex !handbook)"
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
		eqawarn "QA notice: ecm_pkg_${1} has become a no-op."
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
		# always install unconditionally for kconfigwidgets - if you use
		# language X as system language, and there is a combobox with language
		# names, the translated language name for language Y is taken from
		# /usr/share/locale/Y/kf${_KFSLOT}_entry.desktop
		[[ ${PN} != kconfigwidgets ]] && _ecm_strip_handbook_translations
	fi

	# only build unit tests when required
	if ! { in_iuse test && use test; } ; then
		if [[ ${ECM_TEST} = forceoptional ]] ; then
			[[ ${_KFSLOT} = 5 ]] && ecm_punt_qt_module Test
			# if forceoptional, also cover non-kde categories
			cmake_comment_add_subdirectory appiumtests autotests test tests
		elif [[ ${ECM_TEST} = forceoptional-recursive ]] ; then
			[[ ${_KFSLOT} = 5 ]] && ecm_punt_qt_module Test
			local f pf="${T}/${P}"-tests-optional.patch
			touch ${pf} || die "Failed to touch patch file"
			for f in $(find . -type f -name "CMakeLists.txt" -exec \
				grep -li "^\s*add_subdirectory\s*\(\s*.*\(auto|unit\)\?tests\?\s*)\s*\)" {} \;); do
				cp ${f} ${f}.old || die "Failed to prepare patch origfile"
				pushd ${f%/*} > /dev/null || die
					ecm_punt_qt_module Test
					sed -i CMakeLists.txt -e \
						"/^#/! s/add_subdirectory\s*\(\s*.*\(auto|unit\)\?tests\?\s*)\s*\)/if(BUILD_TESTING)\n&\nendif()/I" \
						|| die
				popd > /dev/null || die
				diff -Naur ${f}.old ${f} 1>>${pf}
				rm ${f}.old || die "Failed to clean up"
			done
			eqawarn "QA notice: Build system modified by ECM_TEST=forceoptional-recursive."
			eqawarn "Unified diff file ready for pickup in:"
			eqawarn "  ${pf}"
			eqawarn "Push it upstream to make this message go away."
		elif [[ -n ${_KDE_ORG_ECLASS} ]] ; then
			cmake_comment_add_subdirectory appiumtests autotests test tests
		fi
	fi

	# in frameworks, tests = manual tests so never build them
	if [[ -n ${_FRAMEWORKS_KDE_ORG_ECLASS} ]] && [[ ${PN} != extra-cmake-modules ]]; then
		cmake_comment_add_subdirectory tests
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

	if [[ ${_KFSLOT} == 6 ]]; then
		cmakeargs+=( -DQT_MAJOR_VERSION=6 )
	fi

	if in_iuse test && ! use test ; then
		cmakeargs+=( -DBUILD_TESTING=OFF )

		if [[ ${_KFSLOT} = 5 && ${ECM_TEST} = optional ]] ; then
			cmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_Qt5Test=ON )
		fi
	fi

	if [[ ${ECM_HANDBOOK} = optional ]] ; then
		cmakeargs+=( $(_ecm_handbook_optional) )
	fi

	if in_iuse designer && [[ ${ECM_DESIGNERPLUGIN} = true ]]; then
		cmakeargs+=( -DBUILD_DESIGNERPLUGIN=$(usex designer) )
	fi

	if [[ ${ECM_PYTHON_BINDINGS} == off ]]; then
		cmakeargs+=(
			-DBUILD_PYTHON_BINDINGS=OFF
			-DCMAKE_DISABLE_FIND_PACKAGE_{Python3,PySide6,Shiboken6}=ON
		)
	fi

	if [[ ${ECM_QTHELP} = true ]]; then
		cmakeargs+=( -DBUILD_QCH=$(usex doc) )
	fi

	if [[ ${ECM_KDEINSTALLDIRS} = true ]] ; then
		cmakeargs+=(
			# install mkspecs in the same directory as Qt stuff
			-DKDE_INSTALL_USE_QT_SYS_PATHS=ON
			# move handbook outside of doc dir, bug 667138
			-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help"
		)

		# bug 928345
		# TODO: Eventually it should be put to upstream as to why LIBEXECDIR
		# in KDEInstallDirsCommon.cmake is set to EXECROOTDIR/LIBDIR/libexec
		[[ ${_KFSLOT} == 6 ]] && \
			cmakeargs+=( -DKDE_INSTALL_LIBEXECDIR="${EPREFIX}/usr/libexec" )
	fi

	# allow the ebuild to override what we set here
	mycmakeargs=("${cmakeargs[@]}" "${mycmakeargs[@]}")

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

	cmake_src_install

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

	if [[ -n ${_KDE_ORG_ECLASS} && -d "${ED}"/usr/share/metainfo/ ]]; then
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
		eqawarn "QA notice: ecm_pkg_${1} has become a no-op."
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
