# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils gnome2-utils

DESCRIPTION="A puzzle/platform game with a player and its shadow"
HOMEPAGE="http://meandmyshadow.sourceforge.net/"
SRC_URI="mirror://sourceforge/meandmyshadow/${PV}/${P}-src.tar.gz"

LICENSE="GPL-3 OFL-1.1 CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="opengl"

DEPEND="media-libs/libsdl[sound,video,X]
	media-libs/sdl-gfx
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-image[png]
	dev-libs/openssl:0=
	net-misc/curl
	app-arch/libarchive
	x11-libs/libX11
	opengl? ( virtual/opengl )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch )

src_configure() {
	local mycmakeargs=(
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DBINDIR="/usr/bin"
		-DDATAROOTDIR="/usr/share"
		-DICONDIR=/usr/share/icons
		-DDESKTOPDIR=/usr/share/applications
		$(cmake-utils_use opengl HARDWARE_ACCELERATION)
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc AUTHORS ChangeLog README docs/{Controls,ThemeDescription}.txt
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
