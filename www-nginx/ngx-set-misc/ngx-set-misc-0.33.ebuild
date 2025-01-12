# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="set-misc-nginx-module"
inherit nginx-module

DESCRIPTION="An NGINX module that adds various set_xxx directives to NGINX's rewrite module"
HOMEPAGE="https://github.com/openresty/set-misc-nginx-module"
SRC_URI="
	https://github.com/openresty/set-misc-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
IUSE="+hmac"
# Tests require Test::Nginx perl module, not packaged by Gentoo.
RESTRICT="test"

BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	www-nginx/ngx_devel_kit
	hmac? ( dev-libs/openssl:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.33-hmac-configurable.patch"
)

src_configure() {
	local -x NDK_SRCS="ndk.c"
	# These are variables patched into the build system to be able to control
	# HMAC support. For more details, see the "hmac-configurable" patch above.
	local -x GENTOO_USE_HMAC=NO
	if use hmac; then
		GENTOO_USE_HMAC=YES
		local -x GENTOO_SET_MISC_LIBS
		GENTOO_SET_MISC_LIBS="$("$(tc-getPKG_CONFIG)" --libs libcrypto)"
		# The code uses #if, not #ifdef, so we define GENTOO_USE_HMAC to 1.
		append-cflags -DGENTOO_USE_HMAC=1
	fi
	nginx-module_src_configure
}
