# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_AUTODEPS="false"
KDE_DEBUG="false"
KDE_DOXYGEN="false"
KDE_TEST="false"
KMNAME="breeze"
inherit kde5

DESCRIPTION="Breeze SVG icon theme"
SRC_URI="mirror://kde/stable/plasma/${PV}/${KMNAME}-${PV}.tar.xz"
KEYWORDS=" ~amd64 ~x86"
IUSE=""

DEPEND="$(add_frameworks_dep extra-cmake-modules)"
RDEPEND="!<kde-plasma/breeze-5.4.3:5"

PATCHES=( "${FILESDIR}/${PN}-5.4.3-CMakeLists.txt.patch" )
