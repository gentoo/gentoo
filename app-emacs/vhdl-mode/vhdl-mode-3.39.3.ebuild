# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="VHDL-mode for Emacs"
HOMEPAGE="https://iis-people.ee.ethz.ch/~zimmi/emacs/vhdl-mode.html"
SRC_URI="https://iis-people.ee.ethz.ch/~zimmi/emacs/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

ELISP_REMOVE="site-start.*"
PATCHES=( "${FILESDIR}/${PN}-info-dir-gentoo.patch" )

DOCS="ChangeLog README"
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	doinfo vhdl-mode.info
}
