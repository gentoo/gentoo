# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils games

DESCRIPTION="Free clone of an excellent NeoGeo puzzle game, Magical Drop"
HOMEPAGE="http://krystaldrop.sourceforge.net/"
SRC_URI="mirror://sourceforge/krystaldrop/art_${PV}.tgz -> ${P}-art.tgz
	mirror://sourceforge/krystaldrop/src_${PV}.tgz -> ${P}-src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="virtual/opengl
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	dev-libs/libxml2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	mv ../art .
	epatch \
		"${FILESDIR}"/krystaldrop-assert.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-as-needed.patch \
		"${FILESDIR}"/${P}-deps.patch \
		"${FILESDIR}"/${P}-icu.patch \
		"${FILESDIR}"/${P}-glibc2.10.patch \
		"${FILESDIR}"/${P}-cxxflags.patch

	sed -i \
		-e "/^EXEDIR:=/ s|$|/bin|" \
		-e "/^INSTALL_PREFIX:=/ s|$|${D}|" Makefile \
		|| die "sed Makefile failed"

	# fix the high score location
	sed -i \
		-e "s:BINDIR:\"${GAMES_STATEDIR}/${PN}\":" \
		Sources/KrystalDrop/Controller/HighScoresController.cpp \
		|| die "sed HighScoresController.cpp failed"
}

src_install() {
	default
	dodir "${GAMES_STATEDIR}/${PN}"
	mv "${D}${GAMES_DATADIR}/${PN}/art/survival.sco" \
		"${D}${GAMES_STATEDIR}/${PN}/" || die "mv failed"
	fperms 664 "${GAMES_STATEDIR}/${PN}/survival.sco"
	doman doc/kdrop.6
	newicon art/drop.png ${PN}.png
	make_desktop_entry kdrop "KrystalDrop" ${PN}

	prepgamesdirs
}
