# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools desktop

DESCRIPTION="Addictive OpenGL-based block game"
HOMEPAGE="http://www.nongnu.org/crack-attack/"
SRC_URI="https://savannah.nongnu.org/download/crack-attack/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE="gtk sdl"

RDEPEND="
	media-libs/freeglut
	sdl? (
		media-libs/libsdl
		media-libs/sdl-mixer
	)
	gtk? ( >=x11-libs/gtk+-2.6:2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-glut.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-avoid_bashisms.patch
)

src_prepare() {
	default
	eautoreconf
	sed -i 's/-lXmu//' src/gtk-gui/Makefile.in src/Makefile.in || die
	touch -r . * */*
}

src_configure() {
	local myeconfargs=(
		--disable-binreloc
		$(use_enable sdl sound)
		$(use_enable gtk)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	HTML_DOCS="doc/*"
	default
	doicon data/crack-attack.xpm
	make_desktop_entry crack-attack Crack-attack
}
