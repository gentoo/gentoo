# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Backend implementation for xdg-desktop-portal that is using Qt/KDE Frameworks"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE=""

# TODO: Needed for screencast portal
# 	dev-libs/glib:2
# 	media-libs/libepoxy
# 	media-libs/mesa[gbm]
# not packaged: PipeWire
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
"
DEPEND="${COMMON_DEPEND}
	$(add_frameworks_dep kwayland)
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/xdg-desktop-portal
"

PATCHES=( "${FILESDIR}/${P}-appchooser.patch" )
