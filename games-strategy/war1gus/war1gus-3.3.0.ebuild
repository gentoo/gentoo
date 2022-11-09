# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Warcraft: Orcs & Humans for the Stratagus game engine"
HOMEPAGE="
	https://stratagus.com/war1gus.html
	https://github.com/Wargus/war1gus/
"
SRC_URI="
	https://github.com/Wargus/war1gus/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	=games-engines/stratagus-${PV}*[theora]
	media-libs/libpng:0=
	sys-libs/zlib:=
	x11-libs/gtk+:2
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DGAMEDIR="${EPREFIX}/usr/bin"
		-DBINDIR="${EPREFIX}/usr/bin"
		-DSTRATAGUS="${EPREFIX}/usr/bin/stratagus"
		-DSHAREDIR="${EPREFIX}/usr/share/stratagus/war1gus"
		-DICONDIR=/usr/share/icons/hicolor/64x64/apps
	)
	cmake_src_configure
}

pkg_postinst() {
	elog "War1gus requires the data from the original game to run.  The game"
	elog "will ask you for the location of the game data and extract/convert"
	elog "it automatically on the first run."

	if ! has_version media-video/ffmpeg ||
		! has_version media-sound/timidity++
	then
		elog
		elog "If you did not convert the game data yet, you may want to install"
		elog "the following optional dependencies:"
		elog
		elog "media-video/ffmpeg -- to convert game videos"
		elog "media-sound/timidity++ -- to convert game music"
	fi

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
