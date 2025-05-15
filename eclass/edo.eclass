# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: edo.eclass
# @MAINTAINER:
# QA Team <qa@gentoo.org>
# @AUTHOR:
# Sam James <sam@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Convenience function to run commands verbosely and die on failure
# @DESCRIPTION:
# This eclass provides the 'edo' command, and an 'edob' variant for ebegin/eend,
# which logs the command used verbosely and dies (exits) on failure.
#
# The 'edo' command should be used only where needed to give a more verbose log,
# e.g. for invoking non-standard ./configure scripts, or building
# objects/binaries directly within ebuilds via compiler invocations.  It is NOT
# to be used in place of generic 'command || die' where verbosity is
# unnecessary.
#
# The 'edob' command can be used for long running commands, even if
# those commands produce output.  The 'edob' command will suppress the
# command's output and only present it if the command returned with a
# non-zero exit status.
case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_EDO_ECLASS} ]] ; then
_EDO_ECLASS=1

# @FUNCTION: edo
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Executes a short 'command' with any given arguments and exits on failure
# unless called under 'nonfatal'.
edo() {
	# list of special characters taken from sh_contains_shell_metas
	# in shquote.c (bash-5.2)
	local a out regex='[] '\''"\|&;()<>!{}*[?^$`]|^[#~]|[=:]~'

	[[ $# -ge 1 ]] || die "edo: at least one argument needed"

	if [[ ${EAPI} = 7 ]]; then
		# no @Q in bash-4.2
		out=" $*"
	else
		for a; do
			# quote if (and only if) necessary
			[[ ${a} =~ ${regex} || ! ${a} =~ ^[[:print:]]+$ ]] && a=${a@Q}
			out+=" ${a}"
		done
	fi

	einfon
	printf '%s\n' "${out:1}" >&2
	"$@" || die -n "Failed to run command: ${1}"
}

# @FUNCTION: edob
# @USAGE: [-l <log-name>] [-m <message>] <command> [<args>...]
# @DESCRIPTION:
# Executes 'command' with ebegin & eend with any given arguments and exits
# on failure unless called under 'nonfatal'.  This function redirects
# stdout and stderr to a log file.  The content of the log file is shown
# if the command returns with a non-zero exit status.
#
# If -m <message> is provided, then invokes ebegin with <message>, otherwise
# a default message is used.  If -l <log-name> is provided, then <log-name> is
# used to construct the name of the log file where stdout and stderr of the
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
