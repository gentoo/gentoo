# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

MY_P=${P/_}
DESCRIPTION="Board games system"
HOMEPAGE="http://gtkboard.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnome"

RDEPEND="x11-libs/gtk+:2
	media-libs/libsdl:0[sound]
	media-libs/sdl-mixer[vorbis]
	gnome? ( gnome-base/libgnomeui )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-gcc45.patch
)

src_prepare() {
	default

	sed -i -e "/^LIBS/s:@LIBS@:@LIBS@ -lgmodule-2.0 -lm:" \
		src/Makefile.in
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-gtk2 \
		--enable-sdl \
		$(use_enable gnome)
}

src_install() {
	emake DESTDIR="${D}" install
	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN} Gtkboard
	dodoc AUTHORS ChangeLog TODO doc/index.html
}
