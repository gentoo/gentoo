# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gradle.eclass
# @MAINTAINER:
# Gentoo Java Project <java@gentoo.org>
# @AUTHOR:
# Florian Schmaus <flow@gentoo.org>
# @BLURB: common ebuild functions for gradle-based packages.
# @DESCRIPTION:
# This eclass provides support for the gradle build system.  There
# are currently two approaches to using gradle in ebuilds.  You can either
# depend on a gradle system-wide installation from a gradle ebuild, typically
# dev-java/gradle-bin, or, bundle gradle with the ebuild.
#
# To use a system-wide gradle installation, set EGRADLE_MIN and
# EGRADLE_MAX_EXCLUSIVE and declare a BDEPEND on the gradle package.
# @CODE
# inherit gradle
# EGRADLE_MIN=7.3
# EGRADLE_MAX_EXCLUSIVE=8
#
# BDEPEND="|| (dev-java/gradle-bin:7.3 dev-java/gradle-bin:7.4)"
# @CODE
#
# To use a bundled gradle version, set EGRADLE_BUNDLED_VER and add
# $(gradle_src_uri) to SRC_URI.
# @CODE
# inherit gradle
# EGRADLE_BUNDLED_VER=7.6
# SRC_URI="
#     ...
#     $(gradle_src_uri)
# "
# src_unpack() {
#    default
#    gradle_src_unpack
# }
# @CODE
# This "bundles" gradle as part of the ebuild, that is, a gradle
# distribution with the version specified by EGRADLE_BUNDLED_VER
# will be added to SRC_URI, unpacked by gradle_src_unpack, and then
# later used by egradle.
#
# Afterwards, use egradle to invoke gradle.
# @CODE
# src_compile() {
#     egradle build
# }
# @CODE

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GRADLE_ECLASS} ]] ; then
_GRADLE_ECLASS=1

inherit edo

# @ECLASS_VARIABLE: EGRADLE_MIN
# @DEFAULT_UNSET
# @DESCRIPTION:
# Minimum required gradle version.

# @ECLASS_VARIABLE: EGRADLE_MAX_EXCLUSIVE
# @DEFAULT_UNSET
# @DESCRIPTION:
# First gradle version that is not supported.

# @ECLASS_VARIABLE: EGRADLE_EXACT_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# The exact required gradle version.  If set, neither of EGRADLE_MIN
# EGRADLE_MAX_EXCLUSIVE, nor EGRADLE_BUNDLED_VER should be set.

# @ECLASS_VARIABLE: EGRADLE_BUNDLED_VER
# @DEFAULT_UNSET
# @DESCRIPTION:
# The gradle version that will be bundled with this package.  If set,
# neither of EGRADLE_MIN, EGRADLE_MAX_EXCLUSIVE, nor
# EGRADLE_EXACT_VER should be set.

# @ECLASS_VARIABLE: EGRADLE_PARALLEL
# @DESCRIPTION:
# Set to the 'true', the default, to invoke gradle with --parallel.  Set
# to 'false' to disable parallel gradle builds.
: "${EGRADLE_PARALLEL=true}"

# @ECLASS_VARIABLE: EGRADLE_USER_HOME
# @DESCRIPTION:
# Directory used as the user's home directory by gradle. Defaults to
# ${T}/gradle_user_home
: "${EGRADLE_USER_HOME="${T}/gradle_user_home"}"

# @ECLASS_VARIABLE: EGRADLE_OVERRIDE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# User-specified override of the used gradle binary.

# @ECLASS_VARIABLE: EGRADLE_SEARCH_PATH
# @USER_VARIABLE
# @DESCRIPTION:
# Path in which gradle installations are searched.  This path is
# prefixed with BROOT. Defaults to /usr/bin.  Mostly used for
# testing this eclass.
: "${EGRADLE_SEARCH_PATH=/usr/bin}"

# @FUNCTION: gradle-set_EGRADLE
# @DESCRIPTION:
# Set the EGRADLE environment variable.
gradle-set_EGRADLE() {
	[[ -n ${EGRADLE} ]] && return

	if [[ -n ${EGRADLE_OVERRIDE} ]]; then
		EGRADLE="${EGRADLE_OVERRIDE}"
		return
	fi

	if [[ -n ${EGRADLE_BUNDLED_VER} ]]; then
		EGRADLE="${WORKDIR}/gradle-${EGRADLE_BUNDLED_VER}/bin/gradle"
		return
	fi

	local candidate selected selected_ver ver

	for candidate in "${BROOT}${EGRADLE_SEARCH_PATH}"/gradle-*; do
		if [[ ${candidate} != */gradle?(-bin)-+([.0-9]) ]]; then
			continue
		fi

		ver=${candidate##*-}

		if [[ -n ${EGRADLE_EXACT_VER} ]]; then
			ver_test "${ver}" -ne "${EGRADLE_EXACT_VER}" && continue

			selected="${candidate}"
			break
		fi

		if [[ -n ${EGRADLE_MIN} ]] \
			   && ver_test "${ver}" -lt "${EGRADLE_MIN}"; then
			# Candidate does not satisfy EGRADLE_MIN condition.
			continue
		fi

		if [[ -n ${EGRADLE_MAX_EXCLUSIVE} ]] \
			   && ver_test "${ver}" -ge "${EGRADLE_MAX_EXCLUSIVE}"; then
			# Candidate does not satisfy EGRADLE_MAX_EXCLUSIVE condition.
			continue
		fi

		if [[ -n ${selected_ver} ]] \
			   && ver_test "${selected_ver}" -gt "${ver}"; then
			# Candidate is older than the currently selected candidate.
			continue
		fi

		selected="${candidate}"
		selected_ver="${ver}"
	done

	if [[ -z ${selected} ]]; then
		die "Could not find (suitable) gradle installation in ${BROOT}/usr/bin"
	fi

	EGRADLE="${selected}"
}

# @FUNCTION: gradle-src_uri
# @DESCRIPTION:
# Generate SRC_URI data from EGRADLE_BUNDLED_VER.
gradle-src_uri() {
	if [[ -z ${EGRADLE_BUNDLED_VER} ]]; then
		die "Must set EGRADLE_BUNDLED_VER when calling gradle-src_uri"
	fi
	echo "https://services.gradle.org/distributions/gradle-${EGRADLE_BUNDLED_VER}-bin.zip"
}

# @FUNCTION: gradle_src_unpack
# @DESCRIPTION:
# Unpack the "bundled" gradle version.  You must have
# EGRADLE_BUNDLED_VER set when calling this function.
gradle_src_unpack() {
	if [[ -z ${EGRADLE_BUNDLED_VER} ]]; then
		die "Must set EGRADLE_BUNDLED_VER when calling gradle_src_unpack"
	fi

	unpack "gradle-${EGRADLE_BUNDLED_VER}-bin.zip"
}

# @FUNCTION: egradle
# @USAGE: [gradle-args]
# @DESCRIPTION:
# Invoke gradle with the optionally provided arguments.
egradle() {
	gradle-set_EGRADLE

	local gradle_args=(
		--console=plain
		--info
		--stacktrace
		--no-daemon
		--offline
		--no-build-cache
		--gradle-user-home "${EGRADLE_USER_HOME}"
		--project-cache-dir "${T}/gradle_project_cache"
	)

	if ${EGRADLE_PARALLEL}; then
		gradle_args+=( --parallel )
	fi

	local -x JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS} -Duser.home=\"${T}\""
	# TERM needed, otherwise gradle may fail on terms it does not know about
	TERM=xterm \
		edo \
		"${EGRADLE}" "${gradle_args[@]}" "${@}"
}

fi
