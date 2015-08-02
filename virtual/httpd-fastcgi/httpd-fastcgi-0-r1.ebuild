# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/httpd-fastcgi/httpd-fastcgi-0-r1.ebuild,v 1.3 2015/08/02 22:02:37 monsieurp Exp $

EAPI=5

DESCRIPTION="Virtual for FastCGI-enabled webservers"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="|| (
	www-apache/mod_fcgid
	www-apache/mod_fastcgi
	www-servers/lighttpd
	www-servers/bozohttpd
	www-servers/nginx
	www-servers/resin
	www-servers/cherokee
	)"
DEPEND=""
