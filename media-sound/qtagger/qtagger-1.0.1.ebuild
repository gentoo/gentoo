# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit cmake-utils

DESCRIPTION="Simple Qt4 ID3v2 tag editor"
HOMEPAGE="http://code.google.com/p/qtagger"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/taglib
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix doc installation path
	sed -i "s/doc\/${PN}/doc\/${PF}/" CMakeLists.txt
}

src_configure() {
	mycmakeargs="${mycmakeargs}	-DCMAKE_NO_BUILTIN_CHRPATH:BOOL=ON"
	cmake-utils_src_configure
}
