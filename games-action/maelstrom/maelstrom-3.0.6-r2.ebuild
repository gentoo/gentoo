# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils games

MY_P=Maelstrom-${PV}
DESCRIPTION="An asteroids battle game"
HOMEPAGE="http://www.libsdl.org/projects/Maelstrom/"
SRC_URI="http://www.libsdl.org/projects/Maelstrom/src/${MY_P}.tar.gz"

KEYWORDS="~alpha amd64 ppc x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-net"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-security.patch \
		"${FILESDIR}"/${P}-64bits.patch \
		"${FILESDIR}"/${P}-gcc34.patch \
		"${FILESDIR}"/${P}-warnings.patch

	# Install the data into $(datadir)/..., not $(prefix)/games/...
	sed -i \
		-e "s:(prefix)/games/:(datadir)/:" configure.in || die
	sed -i \
		-e '/make install_gamedata/ { s:=:=$(DESTDIR)/:; s/make/$(MAKE)/; s/install_gamedata/install-binPROGRAMS install_gamedata/; }' Makefile.am || die
	# Install the high scores file in ${GAMES_STATEDIR}
	sed -i \
		-e "s:path.Path(MAELSTROM_SCORES):\"${GAMES_STATEDIR}/\"MAELSTROM_SCORES:" scores.cpp || die
	mv configure.{in,ac}
	rm aclocal.m4 acinclude.m4
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc Changelog README* Docs/{Maelstrom-Announce,*FAQ,MaelstromGPL_press_release,*.Paper,Technical_Notes*}
	newicon "${D}${GAMES_DATADIR}"/Maelstrom/icon.xpm maelstrom.xpm
	make_desktop_entry Maelstrom "Maelstrom" maelstrom

	# Put the high scores file in the right place
	insinto "${GAMES_STATEDIR}"
	doins "${D}${GAMES_DATADIR}"/Maelstrom/Maelstrom-Scores
	# clean up some cruft
	rm -f \
		"${D}${GAMES_DATADIR}"/Maelstrom/Maelstrom-Scores \
		"${D}${GAMES_DATADIR}"/Maelstrom/Images/Makefile*
	# make sure we can update the high scores
	fperms 664 "${GAMES_STATEDIR}"/Maelstrom-Scores
	prepgamesdirs
}
