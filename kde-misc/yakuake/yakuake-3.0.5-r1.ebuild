# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Quake-style terminal emulator based on konsole"
HOMEPAGE="https://yakuake.kde.org/"
if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz
	https://dev.gentoo.org/~asturm/distfiles/${P}-patches.tar.xz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2 LGPL-2"
IUSE="absolute-position X"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep knotifyconfig)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep konsole)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	absolute-position? ( $(add_frameworks_dep kwayland) )
	X? (
		$(add_qt_dep qtx11extras)
		x11-libs/libX11
	)
"
RDEPEND="${DEPEND}
	!kde-misc/yakuake:4
"

PATCHES=( "${WORKDIR}/${P}-patches" )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package absolute-position KF5Wayland)
		$(cmake-utils_use_find_package X X11)
	)

	kde5_src_configure
}
