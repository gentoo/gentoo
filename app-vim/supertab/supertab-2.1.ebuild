# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/supertab/supertab-2.1.ebuild,v 1.3 2015/02/09 00:32:52 radhermit Exp $

EAPI="5"

inherit vim-plugin

DESCRIPTION="vim plugin: enhanced Tab key functionality"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1643 https://github.com/ervandew/supertab/"
SRC_URI="https://github.com/ervandew/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
KEYWORDS="amd64 ~mips ppc x86"

VIM_PLUGIN_HELPFILES="${PN}.txt"

src_prepare() {
	rm Makefile .gitignore || die
}
