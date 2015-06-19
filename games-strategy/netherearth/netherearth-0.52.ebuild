# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/netherearth/netherearth-0.52.ebuild,v 1.11 2015/03/30 21:25:15 mr_bones_ Exp $

EAPI=5
inherit eutils games

MY_PV="${PV/./}"
DESCRIPTION="A remake of the SPECTRUM game Nether Earth"
HOMEPAGE="http://www.braingames.getput.com/nether/"
SRC_URI="http://www.braingames.getput.com/nether/sources.zip
	http://www.braingames.getput.com/nether/${PN}${MY_PV}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND=">=media-libs/libsdl-1.2.6-r3
	>=media-libs/sdl-mixer-1.2.5-r1
	media-libs/freeglut"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/sources

data=../nether\ earth\ v${PV}

src_unpack() {
	unzip -LL "${DISTDIR}/${PN}${MY_PV}.zip" >/dev/null || die
	unzip -LL "${DISTDIR}/sources.zip" >/dev/null || die
}

src_prepare() {
	DATA_DIR=${GAMES_DATADIR}/${PN}

	cp "${FILESDIR}/Makefile" . || die

	# Fix compilation errors/warnings
	epatch "${FILESDIR}"/${P}-linux.patch

	epatch "${FILESDIR}"/${P}-freeglut.patch \
		"${FILESDIR}"/${P}-glibc-212.patch \
		"${FILESDIR}"/${P}-ldflags.patch

	# Modify dirs and some fopen() permissions
	epatch "${FILESDIR}/${P}-gentoo-paths.patch"
	sed -i \
		-e "s:models:${DATA_DIR}/models:" \
		-e "s:textures:${DATA_DIR}/textures:" \
		-e "s:maps/\*:${DATA_DIR}/maps/\*:" \
		-e "s:\./maps:${DATA_DIR}/maps:" \
		mainmenu.cpp || die
	sed -i \
		-e "s:models:${DATA_DIR}/models:g" \
		-e "s:textures:${DATA_DIR}/textures:" \
		-e "s:sound/:${DATA_DIR}/sound/:" \
		nether.cpp || die
	sed -i -e "s:maps:${DATA_DIR}/maps:" \
		main.cpp || die
	sed -i -e "s:textures/:${DATA_DIR}/textures/:" \
		myglutaux.cpp || die

	cd "${data}"
	rm textures/thumbs.db
}

src_install() {
	dogamesbin nether_earth

	cd "${data}"

	# Install all game data
	insinto "${DATA_DIR}"
	doins -r maps models sound textures

	dodoc readme.txt

	prepgamesdirs
}
