# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for CGI-enabled webservers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	|| (
		www-servers/apache
		www-servers/lighttpd
		www-servers/boa
		www-servers/fnord
		www-servers/h2o
		www-servers/monkeyd
		www-servers/nginx
		www-servers/thttpd
		www-servers/tomcat
	)
"
