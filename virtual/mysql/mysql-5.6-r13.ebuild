# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for MySQL database server"
SLOT="0/18"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="embedded +server static"

RDEPEND="|| (
		>=dev-db/mariadb-10.0[embedded(-)?,server?,static?]
		>=dev-db/mysql-${PV}[embedded(-)?,server?,static(-)?]
		>=dev-db/percona-server-${PV}[embedded(-)?,server?,static(-)?]
		>=dev-db/mysql-cluster-7.3[embedded(-)?,server?,static(-)?]
	)
"
