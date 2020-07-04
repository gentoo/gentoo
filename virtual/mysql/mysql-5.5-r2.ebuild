# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Virtual for MySQL client or database"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="static static-libs"

RDEPEND="|| (
	=dev-db/mariadb-${PV}*[static?,static-libs(-)?]
	=dev-db/mysql-${PV}*[static?,static-libs(-)?]
	=dev-db/mysql-cluster-7.2*[static?,static-libs(-)?]
)"
