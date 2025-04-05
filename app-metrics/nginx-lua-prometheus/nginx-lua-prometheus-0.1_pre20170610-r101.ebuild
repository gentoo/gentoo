# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This should be kept in sync with implementations supported
# by www-servers/nginx
LUA_COMPAT=( luajit )

# This is the upstream tag which corresponds to this release.
# It needs to be updated with every bump.
TAG="0.1-20170610"

inherit lua-single

DESCRIPTION="Library that exports Nginx metrics to Prometheus"
HOMEPAGE="https://github.com/knyar/nginx-lua-prometheus"
SRC_URI="https://github.com/knyar/${PN}/archive/${TAG}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${TAG}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"

COMMON_DEPEND="${LUA_DEPS}"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}
	|| (
		www-nginx/ngx-lua-module[${LUA_SINGLE_USEDEP}]
		www-servers/nginx[nginx_modules_http_lua(-),${LUA_SINGLE_USEDEP}]
	)
"

src_install() {
	insinto "$(lua_get_lmod_dir)"/${PN}
	doins prometheus.lua
	dodoc *.md
}
