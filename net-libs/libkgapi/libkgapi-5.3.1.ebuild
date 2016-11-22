# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="true"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Library for accessing Google calendar and contact resources"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libkgapi"
[[ ${KDE_BUILD_TYPE} != live ]] && SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2+ LGPL-2.1+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kwindowsystem)
	$(add_kdeapps_dep kcalcore)
	$(add_kdeapps_dep kcontacts)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
"
RDEPEND="${DEPEND}"
