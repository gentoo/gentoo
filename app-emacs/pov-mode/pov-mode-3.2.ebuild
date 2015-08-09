# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="Emacs mode for povray"
HOMEPAGE="https://gitorious.org/pov-mode/pov-mode/trees/master"
#SRC_URI="http://tromey.com/elpa/${P}.tar"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
ELISP_TEXINFO="info/${PN}.texi"
DOCS="README"

src_prepare() {
	rm -f *.info || die			# ensure we build them from source
}

src_install() {
	elisp_src_install
	insinto ${SITEETC}/${PN}
	doins *.xpm
	doins -r InsertMenu/
}
