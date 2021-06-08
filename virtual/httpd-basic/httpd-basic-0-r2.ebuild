# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for static HTML-enabled webservers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	|| (
		www-servers/apache
		www-servers/lighttpd
		www-servers/boa
		www-servers/bozohttpd
		www-servers/cherokee
		www-servers/fnord
		www-servers/hiawatha
		www-servers/monkeyd
		www-servers/nginx
		www-servers/resin
		www-servers/thttpd
		www-servers/tomcat
	)
"
