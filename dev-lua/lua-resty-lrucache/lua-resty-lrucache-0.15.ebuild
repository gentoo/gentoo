# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="~amd64 ~arm64"
# Tests require replicating much of nginx-module_src_test() in each
# dev-lua/lua-resty-* ebuild.
RESTRICT="test"

REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

src_configure() {
	# The directory where to Lua files are to be installed, used by the build
	# system.
	export LUA_LIB_DIR="$(lua_get_lmod_dir)"
	default
}
