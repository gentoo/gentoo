# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Data package for colobot (Colonize with Bots)"
HOMEPAGE="https://colobot.info/"
SRC_URI="
	https://github.com/colobot/colobot-data/archive/colobot-gold-${PV}-alpha.zip -> ${P}.zip
	music_ogg? ( https://colobot.info/files/music/colobot-music_ogg_${PV}-alpha.tar.gz -> ${P}-music-ogg.tar.gz )
	music_flac_convert? ( https://colobot.info/files/music/colobot-music_flac_${PV}-alpha.tar.gz -> ${P}-music-flac.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+music music_flac_convert +music_ogg"
REQUIRED_USE="
	music? ( ^^ ( music_flac_convert music_ogg ) )
	music_flac_convert? ( music )
	music_ogg? ( music )"

DEPEND="
	app-arch/unzip
	music_flac_convert? ( media-sound/vorbis-tools )"

S="${WORKDIR}/${PN}-colobot-gold-${PV}-alpha"

src_unpack() {
	unpack "${P}.zip"

	cd "${S}" || die
	if use music; then
		tar xf "${DISTDIR}/${P}"-music-*.tar.gz -C "${S}/music" || die "Failed to unpack music"
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
		-DMUSIC_FLAC=$(usex music_flac_convert)
		-DMUSIC_QUALITY="${COLOBOT_DATA_MUSIC_QUALITY:-4}"
	)
	cmake-utils_src_configure
}
