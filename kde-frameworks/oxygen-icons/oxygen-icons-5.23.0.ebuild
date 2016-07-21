# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_TEST="true"
KMNAME="oxygen-icons5"
inherit kde5

DESCRIPTION="Oxygen SVG icon theme"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_qt_dep qtcore)
	test? ( $(add_qt_dep qttest) )
"
RDEPEND="
	!<kde-apps/kdepim-15.12.1-r1:5
	!kde-apps/kdepim-icons:4
	!kde-frameworks/oxygen-icons:4
"
