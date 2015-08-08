# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="COLLADA Document Object Model (DOM) C++ Library"
HOMEPAGE="http://collada-dom.sourceforge.net/"
SRC_URI="mirror://sourceforge/collada-dom/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	sys-libs/zlib:=[minizip]
	dev-libs/libxml2
	dev-libs/libpcre[cxx]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
