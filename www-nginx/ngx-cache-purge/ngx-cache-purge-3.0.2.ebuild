# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

MY_PN="ngx_cache_purge"

NGINX_MOD_OPENRESTY_TESTS=1
inherit nginx-module

DESCRIPTION="NGINX module allowing to purge the FastCGI, proxy, SCGI and uWSGI caches"
HOMEPAGE="https://github.com/nginx-modules/ngx_cache_purge"
SRC_URI="https://github.com/nginx-modules/ngx_cache_purge/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2"
SLOT="0"

KEYWORDS="~amd64 ~arm64"

src_configure() {
	# The module's own ./configure is independent of the one that built the
	# installed nginx, so $HTTP_PROXY/$HTTP_FASTCGI/$HTTP_SCGI/$HTTP_UWSGI
	# default to YES regardless of nginx's real USE flags, making every
	# *_cache_purge directive compile in unconditionally and dlopen() die on
	# a missing symbol (bug #969992). Mirror the real flags so $HTTP_*
	# match reality.
	local -a extra_flags=()
	local use_mod
	for use_mod in \
		"nginx_modules_http_proxy:http_proxy" \
		"nginx_modules_http_fastcgi:http_fastcgi" \
		"nginx_modules_http_scgi:http_scgi" \
		"nginx_modules_http_uwsgi:http_uwsgi"
	do
		has_version "www-servers/nginx[${use_mod%%:*}(-)]" ||
			extra_flags+=( "--without-${use_mod##*:}_module" )
	done
	nginx-module_src_configure "${extra_flags[@]}"
}

src_compile() {
	nginx-module_src_compile

	# nginx-module_src_test() sets TEST_NGINX_LOAD_MODULES to ${S}/build/<so>
	# but the .so is built in ${WORKDIR}/nginx/build/ (NGINX_S), not ${S}/build/.
	# Symlink ${S}/build -> ${WORKDIR}/nginx/build so dlopen() resolves correctly.
	if [[ ! -e "${S}/build" ]]; then
		ln -s "${WORKDIR}/nginx/build" "${S}/build" ||
			die "Failed to create ${S}/build symlink for test phase"
	fi
}
