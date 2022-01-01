# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit lua toolchain-funcs

DESCRIPTION="A tool for linting and static analysis of Lua code"
HOMEPAGE="https://github.com/mpeterv/luacheck"
SRC_URI="https://github.com/mpeterv/luacheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lua/lua-argparse[${LUA_USEDEP}]
	dev-lua/lua-utf8[${LUA_USEDEP}]
	dev-lua/luafilesystem[${LUA_USEDEP}]
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	doc? ( dev-python/sphinx )
	test? (
		>=dev-lua/busted-2.0.0-r100[${LUA_USEDEP}]
		${RDEPEND}
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.23.0-disable-measuring-performance-test.patch" )

src_compile() {
	if use doc; then
		sphinx-build docsrc html || die
	fi
}

lua_src_test() {
	busted --lua=${ELUA} || die
}

src_test() {
	lua_foreach_impl lua_src_test
}

lua_src_install() {
	insinto "$(lua_get_lmod_dir)"
	doins -r src/luacheck
}

src_install() {
	lua_foreach_impl lua_src_install

	newbin bin/luacheck.lua luacheck

	use doc && local -a HTML_DOCS=( "html/." )
	einstalldocs
}
