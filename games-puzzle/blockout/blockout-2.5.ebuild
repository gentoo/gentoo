# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop

DESCRIPTION="BlockOut II is an adaptation of the original Blockout DOS game"

HOMEPAGE="http://www.blockout.net/blockout2"
SRC_URI="
	mirror://sourceforge/blockout/bl25-src.tar.gz
	mirror://sourceforge/blockout/bl25-linux-x86.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/alsa-lib
	media-libs/libsdl
	media-libs/sdl-mixer
	virtual/glu
	virtual/opengl"

DEPEND="${RDEPEND}"
S="${WORKDIR}"/BL_SRC
PATCHES="${FILESDIR}"/${P}-datadir.patch

src_compile() {
	GAME_DATADIR="/usr/share/${PN}"
	#emake DESTDIR="${D}" -C ImageLib/src
	emake -C ImageLib/src
	#emake DESTDIR="${D}" -C BlockOut GAME_DATA_PREFIX="${GAME_DATADIR}"
	emake -C BlockOut GAME_DATA_PREFIX="${GAME_DATADIR}"
}

src_install() {
	dobin BlockOut/blockout

	insinto "${GAME_DATADIR}"/images
	doins -r "${WORKDIR}"/blockout/images/*

	insinto "${GAME_DATADIR}"/sounds
	doins -r "${WORKDIR}"/blockout/sounds/*

	dodoc "${WORKDIR}"/blockout/README.txt

	newicon "${FILESDIR}/blockout_icon.png" blockout_icon.png
	make_desktop_entry ${PN} BlockOut blockout_icon Game
}
