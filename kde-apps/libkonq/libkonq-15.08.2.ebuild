# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-baseapps"
KMMODULE="lib/konq"
CPPUNIT_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="The embeddable part of konqueror"
KEYWORDS="~amd64 ~x86"
IUSE="debug minimal"
RESTRICT="test"

KMSAVELIBS="true"

PATCHES=( "${FILESDIR}/${PN}-4.9.0-cmake.patch" )

src_install() {
	kde4-base_src_install

	if use minimal; then
		rm "${D}"/usr/share/templates/{Directory,HTMLFile,TextFile}.desktop || die
		rm "${D}"/usr/share/templates/{linkPath,linkProgram,linkURL}.desktop || die
		rm "${D}"/usr/share/templates/.source/{Program,URL}.desktop || die
		rm "${D}"/usr/share/templates/.source/{HTMLFile.html,TextFile.txt} || die
	fi
}
