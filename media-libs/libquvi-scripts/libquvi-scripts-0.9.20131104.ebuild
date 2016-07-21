# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Embedded lua scripts for libquvi"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="offensive"

RDEPEND=">=dev-lua/LuaBitOp-1.0.1
	>=dev-lua/luaexpat-1.2.0
	>=dev-lua/luajson-1.1.1
	>=dev-lua/luasocket-2.0.2"
DEPEND="app-arch/xz-utils
	virtual/pkgconfig"

# tests fetch data from live websites
RESTRICT="test"

src_configure() {
	econf \
		$(use_with offensive nsfw) \
		--with-manual
}
