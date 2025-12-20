# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for FastCGI-enabled webservers"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"

RDEPEND="
	|| (
		www-apache/mod_fcgid
		www-servers/lighttpd
		www-servers/h2o
		www-servers/nginx
	)
"
