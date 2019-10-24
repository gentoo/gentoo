# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils desktop flag-o-matic toolchain-funcs

MY_PN=SearchAndRescue
DESCRIPTION="Helicopter based air rescue flight simulator"
HOMEPAGE="http://searchandrescue.sourceforge.net/"
SRC_URI="mirror://sourceforge/searchandrescue/${MY_PN}-${PV}.tar.gz -> ${MY_PN}-${PV}.tar
	mirror://sourceforge/searchandrescue/${MY_PN}-data-${PV}.tar.gz -> ${MY_PN}-data-${PV}.tar
	mirror://sourceforge/searchandrescue/${MY_PN}-data-guadarrama-${PV}.tar.gz -> ${MY_PN}-data-guadarrama-${PV}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-mixer
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXxf86vm
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${MY_PN}-${PV}.tar
	mkdir data && cd data && \
		unpack ${MY_PN}-data-${PV}.tar && \
		unpack ${MY_PN}-data-guadarrama-${PV}.tar
	bunzip2 "${S}"/sar/man/${MY_PN}.6.bz2 || die
}

src_prepare() {
	default

	chmod +x configure
	rm pconf/pconf || die
	sed -i -e '/Wall/s/$/ $(CFLAGS)/' pconf/Makefile || die
	sed -i '/PlatformSearchPathLib = \/usr\/lib\//a \\tPlatformSearchPathLib = \/usr\/lib64\/' sar/platforms.ini || die
}

src_configure() {
	emake CC=$(tc-getCC) -C pconf pconf # Needed for the configure script

	append-cppflags -DNEW_GRAPHICS -DHAVE_SDL_MIXER
	export CPP="$(tc-getCXX)"
	export CPPFLAGS="${CXXFLAGS}"
	# NOTE: not an autoconf script
	./configure Linux --prefix="/usr" || die
	sed -i -e 's/@\$/$/' sar/Makefile || die
}

src_compile() {
	emake -C sar
}

src_install() {
	dobin sar/${MY_PN}
	doman sar/man/${MY_PN}.6
	dodoc AUTHORS HACKING README
	doicon sar/icons/SearchAndRescue.xpm
	newicon sar/icons/SearchAndRescue.xpm ${MY_PN}.xpm
	dodir /usr/share/games/${PN}
	cp -r "${WORKDIR}"/data/* "${D}/usr/share/games/${PN}/" || die
	make_desktop_entry SearchAndRescue "SearchAndRescue" /usr/share/pixmaps/${MY_PN}.xpm
}
