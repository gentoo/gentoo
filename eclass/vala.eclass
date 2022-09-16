# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vala.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @AUTHOR:
# Alexandre Rostovtsev <tetromino@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: Sets up the environment for using a specific version of vala.
# @DESCRIPTION:
# This eclass sets up commonly used environment variables for using a specific
# version of dev-lang/vala to configure and build a package.  It is needed for
# packages whose build systems assume the existence of certain unversioned vala
# executables, pkgconfig files, etc., which Gentoo does not provide.

case ${EAPI} in
	6|7) inherit eutils multilib ;;
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_VALA_ECLASS} ]] ; then
_VALA_ECLASS=1

# @ECLASS_VARIABLE: VALA_MIN_API_VERSION
# @DESCRIPTION:
# Minimum vala API version (e.g. 0.56).
VALA_MIN_API_VERSION=${VALA_MIN_API_VERSION:-0.56}

# @ECLASS_VARIABLE: VALA_MAX_API_VERSION
# @DESCRIPTION:
# Maximum vala API version (e.g. 0.56).
VALA_MAX_API_VERSION=${VALA_MAX_API_VERSION:-0.56}

# @ECLASS_VARIABLE: VALA_USE_DEPEND
# @DEFAULT_UNSET
# @DESCRIPTION:
# USE dependencies that vala must be built with (e.g. vapigen).

# @FUNCTION: vala_api_versions
# @DESCRIPTION:
# Outputs a list of vala API versions from VALA_MAX_API_VERSION down to
# VALA_MIN_API_VERSION.
vala_api_versions() {
	[[ ${VALA_MIN_API_VERSION} =~ ^0\.[[:digit:]]+$ ]] || die "Invalid syntax of VALA_MIN_API_VERSION"
	[[ ${VALA_MAX_API_VERSION} =~ ^0\.[[:digit:]]+$ ]] || die "Invalid syntax of VALA_MAX_API_VERSION"

	local minimal_supported_minor_version minor_version

	# Dependency atoms are not generated for Vala versions older than 0.${minimal_supported_minor_version}.
	minimal_supported_minor_version="56"

	for ((minor_version = ${VALA_MAX_API_VERSION#*.}; minor_version >= ${VALA_MIN_API_VERSION#*.}; minor_version = minor_version - 2)); do
		if ((minor_version >= minimal_supported_minor_version)); then
			echo "0.${minor_version}"
		fi
	done
}

# @FUNCTION: _vala_use_depend
# @INTERNAL
# @DESCRIPTION:
# Outputs VALA_USE_DEPEND as a a USE-dependency string
_vala_use_depend() {
	local u="" vala_use

	if [[ -n ${VALA_USE_DEPEND} ]]; then
		for vala_use in ${VALA_USE_DEPEND}; do
			case ${vala_use} in
				vapigen) u="${u},${vala_use}(+)" ;;
				valadoc) u="${u},${vala_use}(-)" ;;
			esac
		done
		u="[${u#,}]"
	fi

	echo -n "${u}"
}

# @FUNCTION: vala_depend
# @DESCRIPTION:
# Outputs a ||-dependency string on vala from VALA_MAX_API_VERSION down to
# VALA_MIN_API_VERSION
vala_depend() {
	local u v
	u=$(_vala_use_depend)

	echo -n "|| ("
	for v in $(vala_api_versions); do
		echo -n " dev-lang/vala:${v}${u}"
	done
	echo " )"
}

# @FUNCTION: vala_best_api_version
# @DESCRIPTION:
# Returns the highest installed vala API version satisfying
# VALA_MAX_API_VERSION, VALA_MIN_API_VERSION, and VALA_USE_DEPEND.
vala_best_api_version() {
	local u v
	local hv_opt="-b"
	[[ ${EAPI} == 6 ]] && hv_opt=""

	u=$(_vala_use_depend)

	for v in $(vala_api_versions); do
		has_version ${hv_opt} "dev-lang/vala:${v}${u}" && echo "${v}" && return
	done
}

# @FUNCTION: vala_setup
# @USAGE: [--ignore-use] [--vala-api-version api_version]
# @DESCRIPTION:
# Sets up the environment variables and pkgconfig files for the
# specified API version, or, if no version is specified, for the
# highest installed vala API version satisfying
# VALA_MAX_API_VERSION, VALA_MIN_API_VERSION, and VALA_USE_DEPEND.
# Is a no-op if called without --ignore-use when USE=-vala.
# Dies if the USE check is passed (or ignored) and a suitable vala
# version is not available.
vala_setup() {
	local p d valafoo version ignore_use
	local hv_opt="-b"
	[[ ${EAPI} == 6 ]] && hv_opt=""

	while [[ $1 ]]; do
		case $1 in
			"--ignore-use" )
				ignore_use=1 ;;
			"--vala-api-version" )
				shift
				version=$1
				[[ ${version} ]] || die "'--vala-api-version' option requires API version parameter."
		esac
		shift
	done

	if [[ -z ${ignore_use} ]]; then
		in_iuse vala && ! use vala && return 0
	fi

	if [[ ${version} ]]; then
		has_version ${hv_opt} "dev-lang/vala:${version}" || die "No installed vala:${version}"
	else
		version=$(vala_best_api_version)
		[[ ${version} ]] || die "No installed vala in $(vala_depend)"
	fi

	export VALAC=$(type -P valac-${version})

	valafoo=$(type -P vala-gen-introspect-${version})
	[[ ${valafoo} ]] && export VALA_GEN_INTROSPECT="${valafoo}"

	valafoo=$(type -P vapigen-${version})
	[[ ${valafoo} ]] && export VAPIGEN="${valafoo}"

	valafoo=$(type -P valadoc-${version})
	[[ ${valafoo} ]] && has valadoc ${VALA_USE_DEPEND} && export VALADOC="${valafoo}"

	valafoo="${EPREFIX}/usr/share/vala/Makefile.vapigen"
	[[ -e ${valafoo} ]] && export VAPIGEN_MAKEFILE="${valafoo}"

	export VAPIGEN_VAPIDIR="${EPREFIX}/usr/share/vala/vapi"

	mkdir -p "${T}/pkgconfig" || die "mkdir failed"
	for p in libvala vapigen; do
		for d in "${EPREFIX}/usr/$(get_libdir)/pkgconfig" "${EPREFIX}/usr/share/pkgconfig"; do
			if [[ -e ${d}/${p}-${version}.pc ]]; then
				ln -s "${d}/${p}-${version}.pc" "${T}/pkgconfig/${p}.pc" || die "ln failed"
				break
			fi
		done
	done
	: ${PKG_CONFIG_PATH:="${EPREFIX}/usr/$(get_libdir)/pkgconfig:${EPREFIX}/usr/share/pkgconfig"}
	export PKG_CONFIG_PATH="${T}/pkgconfig:${PKG_CONFIG_PATH}"
}

# @FUNCTION: vala_src_prepare
# @DESCRIPTION:
# For backwards compatibility in EAPIs 6 and 7.  Calls vala_setup.
if [[ ${EAPI} == [67] ]]; then
	vala_src_prepare() { vala_setup "$@"; }
fi

fi
