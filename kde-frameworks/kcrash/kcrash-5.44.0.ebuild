# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework for intercepting and handling application crashes"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="nls"

# requires running kde environment
RESTRICT+=" test"

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtx11extras)
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-proto/xproto
	nls? ( $(add_qt_dep linguist-tools) )
	test? ( $(add_qt_dep qtwidgets) )
"
