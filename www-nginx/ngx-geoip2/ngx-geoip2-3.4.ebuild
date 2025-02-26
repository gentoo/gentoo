# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ngx_http_geoip2_module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX GeoIP2 module"
HOMEPAGE="https://github.com/leev/ngx_http_geoip2_module"
SRC_URI="
	https://github.com/leev/ngx_http_geoip2_module/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"

DEPEND="dev-libs/libmaxminddb"
RDEPEND="${DEPEND}"

src_configure() {
	# Always build the stream module.
	myconf=( --with-stream )
	nginx-module_src_configure "${myconf[@]}"
}

pkg_postinst() {
	nginx-module_pkg_postinst

	einfo ""
	ewarn "If you want to use the stream module, make sure that www-servers/nginx"
	ewarn "has USE=\"stream\" set. Please refer to the Gentoo AMD64 Handbook for"
	ewarn "instructions on how to declare USE flags."
}
