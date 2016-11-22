# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing access to properties and features of the window manager"
LICENSE="|| ( LGPL-2.1 LGPL-3 ) MIT"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="nls X"

RDEPEND="
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
	X? ( x11-proto/xproto )
"

RESTRICT+=" test"

DOCS=( "docs/README.kstartupinfo" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
