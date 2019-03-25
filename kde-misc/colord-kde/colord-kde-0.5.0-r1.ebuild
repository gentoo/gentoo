# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Provides interfaces and session daemon to colord"
HOMEPAGE="https://cgit.kde.org/colord-kde.git"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz
https://dev.gentoo.org/~asturm/distfiles/${P}-patches.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kcmutils)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	media-libs/lcms:2
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXrandr
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kwindowsystem)
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	x11-misc/colord
"

PATCHES=( "${WORKDIR}/${P}-patches" )

pkg_postinst() {
	kde5_pkg_postinst
	if ! has_version "gnome-extra/gnome-color-manager"; then
		elog "You may want to install gnome-extra/gnome-color-manager to add support for"
		elog "colorhug calibration devices."
	fi
}
