# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Implementation of Sokoban for Emacs"
HOMEPAGE="https://elpa.gnu.org/packages/sokoban.html"
SRC_URI="https://elpa.gnu.org/packages/${P}.tar"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

ELISP_REMOVE="sokoban-pkg.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog"

src_install() {
	elisp_src_install
	insinto "${SITEETC}/${PN}"
	doins sokoban.levels
}
