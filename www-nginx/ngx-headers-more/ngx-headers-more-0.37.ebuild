# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="headers-more-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_OPENRESTY_TESTS=1
# ngx-headers-more must be loaded after ngx-lua-module module for test to work.
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-lua-module
	www-nginx/ngx-headers-more
	www-nginx/ngx-eval
	www-nginx/ngx-echo
)
inherit nginx-module

DESCRIPTION="Set, add, and clear arbitrary output headers in NGINX HTTP servers"
HOMEPAGE="https://github.com/openresty/headers-more-nginx-module"
SRC_URI="
	https://github.com/openresty/headers-more-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Tests require NGINX to be built with debugging log enabled.
BDEPEND="test? ( www-servers/nginx[debug(-)] )"
