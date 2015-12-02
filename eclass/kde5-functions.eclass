# Copyright 1999-2015 Gentoo Foundation
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
# Currently EAPI 5 is supported.
case ${EAPI} in
	5) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

# @ECLASS-VARIABLE: FRAMEWORKS_MINIMAL
# @DESCRIPTION:
# Minimal Frameworks version to require for the package.
: ${FRAMEWORKS_MINIMAL:=5.14.0}

# @ECLASS-VARIABLE: PLASMA_MINIMAL
# @DESCRIPTION:
# Minimal Plasma version to require for the package.
: ${PLASMA_MINIMAL:=5.4.1}

# @ECLASS-VARIABLE: KDE_APPS_MINIMAL
# @DESCRIPTION:
# Minimal KDE Applicaions version to require for the package.
: ${KDE_APPS_MINIMAL:=14.12.0}

# @ECLASS-VARIABLE: KDE_GCC_MINIMAL
# @DESCRIPTION:
# Minimal GCC version to require for the package.
: ${KDE_GCC_MINIMAL:=4.8}

# @ECLASS-VARIABLE: KDEBASE
# @DESCRIPTION:
# This gets set to a non-zero value when a package is considered a kde or
# kdevelop ebuild.
if [[ ${CATEGORY} = kde-base ]]; then
	KDEBASE=kde-base
elif [[ ${CATEGORY} = kde-frameworks ]]; then
	KDEBASE=kde-frameworks
elif [[ ${KMNAME-${PN}} = kdevelop ]]; then
	KDEBASE=kdevelop
fi

debug-print "${ECLASS}: ${KDEBASE} ebuild recognized"

# @ECLASS-VARIABLE: KDE_SCM
# @DESCRIPTION:
# SCM to use if this is a live ebuild.
: ${KDE_SCM:=git}

case ${KDE_SCM} in
	svn|git) ;;
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
	if [[ ${MERGE_TYPE} != binary ]]; then
		local version=$(gcc-version)
		local major=${version%.*}
		local minor=${version#*.}
		local min_major=${KDE_GCC_MINIMAL%.*}
		local min_minor=${KDE_GCC_MINIMAL#*.}

		[[ ${major} -lt ${min_major} ]] || \
				( [[ ${major} -eq ${min_major} && ${minor} -lt ${min_minor} ]] ) \
			&& die "Sorry, but gcc-${KDE_GCC_MINIMAL} or later is required for this package."
	fi
}

# @FUNCTION: _add_kdecategory_dep
# @INTERNAL
# @DESCRIPTION:
# Implementation of add_plasma_dep and add_frameworks_dep.
_add_kdecategory_dep() {
	debug-print-function ${FUNCNAME} "$@"

	local category=${1}
	local package=${2}
	local use=${3}
	local version=${4}
	local slot=

	if [[ -n ${use} ]] ; then
		local use="[${use}]"
	fi

	if [[ -n ${version} ]] ; then
		local operator=">="
		local version="-$(get_version_component_range 1-3 ${version})"
	fi

	if [[ ${SLOT} = 4 || ${SLOT} = 5 ]] && ! has kde5-meta-pkg ${INHERITED} ; then
		slot=":${SLOT}"
	fi

	echo " ${operator}${category}/${package}${version}${slot}${use}"
}

# @FUNCTION: add_frameworks_dep
# @USAGE: <package> [USE flags] [minimum version]
# @DESCRIPTION:
# Create proper dependency for kde-frameworks/ dependencies.
# This takes 1 to 3 arguments. The first being the package name, the optional
# second is additional USE flags to append, and the optional third is the
# version to use instead of the automatic version (use sparingly).
# The output of this should be added directly to DEPEND/RDEPEND, and may be
# wrapped in a USE conditional (but not an || conditional without an extra set
# of parentheses).
add_frameworks_dep() {
	debug-print-function ${FUNCNAME} "$@"

	local version

	if [[ -n ${3} ]]; then
		version=${3}
	elif [[ ${CATEGORY} = kde-frameworks ]]; then
		version=$(get_version_component_range 1-2)
	elif [[ -z "${version}" ]] ; then
		version=${FRAMEWORKS_MINIMAL}
	fi

	_add_kdecategory_dep kde-frameworks "${1}" "${2}" "${version}"
}

# @FUNCTION: add_plasma_dep
# @USAGE: <package> [USE flags] [minimum version]
# @DESCRIPTION:
# Create proper dependency for kde-base/ dependencies.
# This takes 1 to 3 arguments. The first being the package name, the optional
# second is additional USE flags to append, and the optional third is the
# version to use instead of the automatic version (use sparingly).
# The output of this should be added directly to DEPEND/RDEPEND, and may be
# wrapped in a USE conditional (but not an || conditional without an extra set
# of parentheses).
add_plasma_dep() {
	debug-print-function ${FUNCNAME} "$@"

	local version

	if [[ -n ${3} ]]; then
		version=${3}
	elif [[ ${CATEGORY} = kde-plasma ]]; then
		version=${PV}
	elif [[ -z "${version}" ]] ; then
		version=${PLASMA_MINIMAL}
	fi

	_add_kdecategory_dep kde-plasma "${1}" "${2}" "${version}"
}

# @FUNCTION: add_kdeapps_dep
# @USAGE: <package> [USE flags] [minimum version]
# @DESCRIPTION:
# Create proper dependency for kde-apps/ dependencies.
# This takes 1 to 3 arguments. The first being the package name, the optional
# second is additional USE flags to append, and the optional third is the
# version to use instead of the automatic version (use sparingly).
# The output of this should be added directly to DEPEND/RDEPEND, and may be
# wrapped in a USE conditional (but not an || conditional without an extra set
# of parentheses).
add_kdeapps_dep() {
	debug-print-function ${FUNCNAME} "$@"

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

	_add_kdecategory_dep kde-apps "${1}" "${2}" "${version}"
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

# @FUNCTION: punt_bogus_dep
# @USAGE: <prefix> <dependency>
# @DESCRIPTION:
# Removes a specified dependency from a find_package call with multiple components.
punt_bogus_dep() {
	local prefix=${1}
	local dep=${2}

	pcregrep -Mni "(?s)find_package\s*\(\s*${prefix}.[^)]*?${dep}.*?\)" CMakeLists.txt > "${T}/bogus${dep}"

	# pcregrep returns non-zero on no matches/error
	if [[ $? != 0 ]] ; then
		return
	fi

	local length=$(wc -l "${T}/bogus${dep}" | cut -d " " -f 1)
	local first=$(head -n 1 "${T}/bogus${dep}" | cut -d ":" -f 1)
	local last=$(( ${length} + ${first} - 1))

	sed -e "${first},${last}s/${dep}//" -i CMakeLists.txt || die

	if [[ ${length} = 1 ]] ; then
		sed -e "/find_package\s*(\s*${prefix}\s*REQUIRED\s*COMPONENTS\s*)/I d" -i CMakeLists.txt || die
	fi
}

fi
