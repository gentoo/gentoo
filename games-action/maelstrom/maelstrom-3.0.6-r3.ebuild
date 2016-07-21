# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils user

MY_P=Maelstrom-${PV}
DESCRIPTION="An asteroids battle game"
HOMEPAGE="http://www.libsdl.org/projects/Maelstrom/"
SRC_URI="http://www.libsdl.org/projects/Maelstrom/src/${MY_P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
		media-libs/sdl-net"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-security.patch
	"${FILESDIR}"/${P}-64bits.patch
	"${FILESDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-warnings.patch
	"${FILESDIR}"/${P}-gcc53.patch
)

pkg_setup(){
	enewgroup gamestat 36
}

src_prepare() {
	default

	# Install the data into $(datadir)/..., not $(prefix)/games/...
	sed -i \
		-e "s:(prefix)/games/:(datadir)/:" configure.in || die
	sed -i \
		-e '/make install_gamedata/ { s:=:=$(DESTDIR)/:; s/make/$(MAKE)/; s/install_gamedata/install-binPROGRAMS install_gamedata/; }' Makefile.am || die
	# Install the high scores file in ${GAMES_STATEDIR}
	sed -i \
		-e "s:path.Path(MAELSTROM_SCORES):\"/var/games/\"MAELSTROM_SCORES:" scores.cpp || die
	mv configure.{in,ac}
	rm aclocal.m4 acinclude.m4
	eautoreconf
}

src_install() {
	default
	dodoc Changelog Docs/{Maelstrom-Announce,*FAQ,MaelstromGPL_press_release,*.Paper,Technical_Notes*}

	newicon "${D}/usr/share/Maelstrom/icon.xpm" maelstrom.xpm
	make_desktop_entry Maelstrom "Maelstrom" maelstrom

	# Put the high scores file in the right place
	insinto /var/games
	doins "${D}/usr/share/Maelstrom/Maelstrom-Scores"

	# clean up some cruft
	rm -f \
		"${D}/usr/share/Maelstrom/Maelstrom-Scores" \
		"${D}/usr/share/Maelstrom/Images/Makefile*"

	# make sure we can update the high scores
	fowners root:gamestat /var/games/Maelstrom-Scores /usr/bin/Maelstrom{,-netd}
	fperms 2755 /usr/bin/Maelstrom{,-netd}
	fperms 660 /var/games/Maelstrom-Scores
}
