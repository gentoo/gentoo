# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kde5-functions.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 7
# @BLURB: Common ebuild functions for packages based on KDE Frameworks 5.
# @DESCRIPTION:
# This eclass contains functions shared by the other KDE eclasses and forms
# part of their public API.
#
# This eclass should (almost) never be inherited directly by an ebuild.

if [[ -z ${_KDE5_FUNCTIONS_ECLASS} ]]; then
_KDE5_FUNCTIONS_ECLASS=1

inherit toolchain-funcs

case ${EAPI} in
	7) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

# @ECLASS-VARIABLE: KDE_BUILD_TYPE
# @DESCRIPTION:
# If PV matches "*9999*", this is automatically set to "live".
# Otherwise, this is automatically set to "release".
KDE_BUILD_TYPE="release"
if [[ ${PV} = *9999* ]]; then
	KDE_BUILD_TYPE="live"
fi
export KDE_BUILD_TYPE

case ${CATEGORY} in
	kde-frameworks)
		[[ ${KDE_BUILD_TYPE} = live ]] && : ${FRAMEWORKS_MINIMAL:=9999}
		;;
	kde-plasma)
		[[ ${PV} = 5.17* ]] && : ${FRAMEWORKS_MINIMAL:=5.63.0}
		[[ ${KDE_BUILD_TYPE} = live ]] && : ${FRAMEWORKS_MINIMAL:=9999}
		;;
esac

# @ECLASS-VARIABLE: QT_MINIMAL
# @DESCRIPTION:
# Minimum version of Qt to require. This affects add_qt_dep.
: ${QT_MINIMAL:=5.12.3}

# @ECLASS-VARIABLE: FRAMEWORKS_MINIMAL
# @DESCRIPTION:
# Minimum version of Frameworks to require. This affects add_frameworks_dep.
: ${FRAMEWORKS_MINIMAL:=5.60.0}

# @ECLASS-VARIABLE: PLASMA_MINIMAL
# @DESCRIPTION:
# Minimum version of Plasma to require. This affects add_plasma_dep.
: ${PLASMA_MINIMAL:=5.15.5}

# @ECLASS-VARIABLE: KDE_APPS_MINIMAL
# @DESCRIPTION:
# Minimum version of KDE Applications to require. This affects add_kdeapps_dep.
: ${KDE_APPS_MINIMAL:=19.04.3}

# @ECLASS-VARIABLE: KDE_GCC_MINIMAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# Minimum version of active GCC to require. This is checked in kde5.eclass in
# kde5_pkg_pretend and kde5_pkg_setup.

