# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream supports luajit only.
LUA_COMPAT=( luajit )

MY_PN="lua-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_LINK_MODULES=( www-nginx/ngx_devel_kit )

inherit lua-single nginx-module

DESCRIPTION="A module embedding the power of Lua into NGINX HTTP Servers"
HOMEPAGE="https://github.com/openresty/lua-nginx-module"
SRC_URI="
	https://github.com/openresty/lua-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

# Tests require too much manual patching to get working.
RESTRICT="test"

BDEPEND="virtual/pkgconfig"
DEPEND="${LUA_DEPS}"
RDEPEND="
	${DEPEND}
	dev-lua/lua-resty-core[${LUA_SINGLE_USEDEP}]
	dev-lua/lua-resty-lrucache[${LUA_SINGLE_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.10.27-always-define-NDK.patch"
	"${FILESDIR}/${PN}-0.10.27-do-not-log-non-openresty-lua.patch"
)

src_configure() {
	# The config script does some manual auto-detection, which only looks for
	# luajit-2.0, so we set the necessary variables manually.
	export LUAJIT_LIB="${ESYSROOT}/usr/$(get_libdir)"
	export LUAJIT_INC="$(lua_get_include_dir)"

	nginx-module_src_configure
}

src_install() {
	nginx-module_src_install

	# Install headers from 'src/api' into '/usr/include/nginx/modules'.
	insinto /usr/include/nginx/modules
	find "${NGINX_MOD_S}/src/api" -type f -name '*.h' -print0 | xargs -0 doins
	assert "find failed"
}
