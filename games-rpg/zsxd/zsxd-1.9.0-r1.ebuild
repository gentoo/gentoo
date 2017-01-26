# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils gnome2-utils cmake-utils

DESCRIPTION="A free 2D Zelda fangame parody"
HOMEPAGE="http://www.solarus-games.org/"
SRC_URI="http://www.zelda-solarus.com/downloads/${PN}/${P}.tar.gz"

LICENSE="all-rights-reserved CC-BY-SA-3.0 GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND=">=games-engines/solarus-1.3.1-r1
	<games-engines/solarus-1.4.0"
DEPEND="app-arch/zip"

DOCS=( ChangeLog readme.txt )

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_INSTALL_DATAROOTDIR="/usr/share"
		-DSOLARUS_INSTALL_BINDIR="/usr/bin"
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
	rm -f "${ED%/}/usr/bin/${PN}
	make_wrapper ${PN} "solarus \"/usr/share/solarus/${PN}\"

	make_desktop_entry "${PN}" "Zelda: Mystery of Solarus XD"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}
