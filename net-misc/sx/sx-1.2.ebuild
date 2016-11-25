# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Skylable SX - a distributed object-storage software for data clusters."
HOMEPAGE="http://www.skylable.com/products/sx"
SRC_URI="http://cdn.skylable.com/source/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 openssl"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="+client ipv6 +server ssl"

# The server build depends on tools only built during client build.
# The client, though, is fully functional without server components
# (for remote access, for example).
# Deactivate both only if you know you need *only* the libs.
REQUIRED_USE="server? ( client )"

nginx_modules_use="nginx_modules_http_fastcgi(-),nginx_modules_http_gzip(-),nginx_modules_http_proxy(-),nginx_modules_http_scgi(-),nginx_modules_http_uwsgi(-)"

DEPEND="
	dev-libs/libltdl:0
	dev-libs/yajl
	net-misc/curl[idn,ipv6(-)?,ssh,ssl(-)?]
	server? ( >=dev-db/sqlite-3.8.4.3:3
		dev-libs/fcgi
		www-servers/nginx:mainline[http,ipv6(-)?,${nginx_modules_use},ssl(-)?] )
"
RDEPEND="${DEPEND}"

LICENSE="GPL-2"

pkg_setup() {
	if ! use client && ! use server; then
		ewarn "********************************************************************************"
		ewarn "You deactivated both the client and the server use-flag. Unless you know what"
		ewarn "you're doing, this software will very likely be very useless to you."
		ewarn "Have a nice day."
		ewarn "********************************************************************************"
	fi
}

src_configure() {
	econf --prefix=/usr/ \
          --sysconfdir=/etc/ \
          --enable-dependency-tracking \
          --disable-silent-rules \
          --disable-sxhttpd \
          --with-system-libs \
          $(use_enable client sxclient) \
          $(use_enable server) \
          || die "Configure failed."
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --all
}
