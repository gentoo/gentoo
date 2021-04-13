# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic xdg toolchain-funcs

DESCRIPTION="A puzzle game where the player has to arrange balls in triplets"
HOMEPAGE="https://sourceforge.net/projects/zaz/"
SRC_URI="mirror://sourceforge/zaz/${P}.tar.bz2"

LICENSE="GPL-3 GPL-3+ CC-BY-SA-3.0 OFL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	virtual/opengl
	virtual/glu
	media-libs/libsdl[X,sound,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/libvorbis
	media-libs/libtheora
	media-libs/ftgl
	virtual/libintl
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	local x=/usr/share/gettext/po/Makefile.in.in
	[[ -e $x ]] && cp -f $x po/ #336119

	eapply "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	append-libs -lvorbis
	append-cflags $($(tc-getPKG_CONFIG) sdl --cflags)
	append-cxxflags $($(tc-getPKG_CONFIG) sdl --cflags)
	econf \
		--with-applicationdir=/usr/share/applications \
		--with-icondir=/usr/share/pixmaps \
		--localedir=/usr/share/locale \
		$(use_enable nls)
}
