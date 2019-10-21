# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
inherit kde5

DESCRIPTION="IDE for the R-project"
HOMEPAGE="https://rkward.kde.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV/b}/src/${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

BDEPEND="
	sys-devel/gettext
"
DEPEND="
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdewebkit)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kjobwidgets)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kservice)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kwindowsystem)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtscript)
	>=dev-qt/qtwebkit-5.212.0_pre20180120:5
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	dev-lang/R
"
RDEPEND="${DEPEND}
	virtual/libintl
	!sci-mathematics/rkward:4
"

PATCHES=( "${FILESDIR}"/${P}-qt-5.13-{1,2,3}.patch)
