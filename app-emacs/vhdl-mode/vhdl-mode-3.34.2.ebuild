# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/vhdl-mode/vhdl-mode-3.34.2.ebuild,v 1.1 2014/02/27 18:11:39 ulm Exp $

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
