# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="a nice graphical accompaniment to music"
HOMEPAGE="http://www.logarithmic.net/pfh/synaesthesia"
SRC_URI="http://www.logarithmic.net/pfh-files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="sdl svga"

RDEPEND="x11-libs/libXext
	x11-libs/libSM
	sdl? ( >=media-libs/libsdl-1.2 )
	svga? ( >=media-libs/svgalib-1.4.3 )"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_prepare() {
	sed -e '/CFLAGS=/s:-O4:${CFLAGS}:' \
		-e '/CXXFLAGS=/s:-O4:${CXXFLAGS}:' -i configure || die "sed failed"
	sed -e 's:void inline:inline void:' -i syna.h || die "sed failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
