# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="An NGINX module that adds various set_xxx directives to NGINX's rewrite module"
HOMEPAGE="https://github.com/openresty/set-misc-nginx-module"

SRC_URI="
	https://github.com/openresty/set-misc-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD-2"

SLOT=0

MY_PN="set-misc-nginx-module"

inherit nginx-module

NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

IUSE="+hmac"

DEPEND="
	www-nginx/ngx_devel_kit
	hmac? ( dev-libs/openssl )
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -E -i 's/USE_OPENSSL|MAIL_SSL/GENTOO_USE_HMAC/g' \
		"${NGINX_MOD_S}/config" || die "sed failed"
	sed -i 's/NGX_OPENSSL/GENTOO_USE_HMAC/g' \
		"${NGINX_MOD_S}/src/ngx_http_set_misc_module.c" || die "sed failed"
	if use hmac; then
		sed -E -i 's/^(\s*ngx_module_libs)=$/\1=-lcrypto/' \
			"${NGINX_MOD_S}/config" || die "sed failed"
	fi
	nginx-module_src_prepare
}

src_configure() {
	append-cflags -DNDK
	export NDK_SRCS="ndk.c"
	export GENTOO_USE_HMAC=NO
	if use hmac; then
		export GENTOO_USE_HMAC=YES
		append-cflags -DGENTOO_USE_HMAC=1
	fi
	nginx-module_src_configure
}
