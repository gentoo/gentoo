# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Rework of Sasteroids using SDL"
HOMEPAGE="http://sdlsas.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlsas/SDLSasteroids-${PV}.tar.gz"

LICENSE="sdlsasteroids GPL-2+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/sdl-mixer
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SDLSasteroids-${PV}"

src_prepare() {
	default
	eapply \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e 's/make /$(MAKE) /' \
		-e 's/--strip//' \
		Makefile || die
	sed -i \
		-e '/^CC/d' \
		-e 's/g++/$(CXX)/' \
		-e 's/CC/CXX/' \
		-e 's/CFLAGS/CXXFLAGS/' \
		src/Makefile || die
}

src_compile() {
	emake \
		GAMEDIR="/usr/share/${PN}" \
		OPTS="${CXXFLAGS}"
}

src_install() {
	dodir /usr/share/man/man6/
	emake \
		GAMEDIR="${D}/usr/share/${PN}" \
		BINDIR="${D}/usr/bin" \
		MANDIR="${D}/usr/share/man/" \
		install
	dodoc ChangeLog README README.xast TODO description
	newicon graphics/sprite/bigast.png ${PN}.png
	make_desktop_entry sasteroids "Sasteroids" ${PN}
}
