# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="Qt-based keyboard layout switcher"
HOMEPAGE="https://github.com/disels/qxkb"
SRC_URI="https://github.com/disels/qxkb/archive/d7474a06055108c833bbb55b6cdef47e0edfb17d.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	x11-libs/libX11
	x11-libs/libxkbfile"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	x11-apps/setxkbmap"

src_prepare() {
	sed -i -e 's:../language:${CMAKE_SOURCE_DIR}/language:' \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}
