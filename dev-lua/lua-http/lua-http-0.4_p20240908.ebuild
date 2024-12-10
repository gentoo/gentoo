# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

DESCRIPTION="HTTP Library for Lua. Supports HTTP(S) 1.0, 1.1 and 2.0; client and server."
HOMEPAGE="https://daurnimator.github.io/lua-http/"
HOMEPAGE+=" https://github.com/daurnimator/lua-http"
EGIT_COMMIT="ee3cf4b4992479b8ebfb39b530694af3bbd1d1eb"
SRC_URI="https://github.com/daurnimator/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc"
REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	dev-lua/basexx[${LUA_USEDEP}]
	dev-lua/binaryheap[${LUA_USEDEP}]
	dev-lua/cqueues[${LUA_USEDEP}]
	dev-lua/fifo[${LUA_USEDEP}]
	dev-lua/lpeg[${LUA_USEDEP}]
	dev-lua/lpeg-patterns[${LUA_USEDEP}]
	dev-lua/LuaBitOp[${LUA_USEDEP}]
	dev-lua/luaossl[${LUA_USEDEP}]
	lua_targets_luajit? ( dev-lua/compat53[lua_targets_luajit(-)] )
	lua_targets_lua5-1? ( dev-lua/compat53[lua_targets_lua5-1(-)] )
"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( virtual/pandoc )"

lua_enable_tests busted

src_compile() {
	default
	use doc && emake -C doc lua-http.html lua-http.3
}

lua_src_install() {
	insinto $(lua_get_lmod_dir)/http/
	doins http/*.lua http/compat/*.lua
}

src_install() {
	lua_foreach_impl lua_src_install
	if use doc; then
		local HTML_DOCS=( doc/lua-http.html )
		doman doc/lua-http.3
	fi
	dodoc -r "examples"
	einstalldocs
}
