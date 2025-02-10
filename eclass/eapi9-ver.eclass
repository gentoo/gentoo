# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eapi9-ver.eclass
# @MAINTAINER:
# Ulrich Müller <ulm@gentoo.org>
# @AUTHOR:
# Ulrich Müller <ulm@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Testing implementation of EAPI 9 ver_replacing
# @DESCRIPTION:
# A stand-alone implementation of the ver_replacing function aimed
# for EAPI 9.  Intended to be used for wider testing of the proposed
# function and to allow ebuilds to switch to the new model early, with
# minimal change needed for the actual EAPI 9.
#
# @CODE
# if ver_replacing -lt 1.2; then
#     elog "The frobnicate command was dropped in version 1.2"
# fi
# @CODE

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: ver_replacing
# @USAGE: <op> <ver>
# @RETURN: 0 if any element of REPLACING_VERSIONS qualifies, 1 otherwise
# @DESCRIPTION:
# Compare each element <v> of REPLACING_VERSIONS with version <ver>
# using ver_test().  Return 0 (true) if any element <v> fulfills
# "ver_test <v> <op> <ver>", 1 (false) otherwise.
#
# Note: If REPLACING_VERSIONS is empty, 1 (false) is returned.
ver_replacing() {
	case ${EBUILD_PHASE} in
		pretend|setup|preinst|postinst) ;;
		*) die "ver_replacing is meaningless in the ${EBUILD_PHASE} phase" ;;
	esac

	[[ $# -eq 2 ]] || die "Usage: ver_replacing <op> <ver>"

	local v
	for v in ${REPLACING_VERSIONS}; do
		ver_test "${v}" "$@" && return 0
	done
	return 1
}
