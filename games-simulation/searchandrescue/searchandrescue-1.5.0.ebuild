# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/searchandrescue/searchandrescue-1.5.0.ebuild,v 1.5 2014/02/08 16:25:56 mr_bones_ Exp $

EAPI=5
inherit eutils flag-o-matic toolchain-funcs games

MY_DATA_PV=1.3.0
MY_PN=SearchAndRescue
DESCRIPTION="Helicopter based air rescue flight simulator"
HOMEPAGE="http://searchandrescue.sourceforge.net/"
SRC_URI="mirror://sourceforge/searchandrescue/${MY_PN}-${PV}.tar.gz
	mirror://sourceforge/searchandrescue/${MY_PN}-data-${MY_DATA_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libXxf86vm
	x11-libs/libSM
	x11-libs/libICE
	x11-libs/libXmu
	x11-libs/libXi
	x11-libs/libXpm
	virtual/opengl
	virtual/glu
	media-libs/libsdl
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto"

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${MY_PN}-${PV}.tar.gz
	mkdir data && cd data && \
		unpack ${MY_PN}-data-${MY_DATA_PV}.tar.gz
	bunzip2 "${S}"/sar/man/${MY_PN}.6.bz2 || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	rm pconf/pconf || die
	sed -i -e '/Wall/s/$/ $(CFLAGS)/' pconf/Makefile || die
}

src_configure() {
	emake CC=$(tc-getCC) -C pconf pconf # Needed for the configure script

	append-flags -DNEW_GRAPHICS -DHAVE_SDL_MIXER
	export CPP="$(tc-getCXX)"
	export CPPFLAGS="${CXXFLAGS}"
	# NOTE: not an autoconf script
	./configure Linux --prefix="${GAMES_PREFIX}" || die
	sed -i -e 's/@\$/$/' sar/Makefile || die
}

src_compile() {
	emake -C sar
}
src_install() {
	dogamesbin sar/${MY_PN}
	doman sar/man/${MY_PN}.6
	dodoc AUTHORS HACKING README
	doicon sar/icons/SearchAndRescue.xpm
	newicon sar/icons/SearchAndRescue.xpm ${PN}.xpm
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r "${WORKDIR}"/data/* "${D}/${GAMES_DATADIR}/${PN}/" || die
	make_desktop_entry SearchAndRescue "SearchAndRescue" /usr/share/pixmaps/${PN}.xpm
	prepgamesdirs
}
