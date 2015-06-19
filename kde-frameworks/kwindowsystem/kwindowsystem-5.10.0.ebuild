# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kwindowsystem/kwindowsystem-5.10.0.ebuild,v 1.1 2015/05/09 10:36:07 mrueg Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing access to certain properties and features of the window manager"
LICENSE="LGPL-2+ MIT"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls X"

RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	X? (
		dev-qt/qtx11extras:5
		x11-libs/libX11
		x11-libs/libXfixes
		x11-libs/libxcb
		x11-libs/xcb-util-keysyms
	)
"
DEPEND="${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
	X? ( x11-proto/xproto )
"

RESTRICT="test"

DOCS=( "docs/README.kstartupinfo" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
