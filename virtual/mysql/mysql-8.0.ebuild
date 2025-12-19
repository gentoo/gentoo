# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for MySQL database server"
SLOT="0/18"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="+server static"

RDEPEND="
	|| (
		>=dev-db/mariadb-10.0[server?,static?]
		>=dev-db/mysql-${PV}[server?,static(-)?]
	)
"
