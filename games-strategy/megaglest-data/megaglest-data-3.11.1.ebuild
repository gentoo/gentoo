# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/megaglest-data/megaglest-data-3.11.1.ebuild,v 1.3 2015/06/21 06:53:10 zlogene Exp $

EAPI=5
inherit cmake-utils games

MY_PN="megaglest"
DESCRIPTION="Data files for the cross-platform 3D realtime strategy game MegaGlest"
HOMEPAGE="http://www.megaglest.org/"
SRC_URI="https://github.com/MegaGlest/megaglest-data/releases/download/${PV}/megaglest-data-${PV}.tar.xz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DOCS=( docs/AUTHORS.data.txt docs/CHANGELOG.txt docs/README.txt )

S=${WORKDIR}/${MY_PN}-${PV}

src_configure() {
	local mycmakeargs=(
		-DMEGAGLEST_BIN_INSTALL_PATH="${GAMES_BINDIR}"
		-DMEGAGLEST_DATA_INSTALL_PATH="${GAMES_DATADIR}/${MY_PN}"
		-DMEGAGLEST_ICON_INSTALL_PATH="/usr/share/pixmaps"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	use doc && HTML_DOCS="docs/glest_factions/"
	cmake-utils_src_install
	prepgamesdirs
}
