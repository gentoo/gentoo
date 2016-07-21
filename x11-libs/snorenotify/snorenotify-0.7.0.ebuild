# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils virtualx

DESCRIPTION="Multi platform Qt notification framework"
HOMEPAGE="https://techbase.kde.org/Projects/Snorenotify"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="sound test"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebsockets:5
	dev-qt/qtwidgets:5
	sound? ( dev-qt/qtmultimedia:5 )
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
	kde-frameworks/extra-cmake-modules
	test? ( dev-qt/qttest:5 )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package sound Qt5Multimedia)
		$(cmake-utils_use_find_package test Qt5Test)
	)

	cmake-utils_src_configure
}

src_test() {
	virtx cmake-utils_src_test
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
