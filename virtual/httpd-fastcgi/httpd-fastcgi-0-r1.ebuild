# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for FastCGI-enabled webservers"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	|| (
		www-apache/mod_fcgid
		www-servers/lighttpd
		www-servers/bozohttpd
		www-servers/nginx
		www-servers/resin
		www-servers/cherokee
	)
"
