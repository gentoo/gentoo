# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="KDE Plasma control module for SDDM"
HOMEPAGE="https://projects.kde.org/projects/kdereview/sddm-kcm"

LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm x86"
IUSE=""

COMMON_DEPEND="
	$(add_frameworks_dep kauth)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_qt_dep qtdeclarative 'widgets')
	$(add_qt_dep qtgui)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	x11-libs/libX11
	x11-libs/libXcursor
"
DEPEND="${COMMON_DEPEND}
	x11-libs/libXfixes
"
RDEPEND="${COMMON_DEPEND}
	$(add_plasma_dep kde-cli-tools)
	x11-misc/sddm
	!kde-misc/sddm-kcm
"

DOCS=( CONTRIBUTORS )
