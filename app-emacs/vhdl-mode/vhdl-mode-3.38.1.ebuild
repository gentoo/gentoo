# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="VHDL-mode for Emacs"
HOMEPAGE="https://iis.ee.ethz.ch/~zimmi/emacs/vhdl-mode.html"
SRC_URI="https://iis.ee.ethz.ch/~zimmi/emacs/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

ELISP_PATCHES="${PN}-info-dir-gentoo.patch"
ELISP_REMOVE="site-start.*"
SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog README"

src_install() {
	elisp_src_install
	doinfo vhdl-mode.info
}
