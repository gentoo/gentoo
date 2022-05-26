# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vcs-clean.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Benedikt Böhm <hollow@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: helper functions to remove VCS directories

case ${EAPI} in
	5|6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_VCS_CLEAN_ECLASS} ]] ; then
_VCS_CLEAN_ECLASS=1

# @FUNCTION: ecvs_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove CVS directories and .cvs* files recursively.  Useful when a
# source tarball contains internal CVS directories.  Defaults to ${PWD}.
ecvs_clean() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ $# -eq 0 ]] && set -- .
	find "$@" '(' -type d -name 'CVS' -prune -o -type f -name '.cvs*' ')' \
		-exec rm -rf '{}' + || die
}

# @FUNCTION: esvn_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove .svn directories recursively.  Useful when a source tarball
# contains internal Subversion directories.  Defaults to ${PWD}.
esvn_clean() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ $# -eq 0 ]] && set -- .
	find "$@" -type d -name '.svn' -prune -exec rm -rf '{}' + || die
}

# @FUNCTION: egit_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove .git* directories recursively.  Useful when a source tarball
# contains internal Git directories.  Defaults to ${PWD}.
egit_clean() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ $# -eq 0 ]] && set -- .
	find "$@" -type d -name '.git*' -prune -exec rm -rf '{}' + || die
}

fi
