# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_HANDBOOK="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KControl module for Wacom tablets"
HOMEPAGE="https://www.linux-apps.com/content/show.php?action=content&content=114856"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
IUSE=""

CDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdbusaddons)
	$(add_frameworks_dep kglobalaccel)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep plasma)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	>=dev-libs/libwacom-0.30
	>=x11-drivers/xf86-input-wacom-0.20.0
	x11-libs/libXi
	x11-libs/libxcb
"
DEPEND="${CDEPEND}
	sys-devel/gettext
	x11-base/xorg-proto
	x11-libs/libX11
"
RDEPEND="${CDEPEND}
	!kde-misc/wacomtablet:4
"
