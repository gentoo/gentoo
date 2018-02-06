# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

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
	mv "${S}"/configure.in "${S}"/configure.ac
	epatch "${FILESDIR}"/${P}-gcc43.patch \
	    "${FILESDIR}"/${P}-ldflags.patch
	if has_version ">=media-gfx/imagemagick-7.0.5.7" ;then
	    epatch "${FILESDIR}"/${P}-imagemagick-7.patch
	fi
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README THANKS
	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins samples/*.txt
	fi
}
