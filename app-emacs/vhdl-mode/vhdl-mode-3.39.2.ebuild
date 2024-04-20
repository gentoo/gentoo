# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="VHDL-mode for Emacs"
HOMEPAGE="https://iis-people.ee.ethz.ch/~zimmi/emacs/vhdl-mode.html"
SRC_URI="https://iis-people.ee.ethz.ch/~zimmi/emacs/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=( "${FILESDIR}"/${PN}-info-dir-gentoo.patch )
ELISP_REMOVE="site-start.*"
SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog README"

src_install() {
	elisp_src_install
	doinfo vhdl-mode.info
}
