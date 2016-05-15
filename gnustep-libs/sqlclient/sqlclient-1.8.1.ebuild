# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit java-pkg-opt-2 gnustep-2

MY_P=${P/sqlc/SQLC}
DESCRIPTION="GNUstep lightweight database abstraction layer"
HOMEPAGE="http://wiki.gnustep.org/index.php/SQLClient"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="LGPL-3"
SLOT="0"

IUSE="java mysql postgres +sqlite"

RDEPEND=">=gnustep-libs/performance-0.3.2
	mysql? ( virtual/mysql:= )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( >=dev-db/sqlite-3 )"
DEPEND="${RDEPEND}"

REQUIRED_USE="|| ( java mysql postgres sqlite )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	if ! use doc; then
		# Remove doc target
		sed -i -e '/documentation\.make/d' GNUmakefile \
			|| die "doc sed failed"
	fi

	default
}

src_configure() {
	local myconf=""
	use java || myconf="${myconf} --disable-jdbc-bundle"
	use mysql || myconf="${myconf} --disable-mysql-bundle"
	use postgres || myconf="${myconf} --disable-postgres-bundle"
	use sqlite || myconf="${myconf} --disable-sqllite-bundle"

	egnustep_env
	econf ${myconf}
}
