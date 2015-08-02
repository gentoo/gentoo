# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/httpd-basic/httpd-basic-0-r1.ebuild,v 1.2 2015/08/02 18:18:22 monsieurp Exp $

EAPI=5

DESCRIPTION="Virtual for static HTML-enabled webservers"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="|| (
	www-servers/apache
	www-servers/lighttpd
	www-servers/boa
	www-servers/bozohttpd
	www-servers/cherokee
	www-servers/fnord
	www-servers/gorg
	www-servers/monkeyd
	www-servers/nginx
	www-servers/resin
	www-servers/thttpd
	www-servers/tomcat
	www-servers/webfs
	)"
DEPEND=""
