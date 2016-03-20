# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Framework providing assorted widgets for showing the progress of jobs"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls X"

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	X? ( $(add_qt_dep qtx11extras) )
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
	X? (
		x11-libs/libX11
		x11-proto/xproto
	)
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
