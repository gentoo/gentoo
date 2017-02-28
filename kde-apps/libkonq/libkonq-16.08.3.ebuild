# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kde-baseapps"
KMMODULE="lib/konq"
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="The embeddable part of konqueror"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"
RESTRICT="test"

KMSAVELIBS="true"

DEPEND="media-libs/phonon[qt4]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-4.9.0-cmake.patch" )
