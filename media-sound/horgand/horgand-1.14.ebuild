# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/horgand/horgand-1.14.ebuild,v 1.8 2012/05/05 08:31:00 mgorny Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="Opensource software organ"
HOMEPAGE="http://horgand.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/fltk:1
	x11-libs/libXpm
	media-libs/libsndfile
	media-libs/alsa-lib
	media-sound/alsa-utils
	media-sound/jack-audio-connection-kit"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-overflow.patch
}

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} $(fltk-config --cxxflags) \
		$(pkg-config --cflags jack) $(pkg-config --cflags sndfile)" || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README
	doman man/${PN}.1
	newicon src/${PN}128.xpm ${PN}.xpm
	make_desktop_entry ${PN} Horgand ${PN}
}
