# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Generic game engine for 2D double-buffering animation"
HOMEPAGE="http://perso.b2b2c.ca/~sarrazip/dev/batrachians.html"
SRC_URI="http://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i \
		-e '/^doc_DATA =/s/^/NOTHANKS/' \
		Makefile.in || die
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	if ! use static-libs; then
		find "${ED}" -type f -name '*.la' -delete || die
	fi
}
