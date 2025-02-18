# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Openresty only ever supports luajit.
LUA_COMPAT=( luajit )
inherit lua-single

DESCRIPTION="Nonblocking Lua MySQL driver library for the ngx-lua-module NGINX module"
HOMEPAGE="https://github.com/openresty/lua-resty-mysql"
SRC_URI="
	https://github.com/openresty/lua-resty-mysql/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
# Tests require replicating much of nginx-module_src_test() in each
# dev-lua/lua-resty-* ebuild.
RESTRICT="test"

REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"
DEPEND="${LUA_DEPS}"
RDEPEND="
	${DEPEND}
	dev-lua/lua-resty-string[${LUA_SINGLE_USEDEP}]
	$(lua_gen_cond_dep 'dev-lua/LuaBitOp[${LUA_USEDEP}]')
"

src_configure() {
	# The directory where to Lua files are to be installed, used by the build
	# system.
	export LUA_LIB_DIR="$(lua_get_lmod_dir)"
	default
}
