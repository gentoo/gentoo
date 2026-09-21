# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: edo.eclass
# @MAINTAINER:
# QA Team <qa@gentoo.org>
# @AUTHOR:
# Sam James <sam@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: edob
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
#
# Note that starting with EAPI 9, the edo command is provided by the
# package manager.  If you need the edob command in EAPI 9 ebuilds or
# eclasses, then inherit edob.eclass directly.
case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_EDO_ECLASS} ]] ; then
_EDO_ECLASS=1

inherit edob

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

fi
