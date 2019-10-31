# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools toolchain-funcs

MY_P="${PN}-${PV/_p/-cbiere-r}"
DESCRIPTION="Sega Genesis / Mega Drive emulator"
HOMEPAGE="http://www.squish.net/generator/"
SRC_URI="http://www.squish.net/generator/cbiere/generator/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+sdlaudio"

DEPEND="
	virtual/jpeg:0
	media-libs/libsdl[joystick,video]
	sdlaudio? ( media-libs/libsdl[sound] )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-configure.patch
	"${FILESDIR}"/${P}-underlink.patch
	"${FILESDIR}"/${P}-inline.patch
	"${FILESDIR}"/${P}-gcc-9.patch
)

src_prepare() {
	default

	sed -i -e 's/@GTK_CFLAGS@//g' main/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--with-cmz80 \
		--with-sdl \
		--without-tcltk \
		--with-gcc=$(gcc-major-version) \
		$(use_with sdlaudio sdl-audio)
}

src_install() {
	dobin main/generator-sdl
	dodoc AUTHORS ChangeLog NEWS README TODO docs/*
}
