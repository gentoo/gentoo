# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake python-any-r1

MY_PV=${PV/_/-}
MY_P=colobot-gold-${MY_PV}
MUSIC_P=colobot-music_ogg_${MY_PV}

DESCRIPTION="Data package for colobot (Colonize with Bots)"
HOMEPAGE="
	https://colobot.info/
	https://github.com/colobot/colobot-data/
"
SRC_URI="
	https://github.com/colobot/colobot-data/archive/${MY_P}.tar.gz
		-> ${MY_P}.data.tar.gz
	music? (
		https://colobot.info/files/music/${MUSIC_P}.tar.gz
	)
"
S=${WORKDIR}/${PN}-${MY_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+music"

BDEPEND=${PYTHON_DEPS}

src_unpack() {
	unpack "${MY_P}.data.tar.gz"
	if use music; then
		tar -x -f "${DISTDIR}/${MUSIC_P}.tar.gz" -C "${S}/music" ||
			die "Failed to unpack music"
	fi
}

src_prepare() {
	cmake_src_prepare

	if use music; then
		sed -e '/find_program(WGET wget)/d' \
			-e '/if(NOT WGET)/,+2 d' \
			-i music/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DMUSIC=$(usex music)
		-DMUSIC_FLAC=OFF
	)
	cmake_src_configure
}
