# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="false"
inherit kde5

DESCRIPTION="Helper library to speed up start of applications on KDE work spaces"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+caps +man"

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	x11-libs/libX11
	x11-libs/libxcb
	caps? ( sys-libs/libcap )
"
DEPEND="${RDEPEND}
	man? ( $(add_frameworks_dep kdoctools) )
	x11-proto/xproto
"

PATCHES=( "${FILESDIR}/${P}-cve-2016-3100.patch" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package caps Libcap)
		$(cmake-utils_use_find_package man KF5DocTools)
	)

	kde5_src_configure
}
