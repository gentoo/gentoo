# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pugixml/pugixml-1.5.ebuild,v 1.5 2015/04/19 09:50:12 ago Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="http://pugixml.org/ https://github.com/zeux/pugixml/"
SRC_URI="https://github.com/zeux/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"

S=${WORKDIR}/${P}/scripts

src_configure() {
	local mycmakeargs=( -DBUILD_SHARED_LIBS=ON )
	cmake-utils_src_configure
}
