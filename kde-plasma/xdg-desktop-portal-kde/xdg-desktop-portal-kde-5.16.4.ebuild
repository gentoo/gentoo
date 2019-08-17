# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Backend implementation for xdg-desktop-portal that is using Qt/KDE Frameworks"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="screencast"

COMMON_DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport 'cups')
	$(add_qt_dep qtwidgets)
	screencast? (
		dev-libs/glib:2
		media-libs/libepoxy
		media-libs/mesa[gbm]
		media-video/pipewire:=
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kwayland)
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${COMMON_DEPEND}
	screencast? ( sys-apps/xdg-desktop-portal[screencast] )
	!screencast? ( sys-apps/xdg-desktop-portal )
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package screencast GLIB2)
		$(cmake-utils_use_find_package screencast PipeWire)
		$(cmake-utils_use_find_package screencast GBM)
		$(cmake-utils_use_find_package screencast Epoxy)
	)
	kde5_src_configure
}
