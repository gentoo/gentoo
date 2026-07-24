# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bash-completion-r1.eclass
# @MAINTAINER:
# mgorny@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: shell-completion
# @BLURB: A few quick functions to install bash-completion files
# @DESCRIPTION:
# This eclass provides functions to install bash-completion files.
# For EAPI 9 or newer, use shell-completion.eclass instead.
# @EXAMPLE:
#
# @CODE
# EAPI=8
#
# src_configure() {
# 	econf \
#		--with-bash-completion-dir="$(get_bashcompdir)"
# }
#
# src_install() {
# 	default
#
# 	newbashcomp contrib/${PN}.bash-completion ${PN}
# }
# @CODE

if [[ -z ${_BASH_COMPLETION_R1_ECLASS} ]]; then
_BASH_COMPLETION_R1_ECLASS=1

inherit shell-completion

fi
