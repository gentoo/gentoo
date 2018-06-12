# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="optional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Tools based on KDE Frameworks 5 to better interact with the system"
HOMEPAGE="https://cgit.kde.org/kde-cli-tools.git"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="+kdesu X"

DEPEND="
	$(add_frameworks_dep kactivities)
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	kdesu? ( $(add_frameworks_dep kdesu) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
RDEPEND="${DEPEND}
	!kde-apps/kdesu
"

# requires running kde environment
RESTRICT+=" test"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package kdesu KF5Su)
		$(cmake-utils_use_find_package X Qt5X11Extras)
	)

	kde5_src_configure
}

src_install() {
	kde5_src_install
	use kdesu && dosym ../$(get_libdir)/libexec/kf5/kdesu /usr/bin/kdesu
	use kdesu && dosym ../$(get_libdir)/libexec/kf5/kdesu /usr/bin/kdesu5
}
