# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="iconv-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_LINK_MODULES=( www-nginx/ngx_devel_kit )

NGINX_MOD_OPENRESTY_TESTS=1
# ngx-iconv must be loaded after ngx-lua-module.
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-lua-module
	www-nginx/ngx-iconv
	www-nginx/ngx-echo
	www-nginx/ngx-set-misc
	www-nginx/ngx-headers-more
)
inherit nginx-module

DESCRIPTION="A character conversion NGINX module using libiconv"
HOMEPAGE="https://github.com/calio/iconv-nginx-module"
SRC_URI="
	https://github.com/calio/iconv-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.14-skip-rds-json-tests.patch"
)
