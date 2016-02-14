# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_DOXYGEN="false"
inherit kde5

DESCRIPTION="Breeze SVG icon theme"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="$(add_frameworks_dep extra-cmake-modules)"
RDEPEND="!<kde-plasma/breeze-5.4.3:5"
