# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="Warcraft II for the Stratagus game engine"
HOMEPAGE="
	https://stratagus.com/
	https://github.com/Wargus/wargus/
"
SRC_URI="
	https://github.com/Wargus/wargus/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bne"

DEPEND="
	=games-engines/stratagus-${PV}*[theora]
	media-libs/libpng:0=
	sys-libs/zlib:=
	x11-libs/gtk+:2
	x11-libs/libX11
	bne? ( app-arch/stormlib:= )
	!games-strategy/wargus-data
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

pkg_pretend() {
	if has_version games-strategy/wargus-data; then
		ewarn "The system-wide install of game data via games-strategy/wargus-data"
		ewarn "no longer works.  The old data will be uninstalled after merging"
		ewarn "this version of Wargus.  If you would like to preserve it, please"
		ewarn "abort the process and back /usr/share/stratagus/wargus up."
	fi
}

src_configure() {
	local mycmakeargs=(
		-DGAMEDIR="${EPREFIX}/usr/bin"
		-DBINDIR="${EPREFIX}/usr/bin"
		-DSTRATAGUS="${EPREFIX}/usr/bin/stratagus"
		-DSHAREDIR="${EPREFIX}/usr/share/stratagus/wargus"
		-DICONDIR=/usr/share/icons/hicolor/64x64/apps
		-DWITH_STORMLIB=$(usex bne)
	)
	cmake_src_configure
}

pkg_postinst() {
	elog "Wargus requires the data from the original game to run.  The game"
	elog "will ask you for the location of the game data and extract/convert"
	elog "it automatically on the first run."

	if ! has_version media-video/ffmpeg ||
		! has_version media-sound/cdparanoia
	then
		elog
		elog "If you did not convert the game data yet, you may want to install"
		elog "the following optional dependencies:"
		elog
		elog "media-video/ffmpeg -- to convert game videos"
		elog "media-sound/cdparanoia -- to rip game music from the CD"
	fi

	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
