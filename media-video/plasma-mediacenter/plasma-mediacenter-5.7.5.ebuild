# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="Unified media experience for any device capable of running KDE Plasma"
SRC_URI="mirror://kde/stable/plasma-mediacenter/${PV}/${P}.tar.xz"
KEYWORDS="amd64 ~arm x86"
IUSE="semantic-desktop"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtxml)
	media-libs/taglib
	semantic-desktop? (
		$(add_frameworks_dep baloo)
		$(add_frameworks_dep kfilemetadata)
	)
"
RDEPEND="${DEPEND}
	$(add_plasma_dep plasma-workspace)
	$(add_qt_dep qtmultimedia 'qml')
	!media-video/plasma-mediacenter:0
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package semantic-desktop KF5Baloo)
	)

	kde5_src_configure
}
