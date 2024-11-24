# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: eapi9-pipestatus.eclass
# @MAINTAINER:
# Ulrich Müller <ulm@gentoo.org>
# @AUTHOR:
# Ulrich Müller <ulm@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: check the PIPESTATUS array
# @DESCRIPTION:
# A stand-alone implementation of a possible future pipestatus command
# (which would be aimed for EAPI 9).  It is meant as a replacement for
# "assert".  In its simplest form it can be called like this:
#
# @CODE
# foo | bar
# pipestatus || die
# @CODE
#
# With the -v option, the command will also echo the pipe status array,
# so it can be assigned to a variable like in the following example:
#
# @CODE
# local status
# foo | bar
# status=$(pipestatus -v) || die "foo | bar failed, status ${status}"
# @CODE
#
# Caveat: "pipestatus" must be the next command following the pipeline.
# In particular, the "local" declaration must be before the pipeline,
# otherwise it would reset the status.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: pipestatus
# @USAGE: [-v]
# @RETURN: last non-zero element of PIPESTATUS, or zero if all are zero
# @DESCRIPTION:
# Check the PIPESTATUS array, i.e. the exit status of the command(s)
# in the most recently executed foreground pipeline.  If called with
# option -v, also output the PIPESTATUS array.
pipestatus() {
	local status=( "${PIPESTATUS[@]}" )
	local s ret=0 verbose=""

	[[ ${1} == -v ]] && { verbose=1; shift; }
	[[ $# -ne 0 ]] && die "usage: ${FUNCNAME} [-v]"

	for s in "${status[@]}"; do
		[[ ${s} -ne 0 ]] && ret=${s}
	done

	[[ ${verbose} ]] && echo "${status[@]}"

	return "${ret}"
}
