# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/vhdl-mode/vhdl-mode-3.38.1.ebuild,v 1.1 2015/04/02 02:42:17 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="VHDL-mode for Emacs"
HOMEPAGE="http://www.iis.ee.ethz.ch/~zimmi/emacs/vhdl-mode.html"
SRC_URI="http://www.iis.ee.ethz.ch/~zimmi/emacs/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

ELISP_PATCHES="${PN}-info-dir-gentoo.patch"
ELISP_REMOVE="site-start.*"
SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog README"

src_install() {
	elisp_src_install
	doinfo vhdl-mode.info
}
