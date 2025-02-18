# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="encrypted-session-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_LINK_MODULES=( www-nginx/ngx_devel_kit )

NGINX_MOD_OPENRESTY_TESTS=1
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-set-misc
	www-nginx/ngx-echo
	www-nginx/ngx-lua-module
)
inherit toolchain-funcs nginx-module

DESCRIPTION="An NGINX module that encrypts and decrypts NGINX variable values"
HOMEPAGE="https://github.com/openresty/encrypted-session-nginx-module"
SRC_URI="
	https://github.com/openresty/encrypted-session-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/openssl:="
RDEPEND="${DEPEND}"

src_configure() {
	# Make sure the module links to libcrypto, independently of whether NGINX
	# has SSL/TLS support.
	ngx_mod_append_libs "$("$(tc-getPKG_CONFIG)" --libs libcrypto)"

	nginx-module_src_configure
}
