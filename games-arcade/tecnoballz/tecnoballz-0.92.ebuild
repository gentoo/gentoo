# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils autotools games

DESCRIPTION="An exciting Brick Breaker"
HOMEPAGE="http://linux.tlk.fr/games/TecnoballZ/"
SRC_URI="http://linux.tlk.fr/games/TecnoballZ/download/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image[png]
	media-libs/libmikmod:0"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-gcc6.patch \
		"${FILESDIR}"/${P}-automake.patch
	mv man/${PN}.fr.6 man/fr/${PN}.6 || die
	# don't combine explicit and implicit rules for make 3.82 (bug #334629)
	sed -i -e '/supervisor.c /s/.c /.cc /' src/Makefile.am || die
	sed -i -e '/^CXXFLAGS=/d' configure.ac || die
	eautoreconf
}

src_install() {
	default
	fperms g+w "${GAMES_STATEDIR}"/${PN}.hi
	make_desktop_entry ${PN} Tecnoballz
	prepgamesdirs
}

pkg_postinst() {
	has_version "media-libs/sdl-mixer[mikmod]" \
		|| ewarn "To have background music, emerge sdl-mixer with USE=mikmod"
	games_pkg_postinst
}
