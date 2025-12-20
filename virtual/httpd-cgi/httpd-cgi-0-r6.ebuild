# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for CGI-enabled webservers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	|| (
		www-servers/apache
		www-servers/lighttpd
		www-servers/fnord
		www-servers/h2o
		www-servers/nginx
		www-servers/tomcat
		www-servers/caddy
	)
"
