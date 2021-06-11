# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="Breakout with 3D representation based on OpenGL"
HOMEPAGE="http://briquolo.free.fr/en/index.html"
SRC_URI="http://briquolo.free.fr/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	virtual/opengl
	virtual/glu
	media-libs/libsdl[joystick,sound,video]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/libpng:0
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-libpng14.patch
	"${FILESDIR}"/${P}-respect-AR.patch
)

src_prepare() {
	default

	# No thanks, we'll take care of it.
	sed -i \
		-e '/^SUBDIRS/s/desktop//' \
		Makefile.{in,am} || die
	sed -i \
		-e "/CXXFLAGS/s:-O3:${CXXFLAGS}:" \
		-e 's:=.*share/locale:=/usr/share/locale:' \
		configure{,.ac} || die
	sed -i \
		-e 's:$(datadir)/locale:/usr/share/locale:' \
		po/Makefile.in.in || die

	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default
	doicon desktop/briquolo.svg
	make_desktop_entry briquolo Briquolo
}
