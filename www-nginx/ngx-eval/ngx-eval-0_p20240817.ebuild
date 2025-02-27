# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_COMMIT="13425e897c19f4f4436c5ca4414dddd37fc65190"
MY_P="nginx-eval-module-${MY_COMMIT}"
NGINX_MOD_S="${WORKDIR}/${MY_P}"

NGINX_MOD_OPENRESTY_TESTS=1
NGINX_MOD_TEST_LOAD_ORDER=(
	www-nginx/ngx-memc
	www-nginx/ngx-echo
)
inherit nginx-module

DESCRIPTION="An NGINX module that stores subrequest response bodies into variables"
HOMEPAGE="https://github.com/openresty/nginx-eval-module"
SRC_URI="
	https://github.com/openresty/nginx-eval-module/archive/${MY_COMMIT}.tar.gz -> ${MY_P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

BDEPEND="test? ( net-misc/memcached )"

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

	kill "${memcached_pid}" || die "kill failed"
}
