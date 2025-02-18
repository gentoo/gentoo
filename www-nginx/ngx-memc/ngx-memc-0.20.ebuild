# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="memc-nginx-module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

NGINX_MOD_OPENRESTY_TESTS=1
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-lua-module
	www-nginx/ngx-eval
	www-nginx/ngx-echo
	www-nginx/ngx-set-misc
)
inherit nginx-module

DESCRIPTION="An extended version of the standard NGINX memcached module"
HOMEPAGE="https://github.com/openresty/memc-nginx-module"
SRC_URI="
	https://github.com/openresty/memc-nginx-module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

BDEPEND="test? ( net-misc/memcached )"

PATCHES=(
	"${FILESDIR}/${PN}-0.20-stats_t-do-not-run-timeout-test.patch"
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
