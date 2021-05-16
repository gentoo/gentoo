# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Major mode for Povray scene files"
HOMEPAGE="https://github.com/melmothx/pov-mode"
SRC_URI="https://github.com/emacsmirror/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="sys-apps/texinfo"

SITEFILE="50${PN}-gentoo.el"
ELISP_REMOVE="${PN}-pkg.el ${PN}.info"
ELISP_TEXINFO="info/${PN}.texi"
DOCS="README"

src_install() {
	elisp_src_install
	insinto ${SITEETC}/${PN}
	doins *.xpm
	doins -r InsertMenu/
}
