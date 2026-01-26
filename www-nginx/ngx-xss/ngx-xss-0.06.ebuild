# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="xss-nginx-module"

# Strangely, 10-year-old tests work perfectly.
NGINX_MOD_OPENRESTY_TESTS=1
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-lua-module
	www-nginx/ngx-echo
)
inherit nginx-module

DESCRIPTION="Native support for cross-site scripting (XSS) in NGINX"
HOMEPAGE="https://github.com/openresty/xss-nginx-module"
SRC_URI="
	https://github.com/openresty/xss-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64"

PATCHES=(
	"${FILESDIR}/${PN}-0.06-add-dynamic-build-support.patch"
)
