# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="A module embedding the power of Lua into NGINX HTTP Servers"
HOMEPAGE="https://github.com/openresty/lua-nginx-module"

SRC_URI="
	https://github.com/openresty/lua-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD-2"

SLOT=0

MY_PN="lua-nginx-module"
inherit nginx-module

NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

BDEPEND="
	virtual/pkgconfig
"

DEPEND="
	dev-lang/lua:5.1
	dev-lang/luajit
"

RDEPEND="${DEPEND}"

pkg_setup() {
	# The config script does some manual auto-detection, which only looks for
	# luajit-2.0, so we set the necessary variables manually.
	export LUAJIT_LIB="${EROOT}/usr/$(get_libdir)"
	export LUAJIT_INC="$(pkg-config luajit --variable=includedir)"
}
