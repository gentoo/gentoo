# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="Rework of Sasteroids using SDL"
HOMEPAGE="http://sdlsas.sourceforge.net/"
SRC_URI="mirror://sourceforge/sdlsas/SDLSasteroids-${PV}.tar.gz"
S="${WORKDIR}/SDLSasteroids-${PV}"

LICENSE="sdlsasteroids GPL-2+ public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/sdl-mixer
	media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

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
