# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Openresty only ever supports luajit.
LUA_COMPAT=( luajit )
inherit lua-single

DESCRIPTION="String utilities and common hash functions for the ngx-lua-module NGINX module"
HOMEPAGE="https://github.com/openresty/lua-resty-string"
SRC_URI="
	https://github.com/openresty/lua-resty-string/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
# Tests require replicating much of nginx-module_src_test() in each
# dev-lua/lua-resty-* ebuild.
RESTRICT="test"

REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"
# www-nginx/ngx-lua-module[test] depends on dev-lua/lua-resty-mysql, which, in
# turn, depends on dev-lua/lua-resty-string (this package). lua-resty-string
# requires SSL support to function, so www-nginx/ngx-lua-module[ssl] is put into
# PDEPEND to avoid circular dependencies.
PDEPEND="www-nginx/ngx-lua-module[${LUA_SINGLE_USEDEP},ssl(-)]"

src_configure() {
	# The directory where to Lua files are to be installed, used by the build
	# system.
	export LUA_LIB_DIR="$(lua_get_lmod_dir)"
	default
}
