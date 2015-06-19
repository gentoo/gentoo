# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mysql/mysql-5.5-r1.ebuild,v 1.1 2015/02/16 18:04:36 grknight Exp $

EAPI="5"

DESCRIPTION="Virtual for MySQL client or database"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="embedded minimal static static-libs"

DEPEND=""
RDEPEND="|| (
	=dev-db/mariadb-${PV}*[embedded=,minimal=,static=,static-libs=]
	=dev-db/mysql-${PV}*[embedded=,minimal=,static=,static-libs=]
	=dev-db/mysql-cluster-7.2*[embedded=,minimal=,static=,static-libs=]
)"
