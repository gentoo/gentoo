# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="memc-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="An extended version of the standard NGINX memcached module"
HOMEPAGE="https://github.com/openresty/memc-nginx-module"
SRC_URI="
	https://github.com/openresty/memc-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

RESTRICT="test"
