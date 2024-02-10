# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

inherit lua-single

DESCRIPTION="Embedded lua scripts for libquvi"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~mips ppc ppc64 sparc x86"
IUSE="offensive"

REQUIRED_USE="${LUA_REQUIRED_USE}"

# tests fetch data from live websites
RESTRICT="test"

RDEPEND="$(lua_gen_cond_dep '
	>=dev-lua/LuaBitOp-1.0.1-r1[${LUA_USEDEP}]
	>=dev-lua/luaexpat-1.3.0-r1[${LUA_USEDEP}]
	>=dev-lua/luajson-1.1.1[${LUA_USEDEP}]
	>=dev-lua/luasocket-3.0_rc1-r2[${LUA_USEDEP}]
')"

BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

src_configure() {
	econf $(use_with offensive nsfw) --with-manual
}
