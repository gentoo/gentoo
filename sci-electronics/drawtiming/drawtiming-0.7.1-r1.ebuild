# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Command line tool for drawing timing diagrams"
HOMEPAGE="http://drawtiming.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND="media-gfx/imagemagick[cxx]"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
	    "${FILESDIR}"/${P}-ldflags.patch
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README THANKS
	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins samples/*.txt
	fi
}
