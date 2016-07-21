# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Skylable SX - a distributed object-storage software for data clusters"
HOMEPAGE="http://www.skylable.com/products/sx"
SRC_URI="http://cdn.skylable.com/source/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1"
# If a package appears that links against another .so apart from sxclient-2.0.0.so, change the subslot accordingly.
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="+client ipv6 +server ssl"
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

# The server build depends on tools only built during client build.
# The client, though, is fully functional without server components
# (for remote access, for example).
# Deactivate both only if you know you need *only* the libs.
REQUIRED_USE="server? ( client )"

# tests make a temporary install relative to $prefix, so docdir must be relative to it as well
src_configure() {
	econf --disable-sxhttpd \
          --with-system-libs \
          --docdir="\${prefix}/usr/share/doc/${PF}" \
          $(use_enable client sxclient) \
          $(use_enable server)
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --all
}
