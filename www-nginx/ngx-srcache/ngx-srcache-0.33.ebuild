# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="srcache-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_OPENRESTY_TESTS=1
# ngx-srcache must be after ngx-xss, but before ngx-lua-module. The former might
# be due to the fact that both ngx-xss and ngx-srcache are filters. As for the
# latter, I just don't know.
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-xss
	www-nginx/ngx-srcache
	www-nginx/ngx-lua-module
	www-nginx/ngx-echo
	www-nginx/ngx-memc
)
inherit nginx-module

DESCRIPTION="An NGINX module enabling transparent subrequest-based caching"
HOMEPAGE="https://github.com/openresty/srcache-nginx-module"
SRC_URI="
	https://github.com/openresty/srcache-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Tests require NGINX to be built with debugging log enabled.
BDEPEND="test? ( www-servers/nginx[debug(-)] )"

PATCHES=(
	"${FILESDIR}/${PN}-0.33-disable-invalid-tests.patch"
)

src_test() {
	# Start memcached in background on a port 11211, the default port if
	# environment variable TEST_NGINX_MEMCACHED_PORT is not set.
	# memcached is enclosed in braces so that the not operator properly applies
	# to the asynchronous invocation of memcached.
	if ! { memcached -p 11211 & }
	then
		die "memcached failed"
	fi
	# Save the PID of the launched memcached instance.
	local memcached_pid=$!

	nginx-module_src_test

	kill "${memcached_pid}" || die "killing memcached failed"
}
