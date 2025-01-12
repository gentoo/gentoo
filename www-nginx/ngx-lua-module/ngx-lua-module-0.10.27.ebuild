# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="lua-nginx-module"
# Upstream supports luajit only.
LUA_COMPAT=( luajit )
inherit lua-single nginx-module

DESCRIPTION="A module embedding the power of Lua into NGINX HTTP Servers"
HOMEPAGE="https://github.com/openresty/lua-nginx-module"
SRC_URI="
	https://github.com/openresty/lua-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

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
RDEPEND="
	${DEPEND}
	dev-lua/lua-resty-core
	dev-lua/lua-resty-lrucache
"

pkg_setup() {
	lua-single_pkg_setup
	# The config script does some manual auto-detection, which only looks for
	# luajit-2.0, so we set the necessary variables manually.
	export LUAJIT_LIB="${ESYSROOT}/usr/$(get_libdir)"
	export LUAJIT_INC="$(lua_get_include_dir)"
}
