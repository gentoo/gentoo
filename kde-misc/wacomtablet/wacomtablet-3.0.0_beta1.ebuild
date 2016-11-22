# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

#EGIT_BRANCH="releng3.0"
KDE_DOC_DIR="doc/user"
KDE_HANDBOOK="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KControl module for Wacom tablets"
HOMEPAGE="http://kde-apps.org/content/show.php?action=content&content=114856"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

MY_PV=${PV/_/\~}
MY_P=${PN}-${MY_PV}
SRC_URI="http://kde-apps.org/CONTENT/content-files/114856-${MY_P}.tar.xz"

S=${WORKDIR}/${MY_P}

CDEPEND="
	$(add_frameworks_dep extra-cmake-modules)
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
	>=x11-drivers/xf86-input-wacom-0.20.0
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libxcb
"
DEPEND="${CDEPEND}
	sys-devel/gettext
	x11-proto/xproto
"
RDEPEND="${CDEPEND}
	!kde-misc/wacomtablet:4
"

PATCHES=( "${FILESDIR}/${P}-ecm.patch" )
