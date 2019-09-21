# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Opensource software organ"
HOMEPAGE="http://horgand.berlios.de"
#SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

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
	default
	eapply "${FILESDIR}"/${P}-overflow.patch
}

src_compile() {
	emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS} $(fltk-config --cxxflags) \
		$(pkg-config --cflags jack) $(pkg-config --cflags sndfile)"
}

src_install() {
	default
	doman man/${PN}.1
	newicon src/${PN}128.xpm ${PN}.xpm
	make_desktop_entry ${PN} Horgand ${PN}
}
