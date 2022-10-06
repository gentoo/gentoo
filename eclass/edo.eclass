# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: edo.eclass
# @MAINTAINER:
# QA Team <qa@gentoo.org>
# @AUTHOR:
# Sam James <sam@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Convenience function to run commands verbosely and die on failure
# @DESCRIPTION:
# This eclass provides the ``edo`` command, and an ``edob`` variant for ``ebegin/eend``,
# which logs the command used verbosely and dies (exits) on failure.
#
# This eclass should be used only where needed to give a more verbose log, e.g.
# for invoking non-standard ``./configure`` scripts, or building objects/binaries
# directly within ebuilds via compiler invocations. It is NOT to be used
# in place of generic ``command || die`` where verbosity is unnecessary.
case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_EDO_ECLASS} ]] ; then
_EDO_ECLASS=1

# @FUNCTION: edo
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Executes a short ``command`` with any given arguments and exits on failure
# unless called under ``nonfatal``.
edo() {
	einfo "$@"
	"$@" || die -n "Failed to run command: $@"
}

# @FUNCTION: edob
# @USAGE: <command> [<args>...]
# @DESCRIPTION:
# Executes ``command`` with ``ebegin`` & ``eend`` with any given arguments and
# exits on failure unless called under ``nonfatal``.
edob() {
	ebegin "Running $@"
	"$@"
	eend $? || die -n "Failed to run command: $@"
}

fi
