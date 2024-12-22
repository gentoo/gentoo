# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Openresty only ever supports luajit.
LUA_COMPAT=( luajit )
inherit lua-single

DESCRIPTION="Lua-land LRU Cache based on LuaJIT FFI"
HOMEPAGE="https://github.com/openresty/lua-resty-lrucache"
SRC_URI="
	https://github.com/openresty/lua-resty-lrucache/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
# Tests require Test::Nginx perl module, not packaged by Gentoo.
RESTRICT="test"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	${LUA_DEPS}
"
RDEPEND="${DEPEND}"

pkg_setup() {
	lua-single_pkg_setup
	# The directory where to Lua files are to be installed, used by the build
	# system.
	export LUA_LIB_DIR="$(lua_get_lmod_dir)"
}
