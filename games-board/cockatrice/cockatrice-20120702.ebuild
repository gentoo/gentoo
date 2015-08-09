# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils gnome2-utils games

DESCRIPTION="An open-source multiplatform software for playing card games over a network"
HOMEPAGE="http://cockatrice.de/"
SRC_URI="http://cockatrice.de/files/${PN}_source_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dedicated server"

DEPEND="
	dev-libs/libgcrypt:0
	dev-libs/protobuf
	dev-qt/qtcore:4
	dev-qt/qtsql:4
	!dedicated? (
		dev-qt/qtmultimedia:4
		dev-qt/qtsvg:4
		dev-qt/qtgui:4
	)"

S=${WORKDIR}/${PN}_${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-underlinking.patch
}

src_configure() {
	local mycmakeargs=(
		$(usex dedicated "-DWITHOUT_CLIENT=1 -DWITH_SERVER=1" "$(usex server "-DWITH_SERVER=1" "")")
		-DCMAKE_INSTALL_BINDIR="${GAMES_BINDIR}"
		-DCMAKE_INSTALL_PREFIX="${GAMES_PREFIX}"
		-DDATADIR="${GAMES_DATADIR}/${PN}"
		-DICONDIR="/usr/share/icons"
		-DDESKTOPDIR="/usr/share/applications"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	elog "zonebg pictures are in ${GAMES_DATADIR}/${PN}/zonebg"
	elog "sounds are in ${GAMES_DATADIR}/${PN}/sounds"
	elog "you can use those directories in cockatrice settings"
	use dedicated || gnome2_icon_cache_update
}

pkg_postrm() {
	use dedicated || gnome2_icon_cache_update
}
