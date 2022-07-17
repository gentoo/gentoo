# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${P/_}
inherit desktop flag-o-matic

DESCRIPTION="Board games system"
HOMEPAGE="http://gtkboard.sourceforge.net/indexold.html"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	virtual/pkgconfig"
RDEPEND="
	media-libs/libsdl:0[sound]
	media-libs/sdl-mixer[vorbis]
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

HTML_DOCS=( doc/index.html )

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc41.patch
	"${FILESDIR}"/${P}-gcc45.patch
	"${FILESDIR}"/${P}-stack-smash.patch
	"${FILESDIR}"/${P}-gcc10.patch
)

src_prepare() {
	default

	sed -i -e "/^LIBS/s:@LIBS@:@LIBS@ -lgmodule-2.0 -lm:" src/Makefile.in || die
}

src_configure() {
	# bug #858614
	filter-lto

	econf \
		--enable-gtk2 \
		--enable-sdl \
		--disable-gnome
}

src_install() {
	default
	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN} Gtkboard
}
