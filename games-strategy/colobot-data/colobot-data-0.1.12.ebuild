# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_P=colobot-gold-${PV}-alpha
MUSIC_P=colobot-music_ogg_${PV}-alpha

DESCRIPTION="Data package for colobot (Colonize with Bots)"
HOMEPAGE="https://colobot.info/"
SRC_URI="
	https://github.com/colobot/colobot-data/archive/${MY_P}.tar.gz -> ${MY_P}.data.tar.gz
	music? (
		https://colobot.info/files/music/${MUSIC_P}.tar.gz )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+music"

S="${WORKDIR}/${PN}-${MY_P}"

src_unpack() {
	unpack "${MY_P}.data.tar.gz"
	if use music; then
		tar -x -f "${DISTDIR}/${MUSIC_P}.tar.gz" -C "${S}/music" || die "Failed to unpack music"
	fi
}

src_prepare() {
	cmake-utils_src_prepare

	if use music; then
		sed -i -e '/find_program(WGET wget)/d' -e '/if(NOT WGET)/,+2 d' music/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DMUSIC=$(usex music)
		-DMUSIC_FLAC=OFF
	)
	cmake-utils_src_configure
}
