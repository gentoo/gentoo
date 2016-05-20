# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Function key (FN) monitoring for Toshiba laptops"
HOMEPAGE="http://ktoshiba.sourceforge.net/"
SRC_URI="http://prdownloads.sourceforge.net/${PN}/${P}.tar.xz"
LICENSE="GPL-2"

KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	net-libs/libmnl
"

DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_configure() {
	local mycmakeargs=(
		-DLIBMNL_INCLUDE_DIRS=/usr/include/libmnl
	)
	kde5_src_configure
}
