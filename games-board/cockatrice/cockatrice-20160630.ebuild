# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eutils gnome2-utils

DESCRIPTION="An open-source multiplatform software for playing card games over a network"
HOMEPAGE="https://github.com/Cockatrice/Cockatrice"

SRC_URI="https://github.com/Cockatrice/${PN}/archive/2016-06-30-Release.tar.gz -> ${P}.tar.gz"
# As the default help/about display the sha1 we need it
SHA1='277d7e2'
S=${WORKDIR}/"Cockatrice-2016-06-30-Release"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated server"

DEPEND="
	dev-libs/libgcrypt:0
	dev-libs/protobuf
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtprintsupport:5
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

	# Add date in the help about, come from git originally
	sed -i 's/^set(PROJECT_VERSION_FRIENDLY.*/set(PROJECT_VERSION_FRIENDLY \"'${SHA1}'\")/' cmake/getversion.cmake || die "Sed failed!"
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