# @FUNCTION: _check_gcc_version
# @INTERNAL
# @DESCRIPTION:
# Determine if the current GCC version is acceptable, otherwise die.
_check_gcc_version() {
	if [[ ${MERGE_TYPE} != binary && -v KDE_GCC_MINIMAL ]] && tc-is-gcc; then

		local version=$(gcc-version)
		local major=${version%.*}
		local minor=${version#*.}
		local min_major=${KDE_GCC_MINIMAL%.*}
		local min_minor=${KDE_GCC_MINIMAL#*.}

		debug-print "GCC version check activated"
		debug-print "Version detected:"
		debug-print "	- Full: ${version}"
		debug-print "	- Major: ${major}"
		debug-print "	- Minor: ${minor}"
		debug-print "Version required:"
		debug-print "	- Major: ${min_major}"
		debug-print "	- Minor: ${min_minor}"

		[[ ${major} -lt ${min_major} ]] || \
				( [[ ${major} -eq ${min_major} && ${minor} -lt ${min_minor} ]] ) \
			&& die "Sorry, but gcc-${KDE_GCC_MINIMAL} or later is required for this package (found ${version})."
	fi
}

# @FUNCTION: _add_category_dep
# @INTERNAL
# @DESCRIPTION:
# Implementation of add_plasma_dep, add_frameworks_dep, add_kdeapps_dep,
# and finally, add_qt_dep.
_add_category_dep() {
	debug-print-function ${FUNCNAME} "$@"

	local category=${1}
	local package=${2}
	local use=${3}
	local version=${4}
	local slot=${5}

	if [[ -n ${use} ]] ; then
		local use="[${use}]"
	fi

	if [[ -n ${version} ]] ; then
		local operator=">="
		local version="-${version}"
	fi

	if [[ -n ${slot} ]] ; then
		slot=":${slot}"
	elif [[ ${SLOT%\/*} = 5 ]] ; then
		slot=":${SLOT%\/*}"
	fi

	echo " ${operator}${category}/${package}${version}${slot}${use}"
}

# @FUNCTION: add_frameworks_dep
# @USAGE: <package name> [USE flags] [minimum version] [slot + operator]
# @DESCRIPTION:
# Create proper dependency for kde-frameworks/ dependencies.
# This takes 1 to 4 arguments. The first being the package name, the optional
# second is additional USE flags to append, and the optional third is the
# version to use instead of the automatic version (use sparingly). In addition,
# the optional fourth argument defines slot+operator instead of automatic slot
# (use even more sparingly).
# The output of this should be added directly to DEPEND/RDEPEND, and may be
# wrapped in a USE conditional (but not an || conditional without an extra set
# of parentheses).
add_frameworks_dep() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ $# -gt 4 ]]; then
		die "${FUNCNAME} was called with too many arguments"
	fi

	local version

	if [[ -n ${3} ]]; then
		version=${3}
	elif [[ ${CATEGORY} = kde-frameworks ]]; then
		version=$(ver_cut 1-2)
	elif [[ -z ${3} ]] ; then
		version=${FRAMEWORKS_MINIMAL}
	fi

	_add_category_dep kde-frameworks "${1}" "${2}" "${version}" "${4}"
}

# @FUNCTION: add_plasma_dep
# @USAGE: <package name> [USE flags] [minimum version] [slot + operator]
# @DESCRIPTION:
# Create proper dependency for kde-plasma/ dependencies.
# This takes 1 to 4 arguments. The first being the package name, the optional
# second is additional USE flags to append, and the optional third is the
# version to use instead of the automatic version (use sparingly). In addition,
# the optional fourth argument defines slot+operator instead of automatic slot
# (use even more sparingly).
# The output of this should be added directly to DEPEND/RDEPEND, and may be
# wrapped in a USE conditional (but not an || conditional without an extra set
# of parentheses).
add_plasma_dep() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ $# -gt 4 ]]; then
		die "${FUNCNAME} was called with too many arguments"
	fi

	local version

	if [[ -n ${3} ]]; then
		version=${3}
	elif [[ ${CATEGORY} = kde-plasma ]]; then
		version=$(ver_cut 1-3)
	elif [[ -z ${3} ]] ; then
		version=${PLASMA_MINIMAL}
	fi

	_add_category_dep kde-plasma "${1}" "${2}" "${version}" "${4}"
}

# @FUNCTION: add_kdeapps_dep
# @USAGE: <package name> [USE flags] [minimum version] [slot + operator]
# @DESCRIPTION:
# Create proper dependency for kde-apps/ dependencies.
# This takes 1 to 4 arguments. The first being the package name, the optional
# second is additional USE flags to append, and the optional third is the
# version to use instead of the automatic version (use sparingly). In addition,
# the optional fourth argument defines slot+operator instead of automatic slot
# (use even more sparingly).
# The output of this should be added directly to DEPEND/RDEPEND, and may be
# wrapped in a USE conditional (but not an || conditional without an extra set
# of parentheses).
add_kdeapps_dep() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ $# -gt 4 ]]; then
		die "${FUNCNAME} was called with too many arguments"
	fi

	local version

	if [[ -n ${3} ]]; then
		version=${3}
	elif [[ ${CATEGORY} = kde-apps ]]; then
		version=$(ver_cut 1-3)
	elif [[ -z ${3} ]] ; then
		version=${KDE_APPS_MINIMAL}
	fi

	_add_category_dep kde-apps "${1}" "${2}" "${version}" "${4}"
}

# @FUNCTION: add_qt_dep
# @USAGE: <package name> [USE flags] [minimum version] [slot + operator]
# @DESCRIPTION:
# Create proper dependency for dev-qt/ dependencies.
# This takes 1 to 4 arguments. The first being the package name, the optional
# second is additional USE flags to append, and the optional third is the
# version to use instead of the automatic version (use sparingly). In addition,
# the optional fourth argument defines slot+operator instead of automatic slot
# (use even more sparingly).
# The output of this should be added directly to DEPEND/RDEPEND, and may be
# wrapped in a USE conditional (but not an || conditional without an extra set
# of parentheses).
add_qt_dep() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ $# -gt 4 ]]; then
		die "${FUNCNAME} was called with too many arguments"
	fi

	local version=${3}
	local slot=${4}

	if [[ -z ${version} ]]; then
		version=${QT_MINIMAL}
	fi
	if [[ -z ${slot} ]]; then
		slot="5"
	fi

	_add_category_dep dev-qt "${1}" "${2}" "${version}" "${slot}"
}

# @FUNCTION: punt_bogus_dep
# @USAGE: <prefix> <dependency>
# @DESCRIPTION:
# Removes a specified dependency from a find_package call with multiple components.
punt_bogus_dep() {
	local prefix=${1}
	local dep=${2}

	if [[ ! -e "CMakeLists.txt" ]]; then
		return
	fi

	pcregrep -Mni "(?s)find_package\s*\(\s*${prefix}[^)]*?${dep}.*?\)" CMakeLists.txt > "${T}/bogus${dep}"

	# pcregrep returns non-zero on no matches/error
	if [[ $? != 0 ]] ; then
		return
	fi

	local length=$(wc -l "${T}/bogus${dep}" | cut -d " " -f 1)
	local first=$(head -n 1 "${T}/bogus${dep}" | cut -d ":" -f 1)
	local last=$(( ${length} + ${first} - 1))

	sed -e "${first},${last}s/${dep}//" -i CMakeLists.txt || die

	if [[ ${length} = 1 ]] ; then
		sed -e "/find_package\s*(\s*${prefix}\(\s\+\(REQUIRED\|CONFIG\|COMPONENTS\|\${[A-Z0-9_]*}\)\)\+\s*)/Is/^/# removed by kde5-functions.eclass - /" -i CMakeLists.txt || die
	fi
}

fi
