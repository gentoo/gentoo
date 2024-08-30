# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for static HTML-enabled webservers"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"

RDEPEND="
	|| (
		www-servers/apache
		www-servers/lighttpd
		www-servers/fnord
		www-servers/h2o
		www-servers/nginx
		www-servers/tomcat
	)
"
