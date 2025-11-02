# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ngx_cache_purge"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_OPENRESTY_TESTS=1
inherit nginx-module

DESCRIPTION="NGINX module allowing to purge the FastCGI, proxy, SCGI and uWSGI caches"
HOMEPAGE="https://github.com/FRiCKLE/ngx_cache_purge"
SRC_URI="
	https://github.com/FRiCKLE/ngx_cache_purge/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}/${PN}-2.3-add-dynamic-module-support.patch"
	"${FILESDIR}/${PN}-2.3-do-not-set-proxy_temp_path.patch"
)
