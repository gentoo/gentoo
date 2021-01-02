# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Puzzle/platform game with a player and its shadow"
HOMEPAGE="https://acmepjz.github.io/meandmyshadow/
https://github.com/acmepjz/meandmyshadow/"
SRC_URI="mirror://sourceforge/meandmyshadow/${PV}/${P}-src.tar.gz"

LICENSE="GPL-3 OFL-1.1 CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

DEPEND="
	app-arch/libarchive
	dev-libs/openssl:0=
	media-libs/libsdl[sound,video,X]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	net-misc/curl
	x11-libs/libX11
	opengl? ( virtual/opengl )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README docs/{Controls,ThemeDescription}.txt )

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DBINDIR="/usr/bin"
		-DDATAROOTDIR="/usr/share"
		-DICONDIR=/usr/share/icons
		-DDESKTOPDIR=/usr/share/applications
		-DHARDWARE_ACCELERATION=$(usex opengl)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
