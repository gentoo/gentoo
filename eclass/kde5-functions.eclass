# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: kde5-functions.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: Common ebuild functions for KDE 5 packages
# @DESCRIPTION:
# This eclass contains all functions shared by the different eclasses,
# for KDE 5 ebuilds.

if [[ -z ${_KDE5_FUNCTIONS_ECLASS} ]]; then
_KDE5_FUNCTIONS_ECLASS=1

inherit toolchain-funcs versionator

# @ECLASS-VARIABLE: EAPI
# @DESCRIPTION:
# Currently EAPI 6 is supported.
case ${EAPI} in
	6) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

# @ECLASS-VARIABLE: QT_MINIMAL
# @DESCRIPTION:
# Minimal Qt version to require for the package.
: ${QT_MINIMAL:=5.6.1}

# @ECLASS-VARIABLE: FRAMEWORKS_MINIMAL
# @DESCRIPTION:
# Minimal Frameworks version to require for the package.
: ${FRAMEWORKS_MINIMAL:=5.26.0}

# @ECLASS-VARIABLE: PLASMA_MINIMAL
# @DESCRIPTION:
# Minimal Plasma version to require for the package.
: ${PLASMA_MINIMAL:=5.4.1}

# @ECLASS-VARIABLE: KDE_APPS_MINIMAL
# @DESCRIPTION:
# Minimal KDE Applications version to require for the package.
: ${KDE_APPS_MINIMAL:=14.12.0}

# @ECLASS-VARIABLE: KDE_GCC_MINIMAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# Minimal GCC version to require for the package.

# @ECLASS-VARIABLE: KDEBASE
# @DESCRIPTION:
# This gets set to a non-zero value when a package is considered a
# kdevelop ebuild.
if [[ ${KMNAME-${PN}} = kdevelop ]]; then
	KDEBASE=kdevelop
elif [[ ${KMNAME} = kde-l10n || ${PN} = kde-l10n ]]; then
	KDEBASE=kdel10n
fi

debug-print "${ECLASS}: ${KDEBASE} ebuild recognized"

# @ECLASS-VARIABLE: KDE_SCM
# @DESCRIPTION:
# SCM to use if this is a live ebuild.
: ${KDE_SCM:=git}

case ${KDE_SCM} in
	git) ;;
	*) die "KDE_SCM: ${KDE_SCM} is not supported" ;;
esac

# determine the build type
if [[ ${PV} = *9999* ]]; then
	KDE_BUILD_TYPE="live"
else
	KDE_BUILD_TYPE="release"
fi
export KDE_BUILD_TYPE

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
		local version="-$(get_version_component_range 1-3 ${version})"
	fi

	if [[ -n ${slot} ]] ; then
		slot=":${slot}"
	elif [[ ${SLOT%\/*} = 4 || ${SLOT%\/*} = 5 ]] && ! has kde5-meta-pkg ${INHERITED} ; then
		slot=":${SLOT%\/*}"
	fi

	echo " ${operator}${category}/${package}${version}${slot}${use}"
}

# @FUNCTION: add_frameworks_dep
# @USAGE: <package> [USE flags] [minimum version]
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
		version=$(get_version_component_range 1-2)
	elif [[ -z "${version}" ]] ; then
		version=${FRAMEWORKS_MINIMAL}
	fi

	_add_category_dep kde-frameworks "${1}" "${2}" "${version}" "${4}"
}

# @FUNCTION: add_plasma_dep
# @USAGE: <package> [USE flags] [minimum version]
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
		version=${PV}
	elif [[ -z "${version}" ]] ; then
		version=${PLASMA_MINIMAL}
	fi

	_add_category_dep kde-plasma "${1}" "${2}" "${version}" "${4}"
}

# @FUNCTION: add_kdeapps_dep
# @USAGE: <package> [USE flags] [minimum version]
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
		version=${PV}
	elif [[ -z "${version}" ]] ; then
		# In KDE applications world, 5.9999 > yy.mm.x
		if [[ ${PV} = 5.9999 || ${PV} = 9999 ]]; then
			version=5.9999
		else
			version=${KDE_APPS_MINIMAL}
		fi
	fi

	_add_category_dep kde-apps "${1}" "${2}" "${version}" "${4}"
}

# @FUNCTION: add_qt_dep
# @USAGE: <package> [USE flags] [minimum version]
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

	local version

	if [[ -n ${3} ]]; then
		version=${3}
	elif [[ -z "${version}" ]] ; then
		version=${QT_MINIMAL}
	fi

	_add_category_dep dev-qt "${1}" "${2}" "${version}" "${4}"
}

# @FUNCTION: get_kde_version
# @DESCRIPTION:
# Translates an ebuild version into a major.minor KDE SC
# release version. If no version is specified, ${PV} is used.
get_kde_version() {
	local ver=${1:-${PV}}
	local major=$(get_major_version ${ver})
	local minor=$(get_version_component_range 2 ${ver})
	local micro=$(get_version_component_range 3 ${ver})
	if [[ ${ver} == 9999 ]]; then
		echo live
	else
		(( micro < 50 )) && echo ${major}.${minor} || echo ${major}.$((minor + 1))
	fi
}

# @FUNCTION: kde_l10n2lingua
# @USAGE: <l10n>...
# @INTERNAL
# @DESCRIPTION:
# Output KDE lingua flag name(s) (without prefix(es)) appropriate for
# given l10n(s).
kde_l10n2lingua() {
	local l
	for l; do
		case ${l} in
			ca-valencia) echo ca@valencia;;
			sr-ijekavsk) echo sr@ijekavian;;
			sr-Latn-ijekavsk) echo sr@ijekavianlatin;;
			sr-Latn) echo sr@latin;;
			uz-Cyrl) echo uz@cyrillic;;
			*) echo "${l/-/_}";;
		esac
	done
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
