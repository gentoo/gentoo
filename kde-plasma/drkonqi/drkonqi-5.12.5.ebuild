# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Plasma crash handler, gives the user feedback if a program crashed"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="X"

COMMON_DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kidletime)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwallet)
	$(add_frameworks_dep kwayland)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlrpcclient)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	X? ( $(add_qt_dep qtx11extras) )
"
DEPEND="${COMMON_DEPEND}
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${COMMON_DEPEND}
	!kde-apps/drkonqi:4
	!<kde-plasma/plasma-workspace-5.10.95:5
"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package X Qt5X11Extras)
	)
	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst
	if ! has_version "sys-devel/gdb"; then
		elog "For more usability consider installing the following package:"
		elog "    sys-devel/gdb - Easier debugging support"
	fi
}
