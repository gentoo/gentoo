# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DESCRIPTION="An NGINX module that encrypts and decrypts NGINX variable values"
HOMEPAGE="https://github.com/openresty/encrypted-session-nginx-module"

SRC_URI="
	https://github.com/openresty/encrypted-session-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
LICENSE="BSD-2"

SLOT=0

MY_PN="encrypted-session-nginx-module"
inherit nginx-module

NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

DEPEND="
	dev-libs/openssl
	www-nginx/ngx_devel_kit
"
RDEPEND="${DEPEND}"

src_configure() {
	append-cflags -DNDK
	sed -E -i 's/^(\s*ngx_module_libs)=$/\1=-lcrypto/' "${NGINX_MOD_S}/config" ||
		die "sed failed"
	export NDK_SRCS="ndk.c"
	nginx-module_src_configure
}
