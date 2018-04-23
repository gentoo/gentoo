# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop flag-o-matic

MY_P="${P}-src"
DESCRIPTION="Multi or single-player network Pacman-like game in SDL"
HOMEPAGE="http://njam.sourceforge.net/"
SRC_URI="mirror://sourceforge/njam/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/libsdl
	media-libs/sdl-net"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

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
}

src_install() {
	default

	HTML_DOCS="${ED}/usr/share/njam/html/*"
	rm -rf "${ED}/usr/share/njam/html/"
	rm -f "${ED}"/README "${ED}"/levels/readme.txt

	newicon data/njamicon.bmp njam.bmp
	make_desktop_entry njam Njam /usr/share/pixmaps/njam.bmp
}
