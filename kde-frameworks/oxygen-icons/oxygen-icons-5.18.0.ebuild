# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_DOXYGEN="false"
KDE_TEST="false"
KMNAME="oxygen-icons5"
inherit kde5

DESCRIPTION="Oxygen SVG icon theme"
LICENSE="LGPL-3"
KEYWORDS="amd64 ~arm ~x86"
IUSE=""

DEPEND="$(add_frameworks_dep extra-cmake-modules)"
RDEPEND="
	!kde-apps/oxygen-icons
	!kde-frameworks/oxygen-icons:4
"
