# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Plasma screen management library"
SLOT="5/7"
KEYWORDS="amd64 ~arm x86"
IUSE="X"

DEPEND="
	$(add_frameworks_dep kwayland)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtx11extras)
	X? ( x11-libs/libxcb )
"
RDEPEND="${DEPEND}
	!x11-libs/libkscreen:5
"

PATCHES=(
	"${FILESDIR}/${P}-config-fix.patch"
	"${FILESDIR}/${P}-fix-crash.patch"
)

# requires running session
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X XCB)
	)

	kde5_src_configure
}
