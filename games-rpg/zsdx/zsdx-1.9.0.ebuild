# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils gnome2-utils games

DESCRIPTION="A free 2D Zelda fangame"
HOMEPAGE="http://www.solarus-games.org/"
SRC_URI="http://www.zelda-solarus.com/downloads/${PN}/${P}.tar.gz"

LICENSE="all-rights-reserved CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=games-engines/solarus-1.3.0
	<games-engines/solarus-1.4.0"
DEPEND="app-arch/zip"

DOCS=( ChangeLog readme.txt )

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_INSTALL_DATAROOTDIR="${GAMES_DATADIR}"
		-DSOLARUS_INSTALL_BINDIR="${GAMES_BINDIR}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	newicon -s 48 build/icons/${PN}_icon_48.png ${PN}.png
	newicon -s 256 build/icons/${PN}_icon_256.png ${PN}.png

	# install proper wrapper script
	rm -f "${ED%/}${GAMES_BINDIR}"/${PN}
	games_make_wrapper ${PN} "solarus \"${GAMES_DATADIR}/solarus/${PN}\""

	make_desktop_entry "${PN}" "Zelda: Mystery of Solarus DX"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
