# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A generic game engine for 2D double-buffering animation"
HOMEPAGE="https://perso.b2b2c.ca/~sarrazip/dev/batrachians.html"
SRC_URI="https://perso.b2b2c.ca/~sarrazip/dev/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e '/^doc_DATA =/s/^/NOTHANKS/' \
		Makefile.in || die
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
