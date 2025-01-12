# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="encrypted-session-nginx-module"
inherit nginx-module

DESCRIPTION="An NGINX module that encrypts and decrypts NGINX variable values"
HOMEPAGE="https://github.com/openresty/encrypted-session-nginx-module"
SRC_URI="
	https://github.com/openresty/encrypted-session-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
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
	dev-libs/openssl:=
	www-nginx/ngx_devel_kit
"
RDEPEND="${DEPEND}"

src_configure() {
	# Make sure the module links to libcrypto, independently of whether NGINX
	# has SSL/TLS support.
	sed -E -i "s/^(\s*ngx_module_libs)=$/\1=$("$(tc-getPKG_CONFIG)" --libs libcrypto)/" \
		"${NGINX_MOD_S}/config" || die "sed failed"
	# Needed by the build system of the package. Fails otherwise.
	local -x NDK_SRCS="ndk.c"
	nginx-module_src_configure
}
