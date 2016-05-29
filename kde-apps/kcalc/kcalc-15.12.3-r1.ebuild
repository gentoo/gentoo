# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_DOXYGEN="true"
KDE_HANDBOOK="forceoptional"
KDE_TEST="true"
inherit kde5

DESCRIPTION="KDE calculator"
HOMEPAGE="https://www.kde.org/applications/utilities/kcalc
https://utils.kde.org/projects/kcalc"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kguiaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep knotifications)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	dev-libs/gmp:0=
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
DEPEND="${RDEPEND}
	$(add_frameworks_dep kinit)
	dev-libs/mpfr:0
	sys-devel/gettext
"

PATCHES=( "${FILESDIR}/${P}-fixsetsize.patch" )
