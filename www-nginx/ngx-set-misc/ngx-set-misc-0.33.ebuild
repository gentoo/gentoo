# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="set-misc-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_LINK_MODULES=( www-nginx/ngx_devel_kit )

NGINX_MOD_OPENRESTY_TESTS=1
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-echo
	www-nginx/ngx-iconv
)
inherit toolchain-funcs nginx-module

DESCRIPTION="An NGINX module that adds various set_xxx directives to NGINX's rewrite module"
HOMEPAGE="https://github.com/openresty/set-misc-nginx-module"
SRC_URI="
	https://github.com/openresty/set-misc-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="+hmac"

BDEPEND="virtual/pkgconfig"
DEPEND="hmac? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.33-hmac-configurable.patch"
	"${FILESDIR}/${PN}-0.33-skip-hashed-upstream_t-test.patch"
)

src_configure() {
	# These are variables patched into the build system to be able to control
	# HMAC support. For more details, see the "hmac-configurable" patch above.
	local -x GENTOO_USE_HMAC=NO
	if use hmac; then
		GENTOO_USE_HMAC=YES
		ngx_mod_append_libs "$("$(tc-getPKG_CONFIG)" --libs libcrypto)"
	fi
	nginx-module_src_configure
}
