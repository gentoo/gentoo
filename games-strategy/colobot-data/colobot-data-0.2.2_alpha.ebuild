# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

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

src_configure() {
	local mycmakeargs=(
		-DMUSIC=$(usex music)
		-DMUSIC_FLAC=OFF
	)
	cmake_src_configure
}
