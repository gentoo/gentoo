# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils xdg-utils

DESCRIPTION="A cross-platform image viewer with webm support. Written in qt5"
HOMEPAGE="https://github.com/easymodo/qimgv"
SRC_URI="https://github.com/easymodo/qimgv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-video/mpv[libmpv]
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	# so cmake can find binaries
	sed -i 's/build\/qimgv/${CMAKE_BINARY_DIR}\/qimgv/' CMakeLists.txt || die

	cmake-utils_src_prepare
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
}
