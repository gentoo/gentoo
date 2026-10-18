# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: edob.eclass
# @MAINTAINER:
# QA Team <qa@gentoo.org>
# @AUTHOR:
# Sam James <sam@gentoo.org>
# Florian Schmaus <flow@gentoo.org>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: Wrap output-producing commands in ebegin/eend
# @DESCRIPTION:
# This eclass provides the edob command for ebegin/eend,
# which logs the command used verbosely and dies (exits) on failure.
#
# The edob command can be used for long running commands, even if
# those commands produce output.  The edob command will suppress the
# command's output and only present it if the command returned with a
# non-zero exit status.
case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_EDOB_ECLASS} ]] ; then
_EDOB_ECLASS=1

# @FUNCTION: edob
# @USAGE: [-l <log-name>] [-m <message>] <command> [<args>...]
# @DESCRIPTION:
# Executes 'command' with any given arguments wrapped in ebegin and
# eend.  Aborts on failure unless called under 'nonfatal'.
# Furthermore, redirects stdout and stderr to a log file.  The content
# of the log file is shown if the command returns with a non-zero exit
# status.
#
# If -m <message> is provided, then invokes ebegin with <message>, otherwise
# a default message is used.  If -l <log-name> is provided, then <log-name> is
# used to construct the name of the log file to which stdout and stderr of the
# command is redirected to.
edob() {
	local message
	local log_name

	while true; do
		case "${1}" in
			-l|-m)
				[[ $# -lt 2 ]] && die "Must provide an argument to ${1}"
				case "${1}" in
					-l)
						log_name="${2}"
						;;
					-m)
						message="${2}"
						;;
				esac
				shift 2
				;;
			*)
				break
				;;
		esac
	done

	[[ -z ${message} ]] && message="Running $@"
	[[ -z ${log_name} ]] && log_name="$(basename ${1})"

	local log_file="${T}/${log_name}.log"

	ebegin "${message}"

	"$@" &> "${log_file}"
	local ret=$?

	if ! eend $ret; then
		cat "${log_file}"
		die -n "Command \"$@\" failed with exit status $ret"
	fi
}

fi
