# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="A simple coverage analyzer for Lua scripts"
HOMEPAGE="https://github.com/keplerproject/luacov"
SRC_URI="https://github.com/keplerproject/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-lua/busted[${LUA_USEDEP}]
		dev-lua/lua_cliargs[${LUA_USEDEP}]
		${RDEPEND}
	)
"

HTML_DOCS=( "docs/." )

lua_src_test() {
	busted --lua=${ELUA} || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto "$(lua_get_lmod_dir)"
	doins src/luacov.lua
	doins -r src/luacov
}

src_install() {
	lua_foreach_impl lua_src_install

	dobin src/bin/luacov

	einstalldocs
}
