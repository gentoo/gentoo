# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="Qt-based multitab terminal emulator"
HOMEPAGE="https://github.com/lxde/qterminal"
EGIT_REPO_URI="https://github.com/lxde/qterminal.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="qt5"

RDEPEND="
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		x11-libs/libqxt
		~x11-libs/qtermwidget-${PV}[qt4]
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		~x11-libs/qtermwidget-${PV}[qt5]
	)
"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=$(usex qt5)
		-DUSE_SYSTEM_QXT=$(usex !qt5)
	)
	cmake-utils_src_configure
}
