# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquvi-scripts/libquvi-scripts-0.9.20131130.ebuild,v 1.5 2014/03/04 20:41:24 vincent Exp $

EAPI=5

DESCRIPTION="Embedded lua scripts for libquvi"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips x86"
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
