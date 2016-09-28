# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils eutils gnome2-utils

DESCRIPTION="An open-source multiplatform software for playing card games over a network"
HOMEPAGE="https://github.com/Cockatrice/Cockatrice"

SRC_URI="https://github.com/Cockatrice/${PN}/archive/2016-05-06-Release.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/"Cockatrice-2016-05-06-Release"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated server"

DEPEND="
	dev-libs/libgcrypt:0
	dev-libs/protobuf
	dev-qt/linguist-tools
	dev-qt/qtconcurrent
	dev-qt/qtcore:5
	dev-qt/qtprintsupport
	!dedicated? (
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtsvg:5
	)"

src_configure() {
	local mycmakeargs=(
		$(usex dedicated "-DWITHOUT_CLIENT=1 -DWITH_SERVER=1" "$(usex server "-DWITH_SERVER=1" "")")
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
}

pkg_preinst() {
	use dedicated || gnome2_icon_savelist
}

pkg_postinst() {
	#FIXME:
	elog "zonebg pictures are in ${GAMES_DATADIR}/${PN}/zonebg"
	elog "sounds are in ${GAMES_DATADIR}/${PN}/sounds"
	elog "you can use those directories in cockatrice settings"
	use dedicated || gnome2_icon_cache_update
}

pkg_postrm() {
	use dedicated || gnome2_icon_cache_update
}
