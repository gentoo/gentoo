# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: out-of-source-utils.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: Utility functions for building packages out-of-source
# @DESCRIPTION:
# This eclass provides a run_in_build_dir() helper that can be used
# to execute specified command inside BUILD_DIR.

if [[ -z ${_OUT_OF_SOURCE_UTILS_ECLASS} ]]; then
_OUT_OF_SOURCE_UTILS_ECLASS=1

case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: run_in_build_dir
# @USAGE: <argv>...
# @DESCRIPTION:
# Run the given command in the directory pointed by BUILD_DIR.
run_in_build_dir() {
	debug-print-function ${FUNCNAME} "$@"
	local ret

	[[ ${#} -eq 0 ]] && die "${FUNCNAME}: no command specified."
	[[ -z ${BUILD_DIR} ]] && die "${FUNCNAME}: BUILD_DIR not set."

	mkdir -p "${BUILD_DIR}" || die
	pushd "${BUILD_DIR}" >/dev/null || die
	"${@}"
	ret=${?}
	popd >/dev/null || die

	return ${ret}
}

fi
