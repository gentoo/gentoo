# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit vim-plugin

DESCRIPTION="vim plugin: syntax checking using external tools"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=2736 https://github.com/scrooloose/syntastic/"
SRC_URI="https://github.com/scrooloose/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="WTFPL-2"
KEYWORDS="amd64 x86"

VIM_PLUGIN_HELPFILES="${PN}"

src_prepare() {
	rm -r _assets LICENCE README.markdown || die
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Syntastic has many optional dependencies depending on the type"
		elog "of syntax checking being performed. Look in the related files in"
		elog "the syntax_checkers directory to help figure out what programs"
		elog "different languages need."
	fi
}
