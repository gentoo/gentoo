# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/collada-dom/collada-dom-2.4.0.ebuild,v 1.3 2014/10/24 09:19:49 aballier Exp $

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
