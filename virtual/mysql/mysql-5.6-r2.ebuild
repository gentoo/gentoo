# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mysql/mysql-5.6-r2.ebuild,v 1.11 2015/03/03 10:20:26 dlan Exp $

EAPI="5"

inherit multilib-build

DESCRIPTION="Virtual for MySQL client or database"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/18"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="embedded minimal static static-libs"

DEPEND=""
RDEPEND="|| (
	=dev-db/mariadb-10.0*[embedded=,minimal=,static=,static-libs=,${MULTILIB_USEDEP}]
	=dev-db/mysql-${PV}*[embedded=,minimal=,static=,static-libs=,${MULTILIB_USEDEP}]
	=dev-db/percona-server-${PV}*[embedded=,minimal=,static=,static-libs=,${MULTILIB_USEDEP}]
	=dev-db/mariadb-galera-10.0*[embedded=,minimal=,static=,static-libs=,${MULTILIB_USEDEP}]
	=dev-db/mysql-cluster-7.3*[embedded=,minimal=,static=,static-libs=,${MULTILIB_USEDEP}]
)"
