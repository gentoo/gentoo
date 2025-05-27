# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg-utils

DESCRIPTION="A new mail system tray notification icon for Thunderbird"
HOMEPAGE="https://github.com/gyunaev/birdtray"

# bug 951139 - Add a snapshot to use qt6
# Just appended '20250318' into src/version.h to display that is a snapshot version
SRC_URI="https://dev.gentoo.org/~ago/distfiles/birdtray-1.11.4_p20250318.tar.xz"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"

RDEPEND="dev-db/sqlite:=
	dev-qt/qtbase:6[gui,network,ssl,widgets]
	dev-qt/qtsvg:6
	x11-libs/libX11"

DEPEND="${RDEPEND}"

# https://github.com/gyunaev/birdtray/commit/74a97df3a17efd5ef679b8eed6999b97abc23f10
# translations have been made optional, let's see how we would manage them
BDEPEND="dev-qt/qttools:6"

src_prepare() {
	# https://github.com/gyunaev/birdtray/issues/606
	sed -i 's/Qt5LinguistTools/Qt6LinguistTools/g' CMakeLists.txt || die
	sed -i 's/qt5_/qt6_/g' CMakeLists.txt || die

	cmake_src_prepare
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
