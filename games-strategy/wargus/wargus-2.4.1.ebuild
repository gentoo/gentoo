# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Warcraft II for the Stratagus game engine"
HOMEPAGE="http://wargus.sourceforge.net/"
SRC_URI="https://github.com/Wargus/wargus/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	=games-engines/stratagus-${PV}*[theora]
	media-libs/libpng:0=
	sys-libs/zlib:=
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
PDEPEND="games-strategy/wargus-data"

src_configure() {
	local mycmakeargs=(
		-DGAMEDIR="${EPREFIX}/usr/bin"
		-DBINDIR="${EPREFIX}/usr/bin"
		-DSTRATAGUS="${EPREFIX}/usr/bin"/stratagus
		-DICONDIR=/usr/share/icons/hicolor/64x64/apps
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "Enabling OpenGL in-game seems to cause segfaults/crashes."
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
