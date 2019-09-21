# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="Program that helps to learn and practice touch typing"
HOMEPAGE="https://kde.org/applications/education/ktouch/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="X"

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kitemviews)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtquickcontrols2)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libxcb[xkb]
		x11-libs/libxkbfile
	)
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kwindowsystem)
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kqtquickcharts)
	$(add_qt_dep qtgraphicaleffects)
"

src_configure() {
	local mycmakeargs=(
		-DCOMPILE_QML=OFF
		$(cmake-utils_use_find_package X X11)
		$(cmake-utils_use_find_package X Qt5X11Extras)
	)
	kde5_src_configure
}
