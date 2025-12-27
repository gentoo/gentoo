# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A major mode for editing Cascading Style Sheets (CSS)"
HOMEPAGE="https://www.garshol.priv.no/download/software/css-mode/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

PATCHES=( "${FILESDIR}/${P}-no-compat-kbd.patch" )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	# Fix documentation
	sed -i -e 's,HREF="/visuals/standard.css",HREF="standard.css",' doco.html
}

src_install() {
	elisp_src_install
	docinto html
	dodoc doco.html standard.css
}
