# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake desktop xdg

DESCRIPTION="Free 2D Zelda fangame parody"
HOMEPAGE="https://www.solarus-games.org/"
SRC_URI="https://gitlab.com/solarus-games/${PN}/-/archive/${PN}-${PV}/${PN}-${PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN}-${PV}"

LICENSE="all-rights-reserved CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND="
	>=games-engines/solarus-1.3.1-r1
	<games-engines/solarus-1.4.0
"
DEPEND="app-arch/zip"

DOCS=( ChangeLog readme.txt )

src_prepare() {
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
	rm "${ED}"/usr/bin/${PN} || die
	make_wrapper ${PN} "solarus \"/usr/share/solarus/${PN}\""

	make_desktop_entry "${PN}" "Zelda: Mystery of Solarus XD"
}
