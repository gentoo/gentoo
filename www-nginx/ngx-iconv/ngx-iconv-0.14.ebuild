# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="iconv-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_LINK_MODULES=( www-nginx/ngx_devel_kit )

inherit nginx-module

DESCRIPTION="A character conversion NGINX module using libiconv"
HOMEPAGE="https://github.com/calio/iconv-nginx-module"
SRC_URI="
	https://github.com/calio/iconv-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

RESTRICT="test"

DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"
