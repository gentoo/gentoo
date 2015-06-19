# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquvi-scripts/libquvi-scripts-0.9.20131130-r1.ebuild,v 1.7 2015/05/15 07:42:06 pacho Exp $

EAPI=5

# note: if pkg-config lands in /usr/share, multilib-build with Lua module
# RDEPs will be enough.
inherit multilib-minimal

DESCRIPTION="Embedded lua scripts for libquvi"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 x86"
IUSE="offensive"

RDEPEND=">=dev-lua/LuaBitOp-1.0.1-r1[${MULTILIB_USEDEP}]
	>=dev-lua/luaexpat-1.3.0-r1[${MULTILIB_USEDEP}]
	>=dev-lua/luajson-1.1.1
	>=dev-lua/luasocket-3.0_rc1-r2[${MULTILIB_USEDEP}]"
DEPEND="app-arch/xz-utils
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

# tests fetch data from live websites
RESTRICT="test"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		$(use_with offensive nsfw) \
		--with-manual
}
