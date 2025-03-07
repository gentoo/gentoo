# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream supports luajit only.
LUA_COMPAT=( luajit )

MY_PN="lua-upstream-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_LINK_MODULES=( www-nginx/ngx-lua-module )

NGINX_MOD_OPENRESTY_TESTS=1
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-lua-module
	www-nginx/ngx-echo
)
inherit flag-o-matic lua-single nginx-module

DESCRIPTION="An NGINX C module exposing ngx-lua-module's Lua APIs for NGINX upstreams"
HOMEPAGE="https://github.com/openresty/lua-upstream-nginx-module"
SRC_URI="
	https://github.com/openresty/lua-upstream-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"
DEPEND="${LUA_DEPS}"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.07-skip-invalid-tests.patch"
)

src_configure() {
	ngx_mod_append_libs "$(lua_get_LIBS)"
	append-cflags "$(lua_get_CFLAGS)"

	nginx-module_src_configure
}
