# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

DESCRIPTION="Elegant Lua unit testing"
HOMEPAGE="http://olivinelabs.com/busted/"
SRC_URI="https://github.com/Olivine-Labs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lua/lua_cliargs-3.0_p2-r100[${LUA_USEDEP}]
	>=dev-lua/luafilesystem-1.8.0-r100[${LUA_USEDEP}]
	>=dev-lua/luasystem-0.2.1_p0-r100[${LUA_USEDEP}]
	>=dev-lua/dkjson-2.5-r100[${LUA_USEDEP}]
	>=dev-lua/say-1.3_p1-r100[${LUA_USEDEP}]
	>=dev-lua/luassert-1.8.0-r100[${LUA_USEDEP}]
	>=dev-lua/lua-term-0.7-r100[${LUA_USEDEP}]
	>=dev-lua/penlight-1.7.0-r100[${LUA_USEDEP}]
	>=dev-lua/mediator_lua-1.1.2_p0-r100[${LUA_USEDEP}]
	${LUA_DEPS}
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	test? (
		>=dev-lua/busted-2.0.0-r100
		${RDEPEND}
	)
"

lua_src_test() {
	busted --lua=${ELUA} || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto $(lua_get_lmod_dir)
	doins -r busted
}

src_install() {
	dobin bin/busted

	lua_foreach_impl lua_src_install

	einstalldocs
}
