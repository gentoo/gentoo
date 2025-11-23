# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic

MY_P="${PN}_${PV}.orig"
DESCRIPTION="Multi or single-player network Pacman-like game in SDL"
HOMEPAGE="https://archive.org/details/njam1.25-src"
SRC_URI="https://archive.org/download/njam1.25-src/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}-src"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libsdl
	media-libs/sdl-net"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -i \
		-e "s:hiscore.dat:/var/${PN}/\0:" \
		src/njam.cpp \
		|| die "sed failed"
	sed -i \
		-e "/hiscore.dat/ s:\$(DEFAULT_LIBDIR):/var:" \
		Makefile.in \
		|| die "sed failed"

	eapply "${FILESDIR}"/${P}-gcc45.patch
	eapply "${FILESDIR}"/${P}-format-security.patch #542124

	# njam segfaults on startup with -Os
	replace-flags "-Os" "-O2"
	eautoreconf
}

src_install() {
	default

	HTML_DOCS="${ED}/usr/share/njam/html/*"
	rm -rf "${ED}/usr/share/njam/html/" || die
	rm -f "${ED}"/README "${ED}"/levels/readme.txt || die

	newicon data/njamicon.bmp njam.bmp
	make_desktop_entry njam Njam /usr/share/pixmaps/njam.bmp
}
