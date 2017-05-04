# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Desktop agnostic launcher"
HOMEPAGE="https://github.com/manuelschneid3r/albert"
SRC_URI="https://github.com/manuelschneid3r/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND="
	dev-cpp/muParser
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -e "s/DESTINATION lib/DESTINATION $(get_libdir)/" \
		-i src/plugins/*/CMakeLists.txt \
		-i src/lib/*/CMakeLists.txt || die
	cmake-utils_src_prepare
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
