# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils versionator games

MY_PV=$(delete_all_version_separators)
MY_P=stransball2-v${MY_PV}
FILE=${MY_P}-linux
DEBIAN_PATCH="${PN}_${PV}-3.diff"

DESCRIPTION="Thrust clone"
HOMEPAGE="http://www.braingames.getput.com/stransball2/"
SRC_URI="http://braingames.bugreport.nl/stransball2/${FILE}.zip
	mirror://debian/pool/main/s/${PN}/${DEBIAN_PATCH}.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-libs/libsdl[sound,video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-sound
	media-libs/sge"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P}/sources

src_unpack() {
	unpack ${A}
	mv -f "${FILE}" ${P}
}

src_prepare() {
	cd "${WORKDIR}"
	sed -i \
		-e "s:/usr/share/games:${GAMES_DATADIR}:" \
		"${DEBIAN_PATCH}" || die

	epatch "${DEBIAN_PATCH}"

	local deb_dir=${P}/debian/patches
	rm -f "${deb_dir}"/00list
	epatch "${deb_dir}"/*

	cd "${S}"
	sed -i \
		-e "s: -I/usr/local/include/SDL::" \
		-e "s:-g3 -O3:\$(CXXFLAGS):" \
		-e "s:c++:\$(CXX):" \
		Makefile || die "sed Makefile failed"
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_install() {
	cd ..
	dogamesbin ${PN}
	make_desktop_entry ${PN} "Super Transball 2"
	dodoc readme.txt
	doman debian/supertransball2.6

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r demos graphics maps sound

	prepgamesdirs
}
