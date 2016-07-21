# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="Zenburn color theme for Emacs"
HOMEPAGE="http://slinky.imukuppi.org/zenburnpage/
	https://github.com/dbrock/zenburn-el"
# snapshot from upstream git repo
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-emacs/color-theme"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

pkg_postinst() {
	elisp-site-regen
	elog "To enable zenburn by default, initialise it in your ~/.emacs:"
	elog "   (color-theme-zenburn)"
}
