# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for intercepting and handling application crashes"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls X"

# requires running kde environment
RESTRICT+=" test"

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtgui)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
	test? ( $(add_qt_dep qtwidgets) )
	X? ( x11-proto/xproto )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
