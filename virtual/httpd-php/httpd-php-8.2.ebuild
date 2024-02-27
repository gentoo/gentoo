# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Virtual to provide PHP-enabled webservers"
SLOT="${PV}"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

RDEPEND="|| ( dev-lang/php:${SLOT}[fpm]
			  dev-lang/php:${SLOT}[apache2]
			  dev-lang/php:${SLOT}[cgi] )"
