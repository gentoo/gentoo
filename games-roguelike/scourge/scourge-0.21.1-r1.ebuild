# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DESCRIPTION="A graphical rogue-like adventure game"
HOMEPAGE="https://sourceforge.net/projects/scourge/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.src.tar.gz
	mirror://sourceforge/${PN}/${P}.data.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/freetype:2
	media-libs/libsdl[joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	virtual/libintl
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-gcc6.patch
	"${FILESDIR}"/${P}-automake-1.13.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch
	"${FILESDIR}"/${P}-Wc++11-narrowing.patch
	"${FILESDIR}"/${PN}-0.21.1-respect-AR.patch
	"${FILESDIR}"/${P}-gcc-11.patch
)

src_prepare() {
	default

	# bug #257601
	sed -i \
		-e '/AC_CHECK_HEADERS.*glext/ s:):, [#include <GL/gl.h>] ):' \
		configure.in || die
	sed -i \
		-e '/snprintf/s/tmp, 256/tmp, sizeof(tmp)/' \
		src/scourgehandler.cpp || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-rpath \
		--with-data-dir="${EPREFIX}"/usr/share/${PN}
}

src_install() {
	default

	insinto /usr/share/scourge
	doins -r ../scourge_data/.

	doicon assets/scourge.png
	make_desktop_entry scourge S.C.O.U.R.G.E.
}
