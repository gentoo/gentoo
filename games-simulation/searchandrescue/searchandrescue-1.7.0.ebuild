# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop flag-o-matic prefix toolchain-funcs xdg

MY_PN=SearchAndRescue
DESCRIPTION="Helicopter based air rescue flight simulator"
HOMEPAGE="http://searchandrescue.sourceforge.net/"
SRC_URI="mirror://sourceforge/searchandrescue/${MY_PN}-${PV}.tar.gz -> ${MY_PN}-${PV}.tar
	mirror://sourceforge/searchandrescue/${MY_PN}-data-${PV}.tar.gz -> ${MY_PN}-data-${PV}.tar
	mirror://sourceforge/searchandrescue/${MY_PN}-data-guadarrama-${PV}.tar.gz -> ${MY_PN}-data-guadarrama-${PV}.tar"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-mixer
	virtual/glu
	virtual/opengl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXxf86vm
"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${MY_PN}-${PV}.tar
	mkdir data || die
	cd data || die
	unpack ${MY_PN}-data-${PV}.tar
	unpack ${MY_PN}-data-guadarrama-${PV}.tar
	bunzip2 "${S}"/sar/man/${MY_PN}.6.bz2 || die
}

src_prepare() {
	xdg_src_prepare

	chmod +x configure || die
	rm pconf/pconf || die
	sed -i "/PlatformSearchPathLib/s:/lib/:/$(get_libdir)/:g" sar/platforms.ini || die
	hprefixify sar/platforms.ini
}

src_configure() {
	export CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" \
		   CPP="$(tc-getCXX) ${LDFLAGS}"

	append-flags -DNEW_GRAPHICS -DHAVE_SDL_MIXER

	# Needed for the configure script
	emake -C pconf pconf CC="${CC}"

	# NOTE: not an autoconf script
	./configure Linux --prefix="${EPREFIX}/usr" || die
	sed -i -r 's/^(\s+)@/\1/' sar/Makefile || die
}

src_compile() {
	emake -C sar LIB_DIRS=
}

src_install() {
	dobin sar/${MY_PN}
	doman sar/man/${MY_PN}.6
	dodoc AUTHORS HACKING README
	doicon sar/icons/${MY_PN}.xpm
	insinto /usr/share/games/${PN}
	doins -r ../data/*
	make_desktop_entry ${MY_PN} "Search and Rescue" ${MY_PN}
}
