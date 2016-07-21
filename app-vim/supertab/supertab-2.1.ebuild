# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
