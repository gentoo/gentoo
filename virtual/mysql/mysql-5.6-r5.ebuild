# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mysql/mysql-5.6-r5.ebuild,v 1.1 2015/07/29 01:45:06 grknight Exp $

EAPI="5"

inherit multilib-build

DESCRIPTION="Virtual for MySQL database server"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/18"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="embedded static static-libs"

DEPEND=""
RDEPEND="
	virtual/libmysqlclient[static-libs?,${MULTILIB_USEDEP}]
	|| (
		=dev-db/mariadb-10.1*[embedded=,static=]
		=dev-db/mariadb-10.0*[embedded=,static=]
		=dev-db/mysql-${PV}*[embedded=,static=]
		=dev-db/percona-server-${PV}*[embedded=,static=]
		=dev-db/mariadb-galera-10.0*[embedded=,static=]
		=dev-db/mysql-cluster-7.3*[embedded=,static=]
	)"
