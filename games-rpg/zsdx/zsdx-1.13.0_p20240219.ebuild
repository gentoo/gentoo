# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake desktop wrapper xdg

DESCRIPTION="Free 2D Zelda fangame"
HOMEPAGE="https://www.solarus-games.org/"
MY_COMMIT="e904d7904d74a97a50992b1340431d5d8f341d69"
SRC_URI="https://gitlab.com/solarus-games/${PN}/-/archive/${MY_COMMIT}/${PN}-${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="all-rights-reserved CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"

RDEPEND="
	>=games-engines/solarus-2.0.0
"

BDEPEND="
	app-arch/zip
"

src_prepare() {
	# It's only data files so this is fine; solarus-games/games/zsdx #150
	sed -i -e "s/VERSION 2.6/VERSION 3.10/" CMakeLists.txt
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_INSTALL_DATAROOTDIR="/usr/share"
		-DSOLARUS_INSTALL_BINDIR="/usr/bin"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newicon -s 48 build/icons/${PN}_icon_48.png ${PN}.png
	newicon -s 256 build/icons/${PN}_icon_256.png ${PN}.png

	# install proper wrapper script
	rm "${ED}/usr/bin/${PN}" || die
	make_wrapper ${PN} "solarus-run \"/usr/share/solarus/${PN}\""

	#make_desktop_entry ${PN} "Zelda: Mystery of Solarus DX"
}
