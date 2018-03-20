# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: vcs-clean.eclass
# @MAINTAINER:
# base-system@gentoo.org
# @AUTHOR:
# Benedikt Böhm <hollow@gentoo.org>
# @BLURB: helper functions to remove VCS directories

# @FUNCTION: ecvs_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove CVS directories and .cvs* files recursively.  Useful when a
# source tarball contains internal CVS directories.  Defaults to ${PWD}.
ecvs_clean() {
	[[ $# -eq 0 ]] && set -- .
	find "$@" '(' -type d -name 'CVS' -prune -o -type f -name '.cvs*' ')' \
		-exec rm -rf '{}' +
}

# @FUNCTION: esvn_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove .svn directories recursively.  Useful when a source tarball
# contains internal Subversion directories.  Defaults to ${PWD}.
esvn_clean() {
	[[ $# -eq 0 ]] && set -- .
	find "$@" -type d -name '.svn' -prune -exec rm -rf '{}' +
}

# @FUNCTION: egit_clean
# @USAGE: [list of dirs]
# @DESCRIPTION:
# Remove .git* directories recursively.  Useful when a source tarball
# contains internal Git directories.  Defaults to ${PWD}.
egit_clean() {
	[[ $# -eq 0 ]] && set -- .
	find "$@" -type d -name '.git*' -prune -exec rm -rf '{}' +
}
