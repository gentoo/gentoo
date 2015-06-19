# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xtitle/xtitle-1.0.2.ebuild,v 1.3 2012/12/06 04:28:16 phajdan.jr Exp $

EAPI=4

DESCRIPTION="Set window title and icon name for an X11 terminal window"
HOMEPAGE="http://www.cs.indiana.edu/~kinzler/xtitle/"
SRC_URI="http://www.cs.indiana.edu/~kinzler/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="x11-misc/imake"
RDEPEND=""

DOCS=( README )

src_compile() {
	xmkmf || die
	emake
}

src_install() {
	default
	newman "${PN}.man" "${PN}.1"
	dohtml "${PN}.html"
}
