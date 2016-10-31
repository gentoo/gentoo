# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit git-r3

DESCRIPTION="System performance benchmark"
HOMEPAGE="https://github.com/akopytov/sysbench"

EGIT_REPO_URI="https://github.com/akopytov/sysbench.git"
EGIT_BRANCH="1.0"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="aio lua mysql postgres test"

RDEPEND="aio? ( dev-libs/libaio )
	lua? ( dev-lang/lua:= )
	mysql? ( virtual/libmysqlclient )
	postgres? ( dev-db/postgresql:= )"
DEPEND="${RDEPEND}
	sys-devel/libtool:=
	dev-libs/libxslt
	test? ( dev-util/cram )"

REQUIRED_USE="
	mysql? ( lua )
	postgres? ( lua )"

src_prepare() {
	default

	sed -i -e "/^htmldir =/s:=.*:=/usr/share/doc/${PF}/html:" doc/Makefile.am || die

	./autogen.sh || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable aio aio)
		$(use_with lua lua)
		$(use_with mysql mysql)
		$(use_with postgres pgsql)
		--without-attachsql
		--without-drizzle
		--without-oracle
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake check test
}
