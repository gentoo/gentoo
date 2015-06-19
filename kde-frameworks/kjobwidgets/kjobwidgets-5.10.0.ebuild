# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kjobwidgets/kjobwidgets-5.10.0.ebuild,v 1.1 2015/05/09 10:36:07 mrueg Exp $

EAPI=5

inherit kde5

DESCRIPTION="Framework providing assorted widgets for showing the progress of jobs"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="nls X"

RDEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kwidgetsaddons)
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	X? ( dev-qt/qtx11extras:5 )
"
DEPEND="${RDEPEND}
	nls? ( dev-qt/linguist-tools:5 )
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
